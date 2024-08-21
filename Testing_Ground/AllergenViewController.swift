import Foundation
import UIKit
import CoreData

// Define a protocol for the delegate
protocol AddAllergenDelegate: AnyObject {
    func didSaveNewAllergen()
}

class AllergenViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var allergyname: UITextField!
    @IBOutlet weak var severity: UITextField! // Severity Field
    @IBOutlet weak var startdate: UIDatePicker!
    @IBOutlet weak var enddate: UIDatePicker!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var offonswitch: UISwitch!
    @IBOutlet weak var allergyTypeSwitch: UISegmentedControl! // IgE or Non-IgE Switch
    
    var user = ""
    var allergenName = ""
    var isEditMode = false
    
    weak var delegate: AddAllergenDelegate?
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // Set initial visibility of the enddate picker and label
        endDateLabel.isHidden = !offonswitch.isOn
        enddate.isHidden = !offonswitch.isOn
        
        // Connect the switch to the value changed method
        offonswitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        if isEditMode {
            populateDataForEditing()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        // Toggle visibility based on switch state
        endDateLabel.isHidden = !sender.isOn
        enddate.isHidden = !sender.isOn
    }
    
    func populateDataForEditing() {
        let fetchRequest: NSFetchRequest<Allergies> = Allergies.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND name == %@", user, allergenName)
        do {
            let allergens = try managedObjectContext.fetch(fetchRequest)
            if let existingAllergen = allergens.first {
                allergyname.text = existingAllergen.name
                severity.text = existingAllergen.severity // Severity field
                startdate.date = existingAllergen.startdate ?? Date()
                
                if let enddate = existingAllergen.enddate {
                    offonswitch.isOn = true
                    self.enddate.date = enddate
                } else {
                    offonswitch.isOn = false
                }
                
                // Set the allergy type (IgE or Non-IgE)
                allergyTypeSwitch.selectedSegmentIndex = existingAllergen.isIgE ? 0 : 1
                
                // Update visibility of the enddate picker based on switch state
                switchValueChanged(offonswitch)
            }
        } catch {
            print("Error fetching allergen for editing: \(error)")
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if isEditMode {
            // Fetch request to find the existing allergen
            let fetchRequest: NSFetchRequest<Allergies> = Allergies.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "username == %@ AND name == %@", user, allergenName)
            
            do {
                let allergens = try managedObjectContext.fetch(fetchRequest)
                if let existingAllergen = allergens.first {
                    // Update existing allergen details
                    existingAllergen.username = user
                    existingAllergen.name = allergyname.text
                    existingAllergen.severity = severity.text // Severity field
                    existingAllergen.startdate = startdate.date
                    existingAllergen.isIgE = allergyTypeSwitch.selectedSegmentIndex == 0
                    
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
            // Create a new allergen object
            let newAllergen = Allergies(context: managedObjectContext)
            newAllergen.username = user
            newAllergen.name = allergyname.text
            newAllergen.severity = severity.text // Severity field
            newAllergen.startdate = startdate.date
            newAllergen.isIgE = allergyTypeSwitch.selectedSegmentIndex == 0
            
            if offonswitch.isOn {
                newAllergen.enddate = enddate.date
            } else {
                newAllergen.enddate = nil
            }
        }
        
        do {
            try managedObjectContext.save()
            delegate?.didSaveNewAllergen()
            self.navigationController?.popViewController(animated: true)
        } catch {
            print("Error saving allergen: \(error)")
        }
    }
}
