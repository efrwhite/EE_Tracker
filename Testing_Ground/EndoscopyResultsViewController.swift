//
//  EndoscopyResultsViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 10/22/24.
//

import Foundation
import UIKit
import Charts
import CoreData

class EndoscopyResultsViewController: UIViewController {

    var user: String = ""
    var childName: String = ""

    let chartView: LineChartView = {
        let chart = LineChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchEndoscopyResults()
    }

    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(chartView)
        
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            chartView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        chartView.noDataText = "No data available. Please add results."
    }

    // Fetch data from Core Data and populate the chart
    func fetchEndoscopyResults() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Endoscopy")
        
        do {
            let results = try context.fetch(fetchRequest)
            var upperValues: [ChartDataEntry] = []
            var middleValues: [ChartDataEntry] = []
            var lowerValues: [ChartDataEntry] = []

            var dateEntries: [String] = []
            
            for (index, result) in results.enumerated() {
                // Retrieve values for each body section
                if let upper = result.value(forKey: "upper") as? Double,
                   let middle = result.value(forKey: "middle") as? Double,
                   let lower = result.value(forKey: "lower") as? Double,
                   let date = result.value(forKey: "date") as? Date {
                    
                    let timeInterval = date.timeIntervalSince1970
                    upperValues.append(ChartDataEntry(x: timeInterval, y: upper))
                    middleValues.append(ChartDataEntry(x: timeInterval, y: middle))
                    lowerValues.append(ChartDataEntry(x: timeInterval, y: lower))
                    
                    // Format date for x-axis label
                    let formatter = DateFormatter()
                    formatter.dateStyle = .short
                    let dateString = formatter.string(from: date)
                    dateEntries.append(dateString)
                }
            }
            
            setChartData(upperData: upperValues, middleData: middleValues, lowerData: lowerValues, dateEntries: dateEntries)
            
        } catch let error as NSError {
            print("Could not fetch data. \(error), \(error.userInfo)")
        }
    }

    func setChartData(upperData: [ChartDataEntry], middleData: [ChartDataEntry], lowerData: [ChartDataEntry], dateEntries: [String]) {
        let upperDataSet = LineChartDataSet(entries: upperData, label: "Upper")
        upperDataSet.colors = [.red]
        upperDataSet.circleColors = [.red]
        upperDataSet.circleRadius = 4
        upperDataSet.valueColors = [.red]
        
        let middleDataSet = LineChartDataSet(entries: middleData, label: "Middle")
        middleDataSet.colors = [.green]
        middleDataSet.circleColors = [.green]
        middleDataSet.circleRadius = 4
        middleDataSet.valueColors = [.green]
        
        let lowerDataSet = LineChartDataSet(entries: lowerData, label: "Lower")
        lowerDataSet.colors = [.blue]
        lowerDataSet.circleColors = [.blue]
        lowerDataSet.circleRadius = 4
        lowerDataSet.valueColors = [.blue]
        
        // Combine the datasets
        let data = LineChartData(dataSets: [upperDataSet, middleDataSet, lowerDataSet])
        chartView.data = data
        
        // Customize the x-axis to show dates
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateEntries)
        chartView.xAxis.granularity = 1
        chartView.xAxis.labelRotationAngle = -45
    }
}
