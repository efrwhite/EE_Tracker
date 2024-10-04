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
        
        var responses: [String?] = []
        var yesnoResponses: [Bool] = []
        var totalSymptomScore: Int64 = 0
        
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
                ? "For the questions below, insert a value from 0-5\n0 = No pain, 5 = Excruciating pain"
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
                return
            }
            
            if let value = Int(text), value >= 0, value <= 5 {
                responses[indexPath.row] = text
            } else {
                showAlertForInvalidInput()
                responses[indexPath.row] = nil
            }
        }
        
        @IBAction func saveButtonTapped(_ sender: UIButton) {
            calculateTotalSymptomScore()
            performSegue(withIdentifier: "SymptomResultSegue", sender: self) // Programmatic segue
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "SymptomResultSegue", let destinationVC = segue.destination as? ScoreViewController {
                destinationVC.totalSymptomScore = totalSymptomScore
            }
        }
        
        func calculateTotalSymptomScore() {
            totalSymptomScore = responses.compactMap { Int64($0 ?? "0") }.reduce(0, +)
        }
        
        private func showAlertForEmptyInput() {
            let alert = UIAlertController(title: "Invalid Input", message: "Please enter a value between 0-5.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
        
        private func showAlertForInvalidInput() {
            let alert = UIAlertController(title: "Invalid Input", message: "Please enter a valid number between 0 and 5.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
