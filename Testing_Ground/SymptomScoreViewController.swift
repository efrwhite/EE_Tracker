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
        titleLabel.font = UIFont(name: "Times New Roman", size: 17)
        titleLabel.textColor = .black // Adjust as necessary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)

        // Add Auto Layout constraints
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8), // Add padding from the top
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8) // Add padding from the bottom
        ])
        
        // Set the background color for better visibility
        backgroundColor = .lightGray
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
    var selectedDate: Date?
    
    private var isSegueInProgress = false
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let scoreVC = segue.destination as? ScoreViewController, segue.identifier == "SymptomResultSegue" else { return }
        
        let date = selectedDate ?? Date()
        let newEntry = ScoreViewController.SurveyEntry(sum: totalSymptomScore, date: date)
        
        // Clear any existing entries for the same date to prevent duplicates
        scoreVC.symptomSumScores.removeAll { $0.date == date }
        scoreVC.symptomSumScores.append(newEntry)

        if let scoreVC = segue.destination as? ScoreViewController {
            if segue.identifier == "SymptomResultSegue" {
                // Use selectedDate for the entry or fallback to the current date
                let date = self.selectedDate ?? Date()
                
                print("Segue to ScoreViewController triggered.")
                        
                // Safely cast the destination to ScoreViewController
                        if let destination = segue.destination as? ScoreViewController {
                            // Map capturedData to the SurveyEntry type
                            destination.symptomSumScores = capturedData.compactMap { dict in
                                guard
                                    let sum = dict["sum"] as? Int64,
                                    let date = dict["date"] as? Date
                                else {
                                    return nil
                                }
                                return ScoreViewController.SurveyEntry(sum: sum, date: date)
                            }
                            print("Data passed to ScoreViewController: \(destination.symptomSumScores)")
                        }
                // Create a SurveyEntry with the selected date and score
                let newEntry = ScoreViewController.SurveyEntry(sum: totalSymptomScore, date: date)

                // Append the new entry to the ScoreViewController's symptomSumScores
                scoreVC.symptomSumScores.append(newEntry)
            } else if segue.identifier == "ShowResultsSegue" {
                // Handle data transfer for the "Results" button if needed
                // No additional data transfer here for now.
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isSegueInProgress = false
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
        
        showDatePickerPopup()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSavedData()
        symptomTableView.reloadData()
    }

    func loadSavedData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Symptom>(entityName: "Symptom")
        
        do {
            let savedEntries = try context.fetch(fetchRequest)
            capturedData = savedEntries.map { entry in
                [
                    "date": entry.date,
                    "symptomSum": entry.symptomSum,
                    "response": entry.response
                ]
            }
        } catch {
            print("Failed to fetch saved data: \(error)")
        }

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
            ? "For the questions below, insert a value from 0-4\n0 = Not at all, 4 = Very often"
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
    
    func showDatePickerPopup() {
        // Create a custom view controller to host the date picker
        let popupVC = UIViewController()
        popupVC.preferredContentSize = CGSize(width: UIScreen.main.bounds.width * 0.9, height: 300)
        
        // Create the container view to hold the date picker
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        containerView.translatesAutoresizingMaskIntoConstraints = false
        popupVC.view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: popupVC.view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: popupVC.view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: popupVC.view.widthAnchor, multiplier: 0.9),
            containerView.heightAnchor.constraint(equalTo: popupVC.view.heightAnchor, multiplier: 0.8)
        ])
        
        // Add the title label
        let titleLabel = UILabel()
        titleLabel.text = "Date"
        titleLabel.font = UIFont(name: "Lato-Bold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0) // RGB #394390
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9)
        ])
        
        // Add the UIDatePicker below the title
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            datePicker.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9),
            datePicker.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.6)
        ])
        
        // Add OK button below the date picker
        let okButton = UIButton(type: .system)
        okButton.setTitle("OK", for: .normal)
        okButton.titleLabel?.font = UIFont(name: "Lato-Bold", size: 35) ?? UIFont.boldSystemFont(ofSize: 10)
        okButton.setTitleColor(UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0), for: .normal) // RGB #394390
        okButton.addTarget(self, action: #selector(datePickerOkTapped(_:)), for: .touchUpInside)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(okButton)
        
        NSLayoutConstraint.activate([
            okButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            okButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
        
        // Present the popup as a modal
        popupVC.modalPresentationStyle = .popover
        popupVC.popoverPresentationController?.sourceView = self.view
        popupVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        popupVC.popoverPresentationController?.permittedArrowDirections = []
        present(popupVC, animated: true, completion: nil)
    }

    @objc func datePickerOkTapped(_ sender: UIButton) {
        guard let containerView = sender.superview,
              let datePicker = containerView.subviews.compactMap({ $0 as? UIDatePicker }).first else {
            return
        }
        self.selectedDate = datePicker.date
        dismiss(animated: true)
    }



    func didEditTextField(_ text: String, atIndexPath indexPath: IndexPath) {
        guard !text.isEmpty else {
            showAlertForEmptyInput()
            responses[indexPath.row] = nil
            updateSaveButtonState() // Update the save button state
            return
        }
        
        if let value = Int(text), value >= 0, value <= 4 {
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
        let alert = UIAlertController(title: "Invalid Input", message: "Please enter a valid number between 0 and 4.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func toggleSwitch(value: Bool, atIndexPath indexPath: IndexPath) {
        yesnoResponses[indexPath.row] = value
        updateSaveButtonState() // Update the save button state
    }
    
    func showAlertForEmptyDate() {
        let alert = UIAlertController(title: "Error", message: "Please select a date before saving.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let date = selectedDate else {
            showAlertForEmptyDate()
            return
        }
        
        if isSegueInProgress {
                print("Segue already in progress, skipping.")
                return
            }
        
        isSegueInProgress = true // Set the flag
        saveButton.isEnabled = false

        saveSurveyData(date: date)
        totalSymptomScore = calculateTotalScore()

        performSegue(withIdentifier: "SymptomResultSegue", sender: self)
        
        func saveSurveyData(date: Date) {
            // Avoid duplicate entries
            if capturedData.contains(where: { ($0["date"] as? Date) == date }) {
                print("Data for this date already exists.")
                return
            }
            
            // Save new data
            let newEntry: [String: Any] = ["date": date, "symptomSum": totalSymptomScore, "response": responses]
            capturedData.append(newEntry)
        }


        // Calculate the total symptom score
        totalSymptomScore = calculateTotalScore()
        print("Total Symptom Score: \(totalSymptomScore)")

        // Validate responses
        let validResponses = responses.compactMap { $0 != nil ? Int64($0!) : nil }
        print("Valid responses: \(validResponses)")

        if validResponses.isEmpty {
            print("No valid responses found, cannot save.")
            showAlert(message: "Please complete all survey questions before saving.")
            return
        }

        // Save data to Core Data
        saveDataToCoreData(date: date, symptomSum: totalSymptomScore, validResponses: validResponses)

        // Notify delegate if applicable
        delegate?.symptomScoreViewController(self, didUpdateSymptomEntries: validResponses)
    }


    // Helper function to show alerts
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // Core Data saving logic
    func saveDataToCoreData(date: Date, symptomSum: Int64, validResponses: [Int64]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Unable to access AppDelegate.")
            return
        }

        
        let context = appDelegate.persistentContainer.viewContext

        // Save each response as a separate Symptom entity
        for (index, response) in validResponses.enumerated() {
            let newSymptom = Symptom(context: context)
            newSymptom.date = date
            newSymptom.symptomSum = symptomSum
            newSymptom.question = "Question \(index + 1)" // Replace with actual question text if available
            newSymptom.response = String(response) // Store response as a String
        }

        // Save the context
        do {
            try context.save()
            print("Data saved successfully.")
        } catch {
            print("Failed to save data: \(error)")
            showAlert(message: "An error occurred while saving data. Please try again.")
        }

        
        delegate?.symptomScoreViewController(self, didUpdateSymptomEntries: validResponses)
        
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

