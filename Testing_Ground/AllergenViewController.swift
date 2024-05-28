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
    var isEditMode = false
    
    weak var delegate: AddAllergenDelegate?
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
            super.viewDidLoad()
           // setupLayout()
            print("Edited Pressed ", isEditMode)
            print("Allergen Name ", allergenName)
            
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
                notes.text = existingAllergen.notes
                frequency.text = existingAllergen.frequency
                startdate.date = existingAllergen.startdate!
                
                if let enddate = existingAllergen.enddate {
                    offonswitch.isOn = false
                    self.enddate.date = enddate
                } else {
                    offonswitch.isOn = true
                }
            }
        } catch {
            print("Error fetching medication for editing: \(error)")
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
            // Create a new allergen object
            let newAllergen = Allergies(context: managedObjectContext)
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
        
        do {
            try managedObjectContext.save()
            delegate?.didSaveNewAllergen()
            // Pop the current view controller to return to the previous view controller, which should be AddAllergenViewController
            self.navigationController?.popViewController(animated: true)
        } catch {
            print("Error saving allergen: \(error)")
        }
    }

    
//    func setupLayout() {
//        allergyname.translatesAutoresizingMaskIntoConstraints = false
//        notes.translatesAutoresizingMaskIntoConstraints = false
//        frequency.translatesAutoresizingMaskIntoConstraints = false
//        startdate.translatesAutoresizingMaskIntoConstraints = false
//        enddate.translatesAutoresizingMaskIntoConstraints = false
//        endDateLabel.translatesAutoresizingMaskIntoConstraints = false
//        offonswitch.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Constraints for allergen label and field
//            NSLayoutConstraint.activate([
//                allergenLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//                allergenLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//
//                allergyname.centerYAnchor.constraint(equalTo: allergenLabel.centerYAnchor),
//                allergyname.leadingAnchor.constraint(equalTo: allergenLabel.trailingAnchor, constant: 8),
//                allergyname.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//                allergyname.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65), // Adjust width as a percentage of the view's width
//                allergyname.heightAnchor.constraint(equalToConstant: 30), // Adjust height
//            ])
//        
//        // Constraints for frequency label and field
//            NSLayoutConstraint.activate([
//                frequencyLabel.topAnchor.constraint(equalTo: allergyname.bottomAnchor, constant: 20),
//                frequencyLabel.leadingAnchor.constraint(equalTo: allergenLabel.leadingAnchor),
//
//                frequency.centerYAnchor.constraint(equalTo: frequencyLabel.centerYAnchor),
//                frequency.leadingAnchor.constraint(equalTo: frequencyLabel.trailingAnchor, constant: 8),
//                frequency.trailingAnchor.constraint(equalTo: allergyname.trailingAnchor),
//            ])
//        
//        frequency.widthAnchor.constraint(equalTo: allergyname.widthAnchor).isActive = true
//
//        
//        // Constraints for start date label and picker
//        NSLayoutConstraint.activate([
//            startDateLabel.topAnchor.constraint(equalTo: frequency.bottomAnchor, constant: 20),
//            startDateLabel.leadingAnchor.constraint(equalTo: allergenLabel.leadingAnchor),
//            
//            startdate.centerYAnchor.constraint(equalTo: startDateLabel.centerYAnchor),
//            startdate.leadingAnchor.constraint(equalTo: startDateLabel.trailingAnchor, constant: 8),
//            startdate.trailingAnchor.constraint(equalTo: allergyname.trailingAnchor),
//        ])
//        
//        // Constraints for allergy discontinued label and switch
//        NSLayoutConstraint.activate([
//            allergyDiscontinuedLabel.topAnchor.constraint(equalTo: startdate.bottomAnchor, constant: 20),
//            allergyDiscontinuedLabel.leadingAnchor.constraint(equalTo: allergenLabel.leadingAnchor),
//            
//            offonswitch.centerYAnchor.constraint(equalTo: allergyDiscontinuedLabel.centerYAnchor),
//            offonswitch.trailingAnchor.constraint(equalTo: allergyname.trailingAnchor),
//        ])
//        
//        // Constraints for end date label and picker
//        NSLayoutConstraint.activate([
//            endDateLabel.topAnchor.constraint(equalTo: offonswitch.bottomAnchor, constant: 20),
//            endDateLabel.leadingAnchor.constraint(equalTo: allergenLabel.leadingAnchor),
//            
//            enddate.centerYAnchor.constraint(equalTo: endDateLabel.centerYAnchor),
//            enddate.leadingAnchor.constraint(equalTo: endDateLabel.trailingAnchor, constant: 8),
//            enddate.trailingAnchor.constraint(equalTo: allergyname.trailingAnchor),
//        ])
//        
//        // Constraints for notes label and text field
//        NSLayoutConstraint.activate([
//            notesLabel.topAnchor.constraint(equalTo: enddate.bottomAnchor, constant: 20),
//            notesLabel.leadingAnchor.constraint(equalTo: allergenLabel.leadingAnchor),
//            
//            notes.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 8),
//            notes.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            notes.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//            notes.heightAnchor.constraint(equalToConstant: 150),
//        ])
//        
//        endDateLabel.isHidden = !offonswitch.isOn
//            enddate.isHidden = !offonswitch.isOn
//
//            offonswitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
//        }
//    
}
