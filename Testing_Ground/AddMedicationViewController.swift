import Foundation
import UIKit
import CoreData

// Define a protocol for the delegate
protocol AddMedicationDelegate: class {
    func didSaveNewMedication()
}

class AddMedicationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var medicationname: UITextField!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var medicationunits: UIButton!
    @IBOutlet weak var medicationamount: UITextField!
    @IBOutlet weak var frequency: UITextField!
    @IBOutlet weak var enddate: UIDatePicker!
    @IBOutlet weak var startdate: UIDatePicker!
    @IBOutlet weak var hiddenlabel: UILabel!
    @IBOutlet weak var enableEndDateSwitch: UISwitch! // Use a UISwitch to enable/disable the end date
    var user = ""
    // Declare a delegate property
    weak var delegate: AddMedicationDelegate?

    // Create a reference to the Core Data managed object context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPopupButton()
        enddate.isHidden = true // Hide the end date initially
        hiddenlabel.isHidden = true
        enableEndDateSwitch.isOn = false // Set the switch to off position
        enableEndDateSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        enddate.isHidden = !sender.isOn
        hiddenlabel.isHidden = !sender.isOn
    }
    
    @IBAction func saveButton(_ sender: Any) {
        // Create a new Medication managed object
        let newMedication = Medication(context: managedObjectContext)
        
        // Set the attributes based on user input
        newMedication.username = user
        newMedication.medName = medicationname.text
        newMedication.notes = notes.text
        newMedication.medunits = medicationunits.currentTitle
        newMedication.amount = medicationamount.text
        newMedication.frequency = frequency.text
        newMedication.startdate = startdate.date
        
        if enableEndDateSwitch.isOn {
            newMedication.enddate = enddate.date
        } else {
            newMedication.enddate = nil
        }
        
        // Save the managed object context to persist the data
        do {
            try managedObjectContext.save()
            // Notify the delegate that a new medication was saved
            delegate?.didSaveNewMedication()
            // Dismiss the AddMedicationViewController
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("Error saving medication: \(error)")
        }
    }
    
    func setPopupButton() {
        let optional = { (action: UIAction) in print(action.title) }
        
        medicationunits.menu = UIMenu(children: [
            UIAction(title: "milligrams", state: .on, handler: optional),
            UIAction(title: "grams", handler: optional),
        ])
        
        medicationunits.showsMenuAsPrimaryAction = true
        medicationunits.changesSelectionAsPrimaryAction = true
    }
}
