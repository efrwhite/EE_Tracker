import UIKit
import CoreData
import MessageUI

class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!

    struct SurveyEntry: Hashable {
        var sum: Int64
        var date: Date
    }

    var symptomSumScores: [SurveyEntry] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ScoreViewController loaded.")
        print("Data source count: \(symptomSumScores.count)")
        symptomSumScores.forEach { print("Data entry: \($0)") } // Print each entry

        setupView()
        setupNavBarButtons()
        fetchSymptomData()
        tableView.reloadData()
    }

    func setupNavBarButtons() {
        let emailButton = UIBarButtonItem(title: "Email Results", style: .plain, target: self, action: #selector(emailButtonTapped))
        navigationItem.rightBarButtonItem = emailButton
    }

    func setupView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ScoreCell")
    }

    func fetchSymptomData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Symptom> = Symptom.fetchRequest()

        do {
            let symptoms = try context.fetch(fetchRequest)
            var uniqueEntries = Set<SurveyEntry>()
            symptomSumScores.removeAll() // Clear existing data
            symptoms.forEach { symptom in
                if let date = symptom.date {
                    uniqueEntries.insert(SurveyEntry(sum: symptom.symptomSum, date: date))
                }
            }
            symptomSumScores = Array(uniqueEntries).sorted { $0.date > $1.date }
        } catch {
            print("Failed to fetch symptoms: \(error)")
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symptomSumScores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)
        let surveyEntry = symptomSumScores[indexPath.row]

        let formatter = DateFormatter()
        formatter.dateStyle = .short

        cell.textLabel?.text = "Date: \(formatter.string(from: surveyEntry.date)), Total Score: \(surveyEntry.sum)"
        return cell
    }

    @objc func emailButtonTapped() {
        sendEmail()
    }

    func sendEmail() {
        guard MFMailComposeViewController.canSendMail() else {
            let alert = UIAlertController(title: "Error", message: "Mail services are not available. Please set up an account in Settings.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }

        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setSubject("Symptom Survey Results")
        mailComposeVC.setMessageBody(composeEmailBody(), isHTML: false)
        present(mailComposeVC, animated: true, completion: nil)
    }

    func composeEmailBody() -> String {
        var emailBody = "Here are the symptom survey results:\n\n"
        for entry in symptomSumScores {
            emailBody += "Date: \(formattedDate(entry.date)), Score: \(entry.sum)\n"
        }
        return emailBody
    }

    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
