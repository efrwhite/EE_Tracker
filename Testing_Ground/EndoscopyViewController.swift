import UIKit
import CoreData

class EndoscopyViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Endoscopy"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
        return label
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
    }
    
    // MARK: - Setup UI
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleLabel)
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
    }
    
    // MARK: - Button Action
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveEndoscopyResults()
    }
    
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
