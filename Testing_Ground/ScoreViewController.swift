import UIKit
import CoreData
import MessageUI

class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!

    struct SurveyEntry {
        var sum: Int
        var date: Date
    }

    var qualitySumScores: [SurveyEntry] = []
    var symptomSumScores: [SurveyEntry] = []
    var selectedSurveyEntry: SurveyEntry?
    var totalSymptomScore: Int64 = 0
    var surveyEntries: [SurveyEntry] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavBarButtons()
        fetchSurveySumScores()
    }

    func setupNavBarButtons() {
        // Create the email button
        let emailButton = UIBarButtonItem(title: "Email Results", style: .plain, target: self, action: #selector(emailButtonTapped))

        // Create flexible space to adjust positioning
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        // Add the email button next to the flexible space, so it's not fully to the right
        navigationItem.rightBarButtonItems = [flexibleSpace, emailButton]
    }
    
    func setupView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        surveyEntries = loadSurveyEntries()
        tableView.reloadData()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ScoreCell")
        tableView.allowsMultipleSelectionDuringEditing = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
    }

    @objc func editTapped() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        navigationItem.rightBarButtonItem?.title = tableView.isEditing ? "Done" : "Edit"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symptomSumScores.count
    }
    
    private func loadSurveyEntries() -> [SurveyEntry] {
        print("Total Symptom Score: \(totalSymptomScore)")
        return []
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)
        let entry = symptomSumScores[indexPath.row]
        cell.textLabel?.text = "Date: \(formattedDate(entry.date)) - Score: \(entry.sum)"
        return cell
    }

    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }

    func fetchSurveySumScores() {
        symptomSumScores = [
            SurveyEntry(sum: 100, date: Date()),
            SurveyEntry(sum: 25, date: Date())
        ]
        tableView.reloadData()
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
            let alert = UIAlertController(title: "Error", message: "Mail services are not available", preferredStyle: .alert)
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
