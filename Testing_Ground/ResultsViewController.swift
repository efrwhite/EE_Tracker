import UIKit
import CoreData

class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    struct EndoscopyEntry {
        var sum: Int
        var date: Date
    }

    var endoscopySumScores: [EndoscopyEntry] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchEndoscopySumScores()
    }

    func setupView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResultCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endoscopySumScores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        let entry = endoscopySumScores[indexPath.row]
        cell.textLabel?.text = "Sum: \(entry.sum) - Date: \(formatDate(entry.date))"
        return cell
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    func fetchEndoscopySumScores() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Endoscopy")
        fetchRequest.resultType = .dictionaryResultType

        let sumExpressionDesc = NSExpressionDescription()
        sumExpressionDesc.name = "sum"
        sumExpressionDesc.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "sum")])
        sumExpressionDesc.expressionResultType = .integer32AttributeType
        
        let dateExpression = NSExpressionDescription()
        dateExpression.name = "date"
        dateExpression.expression = NSExpression(forKeyPath: "date")
        dateExpression.expressionResultType = .dateAttributeType

        fetchRequest.propertiesToFetch = [sumExpressionDesc, dateExpression]
        fetchRequest.propertiesToGroupBy = ["date"]

        do {
            let results = try context.fetch(fetchRequest) as! [NSDictionary]
            for result in results {
                if let sum = result["sum"] as? Int, let date = result["date"] as? Date {
                    endoscopySumScores.append(EndoscopyEntry(sum: sum, date: date))
                    print("Fetched Endoscopy result with sum: \(sum) for date: \(formatDate(date))")
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Failed to fetch Endoscopy sums: \(error)")
        }
    }
}
