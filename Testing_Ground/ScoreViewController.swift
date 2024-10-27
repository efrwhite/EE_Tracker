//import UIKit
//import CoreData
//
//class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    @IBOutlet weak var tableView: UITableView!
//
//    struct SurveyEntry {
//        var sum: Int
//        var date: Date
//    }
//
//    var qualitySumScores: [SurveyEntry] = []
//    var symptomSumScores: [SurveyEntry] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupView()
//        fetchSurveySumScores()
//    }
//
//    func setupView() {
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ScoreCell")
//        tableView.allowsMultipleSelectionDuringEditing = true
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditingMode))
//    }
//
//    @objc func toggleEditingMode() {
//        let isEditingMode = !tableView.isEditing
//        tableView.setEditing(isEditingMode, animated: true)
//        navigationItem.rightBarButtonItem?.title = isEditingMode ? "Done" : "Edit"
//    }
//
//    @objc func generateReportTapped() {
//        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return }
//
//        var selectedEntries: [SurveyEntry] = []
//        for indexPath in selectedIndexPaths {
//            let entry = indexPath.section == 0 ? qualitySumScores[indexPath.row] : symptomSumScores[indexPath.row]
//            selectedEntries.append(entry)
//        }
//
//        // Print the selected entries for debugging
//        print("Selected Entries for Report: \(selectedEntries)")
//
//        if let generateReportVC = storyboard?.instantiateViewController(withIdentifier: "GenerateReportViewController") as? GenerateReportViewController {
//            generateReportVC.selectedEntries = selectedEntries
//            navigationController?.pushViewController(generateReportVC, animated: true)
//        }
//
//        let generateReportVC = GenerateReportViewController()
//        generateReportVC.selectedEntries = selectedEntries
//        print("Navigating to GenerateReportViewController with \(selectedEntries.count) entries.")
//        navigationController?.pushViewController(generateReportVC, animated: true)
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return section == 0 ? qualitySumScores.count : symptomSumScores.count
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return section == 0 ? "Quality of Life Surveys" : "Symptom Surveys"
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)
//        let entry = indexPath.section == 0 ? qualitySumScores[indexPath.row] : symptomSumScores[indexPath.row]
//        cell.textLabel?.text = "Sum: \(entry.sum) - Date: \(formatDate(entry.date))"
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true // Allow editing for all rows
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Determine whether we're deleting from qualitySumScores or symptomSumScores
//            let entityName = indexPath.section == 0 ? "Quality" : "Symptom"
//            let entry = indexPath.section == 0 ? qualitySumScores[indexPath.row] : symptomSumScores[indexPath.row]
//
//            deleteEntry(entityName: entityName, entry: entry) {
//                // Remove the entry from the local array
//                if indexPath.section == 0 {
//                    self.qualitySumScores.remove(at: indexPath.row)
//                } else {
//                    self.symptomSumScores.remove(at: indexPath.row)
//                }
//                // Delete the row from the table view
//                tableView.deleteRows(at: [indexPath], with: .fade)
//            }
//        }
//    }
//
//    private func formatDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        formatter.timeStyle = .none
//        return formatter.string(from: date)
//    }
//
//    func fetchSurveySumScores() {
//        fetchSumScoresFromEntity(entityName: "Quality", completion: { entries in
//            self.qualitySumScores = entries
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        })
//
//        fetchSumScoresFromEntity(entityName: "Symptom", completion: { entries in
//            self.symptomSumScores = entries
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        })
//    }
//
//    func fetchSumScoresFromEntity(entityName: String, completion: @escaping ([SurveyEntry]) -> Void) {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        var entries: [SurveyEntry] = []
//
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
//        fetchRequest.resultType = .dictionaryResultType
//
//        let sumAttribute = entityName == "Quality" ? "qualitySum" : "symptomSum"
//
//        let sumExpressionDesc = NSExpressionDescription()
//        sumExpressionDesc.name = "sum"
//        sumExpressionDesc.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: sumAttribute)])
//        sumExpressionDesc.expressionResultType = .integer64AttributeType
//
//        let dateExpression = NSExpressionDescription()
//        dateExpression.name = "date"
//        dateExpression.expression = NSExpression(forKeyPath: "date")
//        dateExpression.expressionResultType = .dateAttributeType
//
//        fetchRequest.propertiesToFetch = [sumExpressionDesc, dateExpression]
//        fetchRequest.propertiesToGroupBy = ["date"]
//
//        do {
//            let results = try context.fetch(fetchRequest) as! [NSDictionary]
//            for result in results {
//                if let sum = result["sum"] as? Int, let date = result["date"] as? Date {
//                    entries.append(SurveyEntry(sum: sum, date: date))
//                }
//            }
//            completion(entries)
//        } catch {
//            print("Error fetching \(entityName) sum scores: \(error)")
//        }
//    }
//
//    func deleteEntry(entityName: String, entry: SurveyEntry, completion: @escaping () -> Void) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let context = appDelegate.persistentContainer.viewContext
//
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//        fetchRequest.predicate = NSPredicate(format: "date == %@", entry.date as NSDate)
//
//        do {
//            let results = try context.fetch(fetchRequest)
//            for object in results {
//                guard let objectData = object as? NSManagedObject else { continue }
//                context.delete(objectData)
//            }
//
//            try context.save()
//            completion()
//        } catch let error as NSError {
//            print("Delete error: \(error), \(error.userInfo)")
//        }
//    }
//}


import UIKit
import CoreData
import MessageUI

class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!

    struct SurveyEntry {
        var sum: Int
        var date: Date
    }

    var symptomSumScores: [SurveyEntry] = []
    var selectedSurveyEntry: SurveyEntry?
    var totalSymptomScore: Int64 = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavBarButtons()
        fetchSurveySumScores()
        tableView.reloadData()
    }

    func setupNavBarButtons() {
        // Create the email button
        let emailButton = UIBarButtonItem(title: "Email Results", style: .plain, target: self, action: #selector(emailButtonTapped))
        // Add the email button to the right
        navigationItem.rightBarButtonItem = emailButton
    }
    
    func setupView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ScoreCell")
        tableView.allowsMultipleSelectionDuringEditing = true

    }

    @objc func editTapped() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        navigationItem.leftBarButtonItem?.title = tableView.isEditing ? "Done" : "Edit"
    }

    // MARK: - TableView DataSource & Delegate Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symptomSumScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)
        
        let surveyEntry = symptomSumScores[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateStyle = .short // Display the date in a short format
        
        // Set the text of the cell to show the date and total score
        cell.textLabel?.text = "Date: \(formatter.string(from: surveyEntry.date)), Total Score: \(surveyEntry.sum)"
        
        return cell
    }


    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }

    func fetchSurveySumScores() {
        _ = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Fetching data from Core Data
        fetchSumScoresFromEntity(entityName: "Symptom") { entries in
            self.symptomSumScores = entries
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func fetchSumScoresFromEntity(entityName: String, completion: @escaping ([SurveyEntry]) -> Void) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var entries: [SurveyEntry] = []

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        fetchRequest.resultType = .dictionaryResultType

        let sumAttribute = "symptomSum"

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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            symptomSumScores.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? ScoreViewController,
           let selectedIndexPath = tableView.indexPathForSelectedRow {
            let selectedEntry = symptomSumScores[selectedIndexPath.row]
            detailVC.selectedSurveyEntry = selectedEntry
        }
    }

    // MARK: - Email Functionality

    @objc func emailButtonTapped() {
        sendEmail()
    }

    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setSubject("Symptom Survey Results")
            mailComposeVC.setMessageBody(composeEmailBody(), isHTML: false)
            present(mailComposeVC, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Mail services are not available. Please set up an account in Settings.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    func composeEmailBody() -> String {
        var emailBody = "Here are the symptom survey results:\n\n"
        for entry in symptomSumScores {
            emailBody += "Date: \(formattedDate(entry.date)), Score: \(entry.sum)\n"
        }
        return emailBody
    }

    // MARK: - MFMailComposeViewControllerDelegate

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
