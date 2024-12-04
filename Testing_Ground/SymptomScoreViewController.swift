//import UIKit
//import CoreData
//
//protocol SymptomScoreViewControllerDelegate: AnyObject {
//    func symptomScoreViewController(_ controller: SymptomScoreViewController, didUpdateSymptomEntries entries: [SymptomScoreViewController.SymptomEntry])
//}
//
//class SymptomScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SymTableViewCellDelegate {
//    weak var delegate: SymptomScoreViewControllerDelegate?
//    var capturedData: [[String: Any]] = []
//    
//    let questions = [
//        "Visit date",
//        "How often does your child have trouble swallowing?",
//        "How bad is your child's trouble swallowing?",
//        "How often does your child feel like food gets stuck in their throat or chest?",
//        "How bad is it when your child gets food stuck in their throat or chest?",
//        "How often does your child need to drink a lot to help them swallow food?",
//        "How bad is it when your child needs to drink a lot to help them swallow food?",
//        "How often does your child eat less than others?",
//        "How often does your child need more time to eat than others?",
//        "How often does your child have heartburn?",
//        "How bad is your child's heartburn (burning in the chest, mouth, or throat)?",
//        "How often does your child have food come back up in their throat when eating?",
//        "How bad is it when food comes back up in your child's throat?",
//        "How often does your child vomit (throw up)?",
//        "How bad is your child's vomiting?",
//        "How often does your child feel nauseous (feel like throwing up, but doesn't)?",
//        "How bad is your child's nausea (feel like throwing up, but doesn't)?",
//        "How often does your child have chest pain, ache, or hurt?",
//        "How bad is your child's chest pain, ache, or hurt?",
//        "How often does your child have stomach aches or belly aches?",
//        "How bad are your child's stomach aches or belly aches?"
//    ]
//    
//    let yesnoquestions = [
//        "Feeding is difficult/refuses food?",
//        "Slow eating",
//        "Prolonged chewing",
//        "Swallowing liquids with solid food",
//        "Avoidance of solid food",
//        "Retching",
//        "Choking",
//        "Food Impaction",
//        "Hoarseness",
//        "Constipation",
//        "Poor weight gain",
//        "Diarrhea"
//    ]
//    
//    let sections = [
//        "For the questions below, insert a value from 0-5\n0 = No pain, 5 = Excruciating pain",
//        "For the following questions, use the switch to indicate Yes or No"
//    ]
//    
//    @IBOutlet weak var tableView: UITableView!
//    var responses: [[String?]] = []
//    var yesnoResponses: [Bool] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let nib = UINib(nibName: "SymptomTableViewCell", bundle: nil)
//        tableView.register(nib, forCellReuseIdentifier: "SymptomTableViewCell")
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.estimatedRowHeight = 100
//        tableView.rowHeight = UITableView.automaticDimension
//        
//        responses = [Array(repeating: nil, count: questions.count), Array(repeating: nil, count: yesnoquestions.count)]
//        yesnoResponses = Array(repeating: false, count: yesnoquestions.count)
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return sections.count
//    }
//    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sections[section]
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return section == 0 ? questions.count : yesnoquestions.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SymptomTableViewCell", for: indexPath) as? SymTableViewCell else {
//            fatalError("Expected SymptomTableViewCell")
//        }
//        
//        let question = indexPath.section == 0 ? questions[indexPath.row] : yesnoquestions[indexPath.row]
//        cell.questionLabel.text = question
//        cell.configureCell(for: indexPath.section)
//        
//        if indexPath.section == 0 {
//            cell.Ratingtext.text = responses[indexPath.section][indexPath.row]
//        } else {
//            cell.yesNoSwitch.isOn = yesnoResponses[indexPath.row]
//            cell.yesNoSwitch.tag = indexPath.row
//            cell.yesNoSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
//        }
//        
//        cell.delegate = self
//        cell.indexPath = indexPath
//        
//        return cell
//    }
//    
//    func didEditTextField(_ text: String, atIndexPath indexPath: IndexPath) {
//        responses[indexPath.section][indexPath.row] = text
//    }
//    
//    @objc func switchChanged(_ sender: UISwitch) {
//        yesnoResponses[sender.tag] = sender.isOn
//    }
//    
//    @IBAction func saveButtonTapped(_ sender: Any) {
//        print("Save button tapped in SymptomScoreViewController")
//        
//        captureData()
//        
//        let entries = saveDataToCoreData()
//        if !entries.isEmpty {
//            delegate?.symptomScoreViewController(self, didUpdateSymptomEntries: entries)
//            performSegue(withIdentifier: "SymptomResultSegue", sender: self)
//        } else {
//            print("Failed to save data or no entries to update.")
//        }
//    }
//
//    func captureData() {
//        var sum = 0
//
//        for response in responses[0] where response != nil {
//            if let intValue = Int(response!) {
//                sum += intValue
//            }
//        }
//
//        for (index, _) in yesnoquestions.enumerated() {
//            if yesnoResponses[index] {
//                sum += 1
//            }
//        }
//
//        capturedData = [["sum": sum, "date": Date()]]
//    }
//
//    func saveDataToCoreData() -> [SymptomEntry] {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            print("Could not get appDelegate")
//            return []
//        }
//        
//        let context = appDelegate.persistentContainer.viewContext
//        
//        let sumOfResponses = responses.flatMap { $0 }.compactMap { Int($0 ?? "0") }.reduce(0, +) + yesnoResponses.filter { $0 }.count
//        
//        let newSymptom = Symptom(context: context)
//        newSymptom.symptomSum = Int64(sumOfResponses)
//        newSymptom.date = Date()
//        
//        var entries: [SymptomEntry] = []
//        
//        do {
//            try context.save()
//            let entry = SymptomEntry(sum: sumOfResponses, date: newSymptom.date!)
//            entries.append(entry)
//            
//            print("Data saved successfully")
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//        
//        return entries
//    }
//
//    struct SymptomEntry {
//        let sum: Int
//        let date: Date
//    }
//}

import UIKit
import CoreData

class CustomHeaderView: UIView {
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        titleLabel.numberOfLines = 0 // Allows multiple lines
        titleLabel.font = UIFont(name: "Times New Roman", size: 17) // Set your desired font and size
        titleLabel.textColor = .black // Adjust as necessary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false // Use Auto Layout
        
        addSubview(titleLabel)

        // Add Auto Layout constraints
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8), // Add padding from the top
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8) // Add padding from the bottom
        ])
        
        // Set the background color for better visibility
        backgroundColor = .lightGray // Adjust as necessary
    }
}

protocol SymptomScoreViewControllerDelegate: AnyObject {
    func symptomScoreViewController(_ controller: SymptomScoreViewController, didUpdateSymptomEntries entries: [Int64])
}

class SymptomScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SymTableViewCellDelegate {
    weak var delegate: SymptomScoreViewControllerDelegate?
    var capturedData: [[String: Any]] = []
    
    let questions = [
        "How often does your child have trouble swallowing?",
        "How bad is your child's trouble swallowing?",
        "How often does your child feel like food gets stuck in their throat or chest?",
        "How bad is it when your child gets food stuck in their throat or chest?",
        "How often does your child need to drink a lot to help them swallow food?",
        "How bad is it when your child needs to drink a lot to help them swallow food?",
        "How often does your child eat less than others?",
        "How often does your child need more time to eat than others?",
        "How often does your child have heartburn?",
        "How bad is your child's heartburn (burning in the chest, mouth, or throat)?",
        "How often does your child have food come back up in their throat when eating?",
        "How bad is it when food comes back up in your child's throat?",
        "How often does your child vomit (throw up)?",
        "How bad is your child's vomiting?",
        "How often does your child feel nauseous (feel like throwing up, but doesn't)?",
        "How bad is your child's nausea (feel like throwing up, but doesn't)?",
        "How often does your child have chest pain, ache, or hurt?",
        "How bad is your child's chest pain, ache, or hurt?",
        "How often does your child have stomach aches or belly aches?",
        "How bad are your child's stomach aches or belly aches?"
    ]
    
    let yesnoquestions = [
        "Feeding is difficult/refuses food?",
        "Slow eating",
        "Prolonged chewing",
        "Swallowing liquids with solid food",
        "Avoidance of solid food",
        "Retching",
        "Choking",
        "Food Impaction",
        "Hoarseness",
        "Constipation",
        "Poor weight gain",
        "Diarrhea"
    ]
    
    @IBOutlet weak var symptomTableView: UITableView!
    @IBOutlet weak var yesNoTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    var responses: [String?] = []
    var yesnoResponses: [Bool] = []
    var totalSymptomScore: Int64 = 0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scoreVC = segue.destination as? ScoreViewController {
            if segue.identifier == "SymptomResultSegue" {
                // Pass the total symptom score
                scoreVC.totalSymptomScore = self.totalSymptomScore
                
                // Create a SurveyEntry with the current date and score, and append it to the array
                let date = Date() // Set the current date
                let newEntry = ScoreViewController.SurveyEntry(sum: Int(totalSymptomScore), date: date)
                scoreVC.symptomSumScores.append(newEntry)
                
            } else if segue.identifier == "ShowResultsSegue" {
                // Handle data transfer for the "Results" button if needed
                // For now, no additional data is being passed here.
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTables()
        responses = Array(repeating: nil, count: questions.count)
        yesnoResponses = Array(repeating: false, count: yesnoquestions.count)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Set up keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        updateSaveButtonState() // Check the initial state of the Save button
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("Keyboard will show with height: \(keyboardSize.height)")
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        print("Keyboard will hide")
    }
    
    func setupTables() {
        let symptomNib = UINib(nibName: "SymptomTableViewCell", bundle: nil)
        symptomTableView.register(symptomNib, forCellReuseIdentifier: "SymptomTableViewCell")
        symptomTableView.delegate = self
        symptomTableView.dataSource = self
        symptomTableView.estimatedRowHeight = 100
        symptomTableView.rowHeight = UITableView.automaticDimension
        
        let yesNoNib = UINib(nibName: "YesNoTableViewCell", bundle: nil)
        yesNoTableView.register(yesNoNib, forCellReuseIdentifier: "YesNoTableViewCell")
        yesNoTableView.delegate = self
        yesNoTableView.dataSource = self
        yesNoTableView.estimatedRowHeight = 100
        yesNoTableView.rowHeight = UITableView.automaticDimension
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - UITableViewDataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? questions.count : yesnoquestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return indexPath.section == 0 ? setupSymptomTableViewCell(indexPath: indexPath) : setupYesNoTableViewCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CustomHeaderView()
        headerView.titleLabel.text = section == 0
            ? "For the questions below, insert a value from 0-5\n0 = Not at all, 5 = Very often"
            : "For the following questions, use the switch to indicate Yes or No"
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func setupSymptomTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = symptomTableView.dequeueReusableCell(withIdentifier: "SymptomTableViewCell", for: indexPath) as? SymTableViewCell else {
            fatalError("Expected SymptomTableViewCell")
        }
        cell.questionLabel.text = questions[indexPath.row]
        cell.Ratingtext.text = responses[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    func setupYesNoTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        guard let yesNoCell = yesNoTableView.dequeueReusableCell(withIdentifier: "YesNoTableViewCell", for: indexPath) as? YesNoTableViewCell else {
            fatalError("Expected YesNoTableViewCell")
        }
        yesNoCell.questionLabel.text = yesnoquestions[indexPath.row]
        yesNoCell.yesNoSwitch.isOn = yesnoResponses[indexPath.row]
        yesNoCell.indexPath = indexPath
        return yesNoCell
    }
    
    func didEditTextField(_ text: String, atIndexPath indexPath: IndexPath) {
        guard !text.isEmpty else {
            showAlertForEmptyInput()
            responses[indexPath.row] = nil
            updateSaveButtonState() // Update the save button state
            return
        }
        
        if let value = Int(text), value >= 0, value <= 5 {
            responses[indexPath.row] = text
        } else {
            showAlertForInvalidInput()
            responses[indexPath.row] = nil
        }
        
        updateSaveButtonState() // Update the save button state
    }
    
    func showAlertForEmptyInput() {
        let alert = UIAlertController(title: "Error", message: "Please fill in all fields.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showAlertForInvalidInput() {
        let alert = UIAlertController(title: "Invalid Input", message: "Please enter a valid number between 0 and 5.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func toggleSwitch(value: Bool, atIndexPath indexPath: IndexPath) {
        yesnoResponses[indexPath.row] = value
        updateSaveButtonState() // Update the save button state
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // Step 1: Calculate the total score
        totalSymptomScore = calculateTotalScore()

        print("Total Symptom Score: \(totalSymptomScore)")

        let validResponses = responses.compactMap { $0 != nil ? Int64($0!) : nil }
        
        print("Valid responses: \(validResponses)")
        
        if validResponses.isEmpty {
            print("No valid responses found, cannot save.")
            return
        }
        
        delegate?.symptomScoreViewController(self, didUpdateSymptomEntries: validResponses)

        performSegue(withIdentifier: "SymptomResultSegue", sender: self)
        
        print("Segue to SymptomResultViewController triggered.")
    }
    
    @IBAction func resultsButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowResultsSegue", sender: self)
    }

    
    private func calculateTotalScore() -> Int64 {
        let symptomScores = responses.compactMap { $0 != nil ? Int64($0!) : nil }
        return symptomScores.reduce(0, +)
    }
    
    private func updateSaveButtonState() {
        let allFieldsFilled = !responses.contains(where: { $0 == nil }) // Check if any responses are nil
        saveButton.isEnabled = allFieldsFilled
        saveButton.alpha = allFieldsFilled ? 1.0 : 0.5 // Grayed out when disabled
    }
}

