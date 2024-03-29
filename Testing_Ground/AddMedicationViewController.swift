import Foundation
import UIKit
import CoreData

// Define a protocol for the delegate
protocol AddMedicationDelegate: AnyObject {
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
    @IBOutlet weak var enableEndDateSwitch: UISwitch!
    var user = ""
    var medicationName = ""
    var isEditMode = false

    weak var delegate: AddMedicationDelegate?

    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPopupButton()
        enddate.isHidden = true
        hiddenlabel.isHidden = true
        enableEndDateSwitch.isOn = false
        print("Edited Pressed ", isEditMode)
        print("Medication Name ", medicationName)
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        if isEditMode {
            populateDataForEditing()
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func switchValueChanged(_ sender: UISwitch) {
        enddate.isHidden = !sender.isOn
        hiddenlabel.isHidden = !sender.isOn
    }

    func populateDataForEditing() {
        let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND medName == %@", user, medicationName)
        do {
            let medications = try managedObjectContext.fetch(fetchRequest)
            if let existingMedication = medications.first {
                medicationname.text = existingMedication.medName
                notes.text = existingMedication.notes
                medicationunits.setTitle(existingMedication.medunits, for: .normal)
                medicationamount.text = existingMedication.amount
                frequency.text = existingMedication.frequency
                startdate.date = existingMedication.startdate!
                
                if let enddate = existingMedication.enddate {
                    enableEndDateSwitch.isOn = true
                    self.enddate.date = enddate
                } else {
                    enableEndDateSwitch.isOn = false
                }
            }
        } catch {
            print("Error fetching medication for editing: \(error)")
        }
    }

    @IBAction func saveButton(_ sender: Any) {
        if isEditMode {
            let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "username == %@ AND medName == %@", user, medicationName)
            do {
                let medications = try managedObjectContext.fetch(fetchRequest)
                if let existingMedication = medications.first {
                    existingMedication.username = user
                    existingMedication.medName = medicationname.text
                    existingMedication.notes = notes.text
                    existingMedication.medunits = medicationunits.currentTitle
                    existingMedication.amount = medicationamount.text
                    existingMedication.frequency = frequency.text
                    existingMedication.startdate = startdate.date
                    if enableEndDateSwitch.isOn {
                        existingMedication.enddate = enddate.date
                    } else {
                        existingMedication.enddate = nil
                    }
                }
            } catch {
                print("Error updating medication: \(error)")
            }
        } else {
            let newMedication = Medication(context: managedObjectContext)
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
        }

        do {
            try managedObjectContext.save()
            delegate?.didSaveNewMedication()
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
