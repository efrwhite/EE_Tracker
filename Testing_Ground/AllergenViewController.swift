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
    @IBOutlet weak var notes: UITextView!
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
        //notes layer (making the notes field more presentable)
        notes.layer.cornerRadius = 5
        notes.layer.borderWidth = 1
        notes.layer.borderColor = UIColor.lightGray.cgColor
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
    //child name needs to be added to the fetch request
    func populateDataForEditing() {
        let fetchRequest: NSFetchRequest<Allergies> = Allergies.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND name == %@", user, allergenName)
        do {
            let allergens = try managedObjectContext.fetch(fetchRequest)
            if let existingAllergen = allergens.first {
                print("Editing existing allergen: \(existingAllergen.name ?? "No name")")
                
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
                
                print("Allergen severity: \(existingAllergen.severity ?? "No severity")")
                print("Allergen type: \(existingAllergen.isIgE ? "IgE" : "Non-IgE")")
                print("Allergen start date: \(existingAllergen.startdate ?? Date())")
            }
        } catch {
            print("Error fetching allergen for editing: \(error)")
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        print("Save button tapped")
        
        //put in its own fetch function
        if isEditMode {
            // Fetch request to find the existing allergen
            let fetchRequest: NSFetchRequest<Allergies> = Allergies.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "username == %@ AND name == %@", user, allergenName)
            
            do {
                let allergens = try managedObjectContext.fetch(fetchRequest)
                if let existingAllergen = allergens.first {
                    // Update existing allergen details
                    print("Updating existing allergen: \(existingAllergen.name ?? "No name")")
                    
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
                    
                    print("Updated allergen name: \(existingAllergen.name ?? "No name")")
                    print("Updated allergen severity: \(existingAllergen.severity ?? "No severity")")
                    print("Updated allergen type: \(existingAllergen.isIgE ? "IgE" : "Non-IgE")")
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
            
            print("New allergen added:")
            print("Name: \(newAllergen.name ?? "No name")")
            print("Severity: \(newAllergen.severity ?? "No severity")")
            print("Type: \(newAllergen.isIgE ? "IgE" : "Non-IgE")")
            print("Start date: \(String(describing: newAllergen.startdate))")
        }
        
        do {
                try managedObjectContext.save()
                print("Allergen saved successfully")
                
                // Notify the delegate before popping the view controller
                delegate?.didSaveNewAllergen()
                
                // Use completion block to ensure data reload before dismissing
                self.navigationController?.popViewController(animated: true)
            } catch {
                print("Error saving allergen: \(error)")
            }
    }
}
