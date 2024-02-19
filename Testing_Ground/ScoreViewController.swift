import UIKit
import CoreData

class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    struct SurveyEntry {
        var sum: Int
        var date: Date
    }

    var qualitySumScores: [SurveyEntry] = []
    var symptomSumScores: [SurveyEntry] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchSurveySumScores()
    }

    func setupView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ScoreCell")
        tableView.allowsMultipleSelectionDuringEditing = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditingMode))
    }

    @objc func toggleEditingMode() {
        let isEditingMode = !tableView.isEditing
        tableView.setEditing(isEditingMode, animated: true)
        navigationItem.rightBarButtonItem?.title = isEditingMode ? "Done" : "Edit"
    }

    @objc func generateReportTapped() {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return }

        var selectedEntries: [SurveyEntry] = []
        for indexPath in selectedIndexPaths {
            let entry = indexPath.section == 0 ? qualitySumScores[indexPath.row] : symptomSumScores[indexPath.row]
            selectedEntries.append(entry)
        }

        // Print the selected entries for debugging
        print("Selected Entries for Report: \(selectedEntries)")

        if let generateReportVC = storyboard?.instantiateViewController(withIdentifier: "GenerateReportViewController") as? GenerateReportViewController {
                generateReportVC.selectedEntries = selectedEntries
                navigationController?.pushViewController(generateReportVC, animated: true)
            }
        
        let generateReportVC = GenerateReportViewController()
        generateReportVC.selectedEntries = selectedEntries
        print("Navigating to GenerateReportViewController with \(selectedEntries.count) entries.")
        navigationController?.pushViewController(generateReportVC, animated: true)

    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? qualitySumScores.count : symptomSumScores.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Quality of Life Surveys" : "Symptom Surveys"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)
        let entry = indexPath.section == 0 ? qualitySumScores[indexPath.row] : symptomSumScores[indexPath.row]
        cell.textLabel?.text = "Sum: \(entry.sum) - Date: \(formatDate(entry.date))"
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // Allow editing for all rows
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Determine whether we're deleting from qualitySumScores or symptomSumScores
            let entityName = indexPath.section == 0 ? "Quality" : "Symptom"
            let entry = indexPath.section == 0 ? qualitySumScores[indexPath.row] : symptomSumScores[indexPath.row]

            deleteEntry(entityName: entityName, entry: entry) {
                // Remove the entry from the local array
                if indexPath.section == 0 {
                    self.qualitySumScores.remove(at: indexPath.row)
                } else {
                    self.symptomSumScores.remove(at: indexPath.row)
                }
                // Delete the row from the table view
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }


    func fetchSurveySumScores() {
        fetchSumScoresFromEntity(entityName: "Quality", completion: { entries in
            self.qualitySumScores = entries
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })

        fetchSumScoresFromEntity(entityName: "Symptom", completion: { entries in
            self.symptomSumScores = entries
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    func fetchSumScoresFromEntity(entityName: String, completion: @escaping ([SurveyEntry]) -> Void) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var entries: [SurveyEntry] = []

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        fetchRequest.resultType = .dictionaryResultType

        let sumAttribute = entityName == "Quality" ? "qualitySum" : "symptomSum"

        let sumExpressionDesc = NSExpressionDescription()
        sumExpressionDesc.name = "sum"
        sumExpressionDesc.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: sumAttribute)])
        sumExpressionDesc.expressionResultType = .integer64AttributeType
        
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
                    entries.append(SurveyEntry(sum: sum, date: date))
                }
            }
            completion(entries)
        } catch {
            print("Error fetching \(entityName) sum scores: \(error)")
        }
    }

    func deleteEntry(entityName: String, entry: SurveyEntry, completion: @escaping () -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "date == %@", entry.date as NSDate)
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
            
            try context.save()
            completion()
        } catch let error as NSError {
            print("Delete error: \(error), \(error.userInfo)")
        }
    }
}
