import UIKit
import CoreData

// Define QualityEntry outside of the QualityofLifeViewController class
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
    let foodfeelingQ = ["I worry about eating foods I'm allergic to or not supposed to eat", "I feel upset about not eating foods I am allergic to or not supposed to eat", "I feel sad about not eating foods I am allergic to or not supposed to eat"]
    
    let sections = [
        "Pain Scale:\n0 = pain\n1 = moderate pain\n2 = slight pain\n3 = barely pain\n4 = no pain",
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
            [], // Empty array for "Pain Scale" section
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
    
    private var isHeaderSetupDone = false // Add this flag

        override func viewDidLoad() {
            super.viewDidLoad()
        
        
            
            
        
        let nib = UINib(nibName: "QualityofLifeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "QualityofLifeTableViewCell")
        tableView.estimatedRowHeight = 40 // Set a reasonable estimate
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        // Initialize the sectionResponses array
        for section in sectionData {
            sectionResponses.append(Array(repeating: nil, count: section.count))
        }
        
        // Disable save button initially
        saveButton.isEnabled = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionData[section].count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !isHeaderSetupDone {
            setupTableHeaderView()
            isHeaderSetupDone = true
        }
    }

    func setupTableHeaderView() {
        let headerText = "Pain Scale:\n0 = pain\n1 = moderate pain\n2 = slight pain\n3 = barely pain\n4 = no pain"
        let label = UILabel(frame: CGRect(x: 16, y: 8, width: self.tableView.bounds.width - 32, height: 0))
        label.numberOfLines = 0
        label.text = headerText
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .black
        label.sizeToFit() // Resize the label to fit its content

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: label.frame.height + 16))
        headerView.addSubview(label)

        // Force the layout of subviews immediately
        headerView.layoutIfNeeded()

        // Set the header view as the table's header view
        self.tableView.tableHeaderView = headerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QualityofLifeTableViewCell", for: indexPath) as! QualityofLifeTableViewCell
        
        cell.questionlabel.text = sectionData[indexPath.section][indexPath.row]
        if indexPath.section != 0 {
            cell.ratingText.tag = indexPath.section * 100 + indexPath.row
            cell.ratingText.text = sectionResponses[indexPath.section][indexPath.row]
            cell.ratingText.addTarget(self, action: #selector(responseTextFieldDidChange(_:)), for: .editingChanged)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.lightGray // Set a background color for header views
        
        let label = UILabel()
        label.text = sections[section]
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        
        // For the first section, make the header sticky by setting it as the table view's header
        if section == 0 {
            tableView.tableHeaderView = headerView
            return nil
        }
        
        return headerView
    }
    
    @objc func responseTextFieldDidChange(_ textField: UITextField) {
        let section = textField.tag / 100
        let row = textField.tag % 100
        let response = textField.text
        
        sectionResponses[section][row] = response
        
        // Update the state of the save button based on whether all fields are filled
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
        saveDataToCoreData()
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
    
    func saveDataToCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Could not get appDelegate")
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        let newQuality = Quality(context: context)
        if let data = capturedData.first {
            let sum = data["sum"] as? Int ?? 0
            newQuality.qualitySum = Int64(sum)
            newQuality.date = data["date"] as? Date ?? Date()
        }
        
        do {
            try context.save()
            print("Quality data saved successfully.")
        } catch let error as NSError {
            print("Could not save Quality data. \(error), \(error.userInfo)")
        }
    }
}
