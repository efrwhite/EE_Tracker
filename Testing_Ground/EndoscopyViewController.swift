import UIKit
import CoreData

class EndoscopyViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var saveButton: UIButton!
    var user = ""
    var childName = ""
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let eoELabel: UILabel = {
        let label = UILabel()
        label.text = "EoE"
        label.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
        return label
    }()
    
    let proximateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Proximate:"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let middleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Middle:"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let lowerTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Lower:"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let stomachLabel: UILabel = {
        let label = UILabel()
        label.text = "Stomach"
        label.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
        return label
    }()
    
    let stomachTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let duodenumLabel: UILabel = {
        let label = UILabel()
        label.text = "Duodenum"
        label.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
        return label
    }()
    
    let duodenumTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let colonLabel: UILabel = {
        let label = UILabel()
        label.text = "Colon"
        label.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
        return label
    }()
    
    let rightColonTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Right:"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let middleColonTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Middle:"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let leftColonTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Left:"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup UI
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(eoELabel)
        mainStackView.addArrangedSubview(proximateTextField)
        mainStackView.addArrangedSubview(middleTextField)
        mainStackView.addArrangedSubview(lowerTextField)
        mainStackView.addArrangedSubview(stomachLabel)
        mainStackView.addArrangedSubview(stomachTextField)
        mainStackView.addArrangedSubview(duodenumLabel)
        mainStackView.addArrangedSubview(duodenumTextField)
        mainStackView.addArrangedSubview(colonLabel)
        mainStackView.addArrangedSubview(rightColonTextField)
        mainStackView.addArrangedSubview(middleColonTextField)
        mainStackView.addArrangedSubview(leftColonTextField)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Gesture to dismiss keyboard on tap outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let keyboardHeight = keyboardFrame.height
        let bottomSafeAreaInset = view.safeAreaInsets.bottom
        let topOffset = eoELabel.frame.maxY + 200 // Adjust this value as needed
        
        UIView.animate(withDuration: duration) {
            self.view.frame.origin.y = -keyboardHeight + bottomSafeAreaInset + topOffset
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        UIView.animate(withDuration: duration) {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Button Action
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveEndoscopyResults()
    }
    //Brianna is editting this area, no user or childname to tie this data too
    func saveEndoscopyResults() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        // Create a new NSManagedObject for the 'Endoscopy' entity
        let entity = NSEntityDescription.entity(forEntityName: "Endoscopy", in: context)!
        let newEndoscopyResult = NSManagedObject(entity: entity, insertInto: context)

        // Use setValue(_:forKey:) to set values for each attribute
        newEndoscopyResult.setValue(Date(), forKey: "date") // Use the current date or a date picker
        let proximateValue = Int32(proximateTextField.text ?? "0") ?? 0
        let middleValue = Int32(middleTextField.text ?? "0") ?? 0
        let lowerValue = Int32(lowerTextField.text ?? "0") ?? 0
        let stomachValue = Int32(stomachTextField.text ?? "0") ?? 0
        let duodenumValue = Int32(duodenumTextField.text ?? "0") ?? 0
        let rightColonValue = Int32(rightColonTextField.text ?? "0") ?? 0
        let middleColonValue = Int32(middleColonTextField.text ?? "0") ?? 0
        let leftColonValue = Int32(leftColonTextField.text ?? "0") ?? 0
        let sum = proximateValue + middleValue + lowerValue + stomachValue + duodenumValue + rightColonValue + middleColonValue + leftColonValue
        newEndoscopyResult.setValue(sum, forKey: "sum")

        print("Attempting to save Endoscopy result with sum: \(sum)")

        do {
            try context.save()
            print("Endoscopy result saved successfully.")
            navigateToResultsViewController()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func navigateToResultsViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let resultsVC = storyboard.instantiateViewController(withIdentifier: "ResultsViewController") as? ResultsViewController {
            navigationController?.pushViewController(resultsVC, animated: true)
        }
    }
}
