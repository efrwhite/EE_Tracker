import Foundation
import UIKit
import CoreData

// Define a protocol for the delegate
protocol AddAllergenDelegate: AnyObject {
    func didSaveNewAllergen()
}

class AllergenViewController: UIViewController, UITextFieldDelegate {
    
        @IBOutlet weak var allergyname: UITextField!
        @IBOutlet weak var notes: UITextView!
        @IBOutlet weak var frequency: UITextField!
        @IBOutlet weak var startdate: UIDatePicker!
        @IBOutlet weak var enddate: UIDatePicker!
        @IBOutlet weak var endDateLabel: UILabel!
        @IBOutlet weak var offonswitch: UISwitch!
    var user = ""
    var allergenName = ""
    // Rename isEditing to isEditMode
        var isEditMode = false

    // Declare a delegate property
    weak var delegate: AddAllergenDelegate?

    // Create a reference to the Core Data managed object context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPopupButton()
        enddate.isHidden = true
        endDateLabel.isHidden = true
        offonswitch.isOn = false
        print("Edited Pressed ", isEditMode)
        print("Allergen Name ", allergenName)
        if isEditMode {
               // Fetch and populate data for editing an existing medication
               populateDataForEditing()
           } else {
               // Configure the view for adding a new medication
           }
    }

    @objc func switchValueChanged(_ sender: UISwitch) {
        enddate.isHidden = !sender.isOn
        endDateLabel.isHidden = !sender.isOn
    }

    func populateDataForEditing() {
        // Fetch the existing medication based on its name
        let fetchRequest: NSFetchRequest<Allergies> = Allergies.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND name == %@", user, allergenName)
        do {
            let allergens = try managedObjectContext.fetch(fetchRequest)
            if let existingAllergen = allergens.first {
                allergyname.text = existingAllergen.name
                notes.text = existingAllergen.notes
                frequency.text = existingAllergen.frequency
                startdate.date = existingAllergen.startdate!
                
                if let enddate = existingAllergen.enddate {
                    offonswitch.isOn = true
                    self.enddate.date = enddate
                } else {
                    offonswitch.isOn = false
                }
            }
        } catch {
            print("Error fetching medication for editing: \(error)")
        }
    }



    
    @IBAction func saveButton(_ sender: Any) {
            if isEditMode {
                // Add logic to update the existing medication record
                // Fetch the existing medication based on its name
                let fetchRequest: NSFetchRequest<Allergies> = Allergies.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "username == %@ AND name == %@", user, allergenName)
                do {
                    let allergens = try managedObjectContext.fetch(fetchRequest)
                    if let existingAllergen = allergens.first {
                        existingAllergen.username = user
                        existingAllergen.name = allergyname.text
                        existingAllergen.notes = notes.text
                        existingAllergen.frequency = frequency.text
                        existingAllergen.startdate = startdate.date
                        if offonswitch.isOn {
                            existingAllergen.enddate = enddate.date
                        } else {
                            existingAllergen.enddate = nil
                        }
                    }
                } catch {
                    print("Error updating allergen: \(error)")
                }
            } else {
                // Create a new Medication managed object
                let newAllergen = Allergies(context: managedObjectContext)
                
                // Set the attributes based on user input
                newAllergen.username = user
                newAllergen.name = allergyname.text
                newAllergen.notes = notes.text
                newAllergen.frequency = frequency.text
                newAllergen.startdate = startdate.date
                
                if offonswitch.isOn {
                    newAllergen.enddate = enddate.date
                } else {
                    newAllergen.enddate = nil
                }
            }

            // Save the managed object context to persist the data
            do {
                try managedObjectContext.save()
                // Notify the delegate that a new medication was saved
                delegate?.didSaveNewAllergen()
                // Dismiss the AllergenViewController
                self.dismiss(animated: true, completion: nil)
            } catch {
                print("Error saving allergen: \(error)")
            }
        }
    
    func setPopupButton() {
        let optional = { (action: UIAction) in print(action.title) }
        
    }
}
