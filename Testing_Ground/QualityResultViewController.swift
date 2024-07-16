import UIKit
import MessageUI

class QualityResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emailButton: UIButton! // Outlet for the email button
    
    var qualityEntries: [QualityEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "QualityResultCell")
        tableView.reloadData()
        
        setupEmailButton() // Setup the email button
    }
    
    func setupEmailButton() {
        emailButton.setTitle("Email history to provider", for: .normal)
        emailButton.backgroundColor = .systemBlue
        emailButton.setTitleColor(.white, for: .normal)
        emailButton.layer.cornerRadius = 10
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
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
            let alert = UIAlertController(title: "Error", message: "Mail services are not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
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
}
