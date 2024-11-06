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
    
    // Text view to display history of endoscopy data
    let historyTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .black
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 8
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchEndoscopyResults()
    }

    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(chartView)
        view.addSubview(historyTextView)
        
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            chartView.heightAnchor.constraint(equalToConstant: 300),
            
            historyTextView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 20),
            historyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            historyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            historyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        chartView.noDataText = "No data available. Please add results."
        chartView.legend.enabled = true
        chartView.xAxis.labelPosition = .bottom
        chartView.rightAxis.enabled = false
    }

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
            var historyText = ""
            
            for (index, result) in results.enumerated() {
                if let upper = result.value(forKey: "upper") as? Double,
                   let middle = result.value(forKey: "middle") as? Double,
                   let lower = result.value(forKey: "lower") as? Double,
                   let date = result.value(forKey: "date") as? Date {
                    
                    // Append chart data entries
                    upperValues.append(ChartDataEntry(x: Double(index), y: upper))
                    middleValues.append(ChartDataEntry(x: Double(index), y: middle))
                    lowerValues.append(ChartDataEntry(x: Double(index), y: lower))
                    
                    // Format date for x-axis label
                    let formatter = DateFormatter()
                    formatter.dateStyle = .short
                    let dateString = formatter.string(from: date)
                    dateEntries.append(dateString)
                    
                    // Append to history text
                    historyText += "Date: \(dateString)\nUpper: \(upper), Middle: \(middle), Lower: \(lower)\n\n"
                }
            }
            
            // Set the text of the historyTextView
            historyTextView.text = historyText.isEmpty ? "No history available." : historyText
            
            setChartData(upperData: upperValues, middleData: middleValues, lowerData: lowerValues, dateEntries: dateEntries)
            
        } catch let error as NSError {
            print("Could not fetch data. \(error), \(error.userInfo)")
            historyTextView.text = "Failed to load history."
        }
    }

    func setChartData(upperData: [ChartDataEntry], middleData: [ChartDataEntry], lowerData: [ChartDataEntry], dateEntries: [String]) {
        let upperDataSet = LineChartDataSet(entries: upperData, label: "Upper")
        upperDataSet.colors = [.red]
        upperDataSet.circleColors = [.red]
        upperDataSet.circleRadius = 4
        upperDataSet.valueColors = [.red]
        upperDataSet.valueFont = .systemFont(ofSize: 10)
        upperDataSet.drawValuesEnabled = true // Show values above points

        let middleDataSet = LineChartDataSet(entries: middleData, label: "Middle")
        middleDataSet.colors = [.green]
        middleDataSet.circleColors = [.green]
        middleDataSet.circleRadius = 4
        middleDataSet.valueColors = [.green]
        middleDataSet.valueFont = .systemFont(ofSize: 10)
        middleDataSet.drawValuesEnabled = true // Show values above points

        let lowerDataSet = LineChartDataSet(entries: lowerData, label: "Lower")
        lowerDataSet.colors = [.blue]
        lowerDataSet.circleColors = [.blue]
        lowerDataSet.circleRadius = 4
        lowerDataSet.valueColors = [.blue]
        lowerDataSet.valueFont = .systemFont(ofSize: 10)
        lowerDataSet.drawValuesEnabled = true // Show values above points

        // Combine the datasets
        let data = LineChartData(dataSets: [upperDataSet, middleDataSet, lowerDataSet])
        chartView.data = data
        
        // Customize the x-axis to show dates
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateEntries)
        chartView.xAxis.granularity = 1
        chartView.xAxis.labelRotationAngle = -45
        chartView.xAxis.drawGridLinesEnabled = false 
    }
}
