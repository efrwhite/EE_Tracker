import Foundation
import UIKit
import CoreData

class AllergenViewController: UIViewController {
    
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var enddate: UIDatePicker!
    @IBOutlet weak var offonswitch: UISwitch!
    @IBOutlet weak var startdate: UIDatePicker!
    @IBOutlet weak var frequency: UITextField!
    @IBOutlet weak var allergyname: UITextField!
    @IBOutlet weak var endDateLabel: UILabel!
    var user = "" // Set the user as needed
    
    // Create a reference to the Core Data managed object context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Allergy View User ", user)
        
        // Set the initial state of the switch to off
        offonswitch.isOn = false
        
        // Hide the enddate and its label by default
        enddate.isHidden = true
        endDateLabel.isHidden = true
    }


    
   
    
    @IBAction func saveButton(_ sender: UIButton) {
        // Create a new Allergy managed object
        let newAllergy = Allergies(context: managedObjectContext)
        
        // Set the attributes based on user input
        newAllergy.username = user
        newAllergy.name = allergyname.text
        newAllergy.notes = notes.text
        newAllergy.frequency = frequency.text
        newAllergy.startdate = startdate.date
        
        if offonswitch.isOn {
            newAllergy.enddate = enddate.date
        } else {
            newAllergy.enddate = nil
        }
        
        // Save the managed object context to persist the data
        do {
            try managedObjectContext.save()
            // Optionally, you can notify a delegate or perform other actions here.
        } catch {
            print("Error saving allergy: \(error)")
        }
        
        // Dismiss the AllergenViewController (optional)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func switchValueChanged(_ sender: UISwitch) {
        // Show/hide the enddate and label based on the switch value
        enddate.isHidden = !sender.isOn
        endDateLabel.isHidden = !sender.isOn
        }
}

