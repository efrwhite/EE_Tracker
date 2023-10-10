import UIKit
import CoreData

class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    // Array to hold integer responses
    var numberArray: [Int] = []
    var sum: Int = 0
    var date: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Register the default UITableViewCell class for the cell identifier "ScoreCell"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ScoreCell")
        tableView.reloadData()
        // Fetch data from the "Quality" entity
        fetchDataFromQualityEntity()
    }


    func fetchDataFromQualityEntity() {
        // Assuming you have a Core Data context set up
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let request: NSFetchRequest<Quality> = Quality.fetchRequest()
            let qualities = try context.fetch(request)

            for quality in qualities {
                if let responseValue = quality.response,
                   let intValue = Int(responseValue) {
                    numberArray.append(intValue)
                    sum += intValue
                    if date == nil {
                        date = quality.date
                    }
                }
            }

            tableView.reloadData()
        } catch {
            print("Error fetching data: \(error)")
        }
    }

    // UITableViewDataSource methods to populate the tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // Only one row for displaying the sum and date
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)

        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = dateFormatter.string(from: date)
            
            // Combine the date and sum into one string
            let displayText = "Date: \(formattedDate), Sum: \(sum)"
            
            // Set the cell's textLabel properties
            cell.textLabel?.text = displayText
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14) // Adjust font size as needed
            cell.textLabel?.textColor = UIColor.black // Adjust text color as needed
        } else {
            cell.textLabel?.text = "No data available"
        }

        return cell
    }


}
