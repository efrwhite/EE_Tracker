import UIKit
import MessageUI

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { context in
            layer.render(in: context.cgContext)
        }
    }
}

class QualityResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var qualityEntries: [QualityEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "QualityResultCell")
        tableView.reloadData()
        
        setupNavBarButtons()
    }
    
    func setupNavBarButtons() {
        // Create the email button
        let emailButton = UIBarButtonItem(title: "Email Results", style: .plain, target: self, action: #selector(emailButtonTapped))
        
        // Create flexible space to adjust positioning
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // Add the email button next to the flexible space, so it's not fully to the right
        navigationItem.rightBarButtonItems = [flexibleSpace, emailButton]
    }
    
    @objc func emailButtonTapped() {
        sendEmail()
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setSubject("Quality of Life Survey Results")
            mailComposeVC.setMessageBody(composeEmailBody(), isHTML: false)
            present(mailComposeVC, animated: true, completion: nil)
        } else {
            if let emailURL = createEmailUrl(to: "provider@example.com", subject: "Quality of Life Survey Results", body: composeEmailBody()) {
                UIApplication.shared.open(emailURL)
            } else {
                let alert = UIAlertController(title: "Error", message: "Mail services are not available. Please set up a mail account in Settings.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let gmailURL = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookURL = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultMailURL = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailURL = gmailURL, UIApplication.shared.canOpenURL(gmailURL) {
            return gmailURL
        } else if let outlookURL = outlookURL, UIApplication.shared.canOpenURL(outlookURL) {
            return outlookURL
        } else {
            return defaultMailURL
        }
    }
    
    func composeEmailBody() -> String {
        var emailBody = "Here are the Quality of Life survey results:\n\n"
        for entry in qualityEntries {
            emailBody += "Sum: \(entry.sum), Date: \(entry.date)\n"
        }
        return emailBody
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return qualityEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QualityResultCell", for: indexPath)
        let entry = qualityEntries[indexPath.row]
        cell.textLabel?.text = "Sum: \(entry.sum) - Date: \(entry.date)"
        return cell
    }
    
    @IBAction func goToGenerateReport(_ sender: Any) {
        let generateReportVC = GenerateReportViewController()
        
        // Pass the table view reference to GenerateReportViewController
        generateReportVC.tableViewsToCapture.append(self.tableView)
        
        // Navigate to GenerateReportViewController
        navigationController?.pushViewController(generateReportVC, animated: true)
    }
}
