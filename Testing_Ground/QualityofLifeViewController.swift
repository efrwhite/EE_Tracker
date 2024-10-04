import UIKit
import CoreData

struct QualityEntry {
    let sum: Int
    let date: Date
}

protocol QualityofLifeViewControllerDelegate: AnyObject {
    func qualityOfLifeViewController(_ controller: QualityofLifeViewController, didAddNewQualityEntry entry: QualityEntry)
}

class QualityofLifeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: QualityofLifeViewControllerDelegate?
    var capturedData: [[String: Any]] = []

    let symptomsone = ["I have chest pain, ache, or hurt", "I have burning in my chest, mouth, or throat (heartburn)", "I have stomach aches or belly aches", "I throw up (vomit)", "I feel like I'm going to throw up, but I don't (nausea)", "When I am eating, food comes back up my throat"]
    let symptomstwo = ["I have trouble swallowing", "I feel like food gets stuck in my throat or chest", "I need to drink to help me swallow my food", "I need more time to eat than other kids my age"]
    let treatment = ["It is hard for me to take my medicine", "I do not want to take my medicines", "I do not like going to the doctor", "I do not like getting an endoscopy (scope, EGD)", "I do not like getting allergy testing"]
    let worry = ["I worry about having EOE", "I worry about getting sick in front of other people", "I worry about what other people think about me because of EOE", "I worry about getting allergy testing"]
    let communication = ["I have trouble telling other people about EOE", "I have trouble talking to my parents about how I feel", "I have trouble talking to other adults about how I feel", "I have trouble talking to my friends about how I feel", "I have trouble talking to doctors or nurses about how I feel"]
    let foodandeating = ["It is hard not being allowed to eat some foods", "It is hard for me not to sneak foods I'm allergic to", "It is hard for me to not eat the same things as my family", "It is hard not to eat the same things as my friends"]
    let foodfeelingQ = ["I worry about eating foods I'm allergic to or not supposed to eat", "I'm upset about not eating foods I'm allergic to/not supposed to eat", "I'm sad about not eating foods I'm allergic to/not supposed to eat"]

    let sections = [
        "SYMPTOMS I",
        "SYMPTOMS II",
        "TREATMENT",
        "WORRY",
        "COMMUNICATION",
        "FOOD AND EATING",
        "FOOD FEELINGS"
    ]

    var sectionData: [[String]] {
        return [
            symptomsone,
            symptomstwo,
            treatment,
            worry,
            communication,
            foodandeating,
            foodfeelingQ
        ]
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!

    var sectionResponses: [[String?]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "QualityofLifeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "QualityofLifeTableViewCell")
        tableView.estimatedRowHeight = 60 // Increase this value as needed
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self

        for section in sectionData {
            sectionResponses.append(Array(repeating: nil, count: section.count))
        }

        saveButton.isEnabled = false

        setupPersistentPainScaleHeaderView()

        // Setup tap gesture recognizer to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false  // This allows other controls to receive touch events
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionData[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QualityofLifeTableViewCell", for: indexPath) as! QualityofLifeTableViewCell

        cell.questionlabel.font = UIFont.systemFont(ofSize: 14) // Adjust the font size as needed
        cell.questionlabel.text = sectionData[indexPath.section][indexPath.row]
        cell.ratingText.tag = indexPath.section * 100 + indexPath.row
        cell.ratingText.text = sectionResponses[indexPath.section][indexPath.row]
        cell.ratingText.addTarget(self, action: #selector(responseTextFieldDidChange(_:)), for: .editingChanged)

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.lightGray

        let label = UILabel()
        label.text = sections[section]
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.frame = CGRect(x: 16, y: 8, width: tableView.bounds.width - 32, height: 0)
        label.sizeToFit()
        headerView.addSubview(label)

        return headerView
    }

    @objc func responseTextFieldDidChange(_ textField: UITextField) {
        let section = textField.tag / 100
        let row = textField.tag % 100
        let response = textField.text

        sectionResponses[section][row] = response

        updateSaveButtonState()
    }

    func updateSaveButtonState() {
        for section in sectionResponses {
            for response in section {
                if response == nil || response!.isEmpty {
                    saveButton.isEnabled = false
                    return
                }
            }
        }
        saveButton.isEnabled = true
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        captureData()
        performSegue(withIdentifier: "QualityResultSegue", sender: self)
    }

    func captureData() {
        var sum = 0
        for section in sectionResponses {
            for response in section {
                if let responseValue = response, let intValue = Int(responseValue) {
                    sum += intValue
                }
            }
        }
        capturedData = [["sum": sum, "date": Date()]]
    }

    func saveDataToCoreData() -> [QualityEntry] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Could not get appDelegate")
            return []
        }
        let context = appDelegate.persistentContainer.viewContext

        let newQuality = NSEntityDescription.insertNewObject(forEntityName: "Quality", into: context)
        if let data = capturedData.first {
            let sum = data["sum"] as? Int ?? 0
            newQuality.setValue(Int64(sum), forKey: "qualitySum")
            newQuality.setValue(data["date"] as? Date ?? Date(), forKey: "date")
        }

        var entries: [QualityEntry] = []

        do {
            try context.save()
            if let sum = newQuality.value(forKey: "qualitySum") as? Int,
               let date = newQuality.value(forKey: "date") as? Date {
                let entry = QualityEntry(sum: sum, date: date)
                entries.append(entry)
            }
            print("Quality data saved successfully.")
        } catch let error as NSError {
            print("Could not save Quality data. \(error), \(error.userInfo)")
        }

        return entries
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "QualityResultSegue",
           let destinationVC = segue.destination as? QualityResultViewController {
            let entries = saveDataToCoreData()
            if !entries.isEmpty {
                destinationVC.qualityEntries = entries
            }
        }
    }

    func setupPersistentPainScaleHeaderView() {
        let painScaleHeaderView = UIView()
        painScaleHeaderView.backgroundColor = .white // You can change the background color as needed
        let headerText = "Pain Scale:\n0 = no pain\n1 = slight pain\n2 = moderate pain\n3 = severe pain\n4 = very severe pain"
        let label = UILabel()
        label.numberOfLines = 0 // Allows label to have multiple lines
        label.text = headerText
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .black

        painScaleHeaderView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        // Constraints for the label inside the painScaleHeaderView
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: painScaleHeaderView.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: painScaleHeaderView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: painScaleHeaderView.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: painScaleHeaderView.bottomAnchor, constant: -8)
        ])

        view.addSubview(painScaleHeaderView)
        painScaleHeaderView.translatesAutoresizingMaskIntoConstraints = false

        // Set the painScaleHeaderView height based on the content of the label
        let estimatedSize = label.sizeThatFits(CGSize(width: view.frame.width - 32, height: CGFloat.greatestFiniteMagnitude))
        let headerHeight = estimatedSize.height + 16 // Add some padding

        NSLayoutConstraint.activate([
            painScaleHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            painScaleHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            painScaleHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            painScaleHeaderView.heightAnchor.constraint(equalToConstant: headerHeight) // Use the calculated header height
        ])

        // Adjust the tableView's top constraint to be below the painScaleHeaderView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: painScaleHeaderView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
