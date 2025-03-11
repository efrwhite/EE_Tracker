//import Foundation
//import UIKit
//import CoreData
//
////protocol AddMedicationDelegate: AnyObject {
////    func didSaveNewMedication()
////}
//
//class AddMedicationViewController: UIViewController  {
//    var isEditMode = false
//    var user = ""
//    var childName = ""
//    var medicationName = ""
//    @IBOutlet weak var medicationname: UITextField!
//    @IBOutlet weak var enddatelabel: UILabel!
//    @IBOutlet weak var enddate: UIDatePicker!
//    @IBOutlet weak var discontinuedswitch: UISwitch!
//    @IBOutlet weak var notes: UITextView!
//    @IBOutlet weak var frequency: UITextField!
//    @IBOutlet weak var startdate: UIDatePicker!
//    @IBOutlet weak var dosagetype: UIPickerView!
//    @IBOutlet weak var dosageAmount: UITextField!
//    let dosageUnits = ["mg", "ml", "tablet", "capsule"] //this goes with dosageType
//    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    
//    override func viewDidLoad() {
//        print("On add medication page")
//    }
//    
//    @IBAction func savebutton(_ sender: Any) {
//        print("Save Button pressed")
//    }
//    func SaveToCoreData() {
//        guard let medName = medicationname.text, !medName.isEmpty else {
//            print("Medication name is required.")
//            return
//        }
//
//        if isEditMode {
//            let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "userName == %@ AND childName == %@ AND medName == %@", user, childName, medicationName)
//
//            do {
//                let medications = try managedObjectContext.fetch(fetchRequest)
//                if let existingMedication = medications.first {
//                    existingMedication.userName = user
//                    existingMedication.childName = childName
//                    existingMedication.medName = medicationname.text
//                    existingMedication.notes = notes.text
//                    existingMedication.frequency = frequency.text
//                    existingMedication.startdate = startdate.date
//                    existingMedication.enddate = discontinuedswitch.isOn ? enddate.date : nil
//                    
//                    // Ensure these properties exist in your class
//                    
//                }
//            } catch {
//                print("Error updating medication: \(error)")
//            }
//        } else {
//            let newMedication = Medication(context: managedObjectContext)
//            newMedication.userName = user
//            newMedication.childName = childName
//            newMedication.medName = medicationname.text
//            newMedication.notes = notes.text
//            newMedication.frequency = frequency.text
//            newMedication.startdate = startdate.date
//            newMedication.enddate = discontinuedswitch.isOn ? enddate.date : nil
//
//          
//        }
//
//        do {
//            try managedObjectContext.save()
//            print("Medication saved successfully!")
//            self.navigationController?.popViewController(animated: true)
//        } catch {
//            print("Error saving medication: \(error)")
//        }
//    }
//
//    func PopulateCoreData(){
//        //populating the controller if the view is being edited
//        let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "userName == %@ AND childName == %@ AND medName == %@", user,childName ,medicationName)
//    }
//   
//}


import Foundation
import UIKit
import CoreData

class AddMedicationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var isEditMode = false
    var user = ""
    var childName = ""
    var medicationName = ""

    @IBOutlet weak var medicationname: UITextField!
    @IBOutlet weak var enddatelabel: UILabel!
    @IBOutlet weak var enddate: UIDatePicker!
    @IBOutlet weak var discontinuedswitch: UISwitch!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var frequency: UITextField!
    @IBOutlet weak var startdate: UIDatePicker!
    @IBOutlet weak var dosagetype: UIPickerView!
    @IBOutlet weak var dosageAmount: UITextField!

    let dosageUnits = ["mg", "ml", "tablet", "capsule"] // PickerView options
    var selectedDosageUnit: String? // Stores selected unit

    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        print(
            "On add medication page: ",
            "User: ",
            user,
            "Child Name: ",
            childName
            , "MedName: ", medicationName )
        
        // Set PickerView delegates
        dosagetype.delegate = self
        dosagetype.dataSource = self
        
        // Set switch to off by default
        discontinuedswitch.isOn = false
        
        // Initially hide end date and label
        toggleEndDateVisibility(isVisible: false)
        
        // Add target to switch for value change
        discontinuedswitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        
        //notes layer
        notes.layer.cornerRadius = 5
        notes.layer.borderWidth = 1
        notes.layer.borderColor = UIColor.lightGray.cgColor
        // Populate fields if edit mode is active
        populatedataifeditison()
    }

    // Function to toggle visibility of end date and label
    func toggleEndDateVisibility(isVisible: Bool) {
        enddatelabel.isHidden = !isVisible
        enddate.isHidden = !isVisible
    }

    // Called when switch value changes
    @objc func switchValueChanged() {
        toggleEndDateVisibility(isVisible: discontinuedswitch.isOn)
    }

    // MARK: - UIPickerView DataSource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Only one column
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dosageUnits.count
    }

    // MARK: - UIPickerView Delegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dosageUnits[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDosageUnit = dosageUnits[row] // Store the selected unit
    }

    @IBAction func savebutton(_ sender: Any) {
        print("Save Button pressed")
        SaveToCoreData()
    }

    func SaveToCoreData() {
        guard let medName = medicationname.text, !medName.isEmpty else {
            print("Medication name is required.")
            return
        }
        
        guard let dosageUnit = selectedDosageUnit else {
            print("Please select a dosage unit.")
            return
        }

        if isEditMode {
            let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "userName == %@ AND childName == %@ AND medName == %@", user, childName, medicationName)

            do {
                let medications = try managedObjectContext.fetch(fetchRequest)
                if let existingMedication = medications.first {
                    existingMedication.userName = user
                    existingMedication.childName = childName
                    existingMedication.medName = medicationname.text
                    existingMedication.notes = notes.text
                    existingMedication.frequency = frequency.text
                    existingMedication.startdate = startdate.date
                    existingMedication.enddate = discontinuedswitch.isOn ? enddate.date : nil
                    existingMedication.medunits = dosageUnit
                }
            } catch {
                print("Error updating medication: \(error)")
            }
        } else {
            let newMedication = Medication(context: managedObjectContext)
            newMedication.userName = user
            newMedication.childName = childName
            newMedication.medName = medicationname.text
            newMedication.notes = notes.text
            newMedication.frequency = frequency.text
            newMedication.startdate = startdate.date
            newMedication.enddate = discontinuedswitch.isOn ? enddate.date : nil
            newMedication.medunits = dosageUnit
        }

        do {
            try managedObjectContext.save()
            print("Medication saved successfully!")
            self.navigationController?.popViewController(animated: true)
        } catch {
            print("Error saving medication: \(error)")
        }
    }
    
    func populatedataifeditison() {
        guard isEditMode else { return } // Only populate if edit mode is enabled

        let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userName == %@ AND childName == %@ AND medName == %@", user, childName, medicationName)

        do {
            let medications = try managedObjectContext.fetch(fetchRequest)
            if let existingMedication = medications.first {
                // Populate UI elements with existing medication data
                medicationname.text = existingMedication.medName
                notes.text = existingMedication.notes
                frequency.text = existingMedication.frequency
                startdate.date = existingMedication.startdate ?? Date()
                
                if let endDate = existingMedication.enddate {
                    enddate.date = endDate
                    discontinuedswitch.isOn = true
                    toggleEndDateVisibility(isVisible: true)
                } else {
                    discontinuedswitch.isOn = false
                    toggleEndDateVisibility(isVisible: false)
                }
                
                // Set the picker to the correct dosage unit
                if let medUnit = existingMedication.medunits, let index = dosageUnits.firstIndex(of: medUnit) {
                    dosagetype.selectRow(index, inComponent: 0, animated: true)
                    selectedDosageUnit = medUnit
                }
            }
        } catch {
            print("Error fetching medication data: \(error)")
        }
    }

}

