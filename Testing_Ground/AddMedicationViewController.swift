import Foundation
import UIKit
import CoreData

protocol AddMedicationDelegate: AnyObject {
    func didSaveNewMedication()
}

class AddMedicationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let medicationNameLabel = UILabel()
    let medicationname = UITextField()
    
    let dosageLabel = UILabel()
    let dosageStackView = UIStackView()
    let dosageNumberPicker = UIPickerView()
    let medicationunits = UIPickerView()
    
    let startDateLabel = UILabel()
    let startdate = UIDatePicker()
    
    let frequencyLabel = UILabel()
    let frequency = UITextField()
    
    let discontinueLabel = UILabel()
    let enableEndDateSwitch = UISwitch()
    
    let endDateLabel = UILabel()
    let enddate = UIDatePicker()
        
    let saveButton = UIButton(type: .system)
    
    let notesButton = UIButton(type: .system)
    let notesTextField = UITextField()
    
    let dosageUnits = ["mg", "ml", "tablet", "capsule"]
    
    var user = ""
    var childName = ""
    var medicationName = ""
    var isEditMode = false

    weak var delegate: AddMedicationDelegate?

    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupKeyboardNotifications()
        setupKeyboardDismissal()
        
        if isEditMode {
            populateDataForEditing()
        }
    }

    func setupUI() {
        view.backgroundColor = UIColor(red: 224/255, green: 201/255, blue: 162/255, alpha: 1.0)
        title = "Add Medications"
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    
        
        medicationNameLabel.text = "Medication Name"
        medicationNameLabel.font = UIFont(name: "Lato", size: 17.0)
        medicationNameLabel.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
        medicationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(medicationNameLabel)
        
        medicationname.borderStyle = .roundedRect
        medicationname.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(medicationname)
        
        notesButton.setTitle("Notes", for: .normal)
        notesButton.addTarget(self, action: #selector(notesButtonTapped), for: .touchUpInside)
        notesButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(notesButton)
        
            // Setup Notes text field
        notesTextField.borderStyle = .roundedRect
        notesTextField.placeholder = "Enter your notes here..."
        notesTextField.translatesAutoresizingMaskIntoConstraints = false
        notesTextField.isHidden = true  // Initially hidden
            contentView.addSubview(notesTextField)
        
        dosageLabel.text = "Dosage"
        dosageLabel.font = UIFont(name: "Lato", size: 17.0)
        dosageLabel.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
        dosageLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dosageLabel)
        
        dosageStackView.axis = .horizontal
        dosageStackView.spacing = 10
        dosageStackView.distribution = .fillEqually
        dosageStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dosageStackView)
        
        dosageNumberPicker.delegate = self
        dosageNumberPicker.dataSource = self
        dosageNumberPicker.translatesAutoresizingMaskIntoConstraints = false
        dosageNumberPicker.heightAnchor.constraint(equalToConstant: 60).isActive = true
        dosageStackView.addArrangedSubview(dosageNumberPicker)
        
        medicationunits.delegate = self
        medicationunits.dataSource = self
        medicationunits.translatesAutoresizingMaskIntoConstraints = false
        medicationunits.heightAnchor.constraint(equalToConstant: 60).isActive = true
        dosageStackView.addArrangedSubview(medicationunits)
        
        startDateLabel.text = "Start Date"
        startDateLabel.font = UIFont(name: "Lato", size: 17.0)
        startDateLabel.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
        startDateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(startDateLabel)
        
        startdate.datePickerMode = .date
        startdate.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(startdate)
        
        frequencyLabel.text = "Frequency"
        frequencyLabel.font = UIFont(name: "Lato", size: 17.0)
        frequencyLabel.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
        frequencyLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(frequencyLabel)
        
        frequency.borderStyle = .roundedRect
        frequency.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(frequency)
        
        discontinueLabel.text = "Discontinue the medication?"
        discontinueLabel.font = UIFont(name: "Lato", size: 17.0)
        discontinueLabel.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
        discontinueLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(discontinueLabel)
        
        enableEndDateSwitch.translatesAutoresizingMaskIntoConstraints = false
        enableEndDateSwitch.addTarget(self, action: #selector(discontinueSwitchChanged), for: .valueChanged)
        contentView.addSubview(enableEndDateSwitch)
        
        endDateLabel.text = "End Date"
        endDateLabel.font = UIFont(name: "Lato", size: 17.0)
        endDateLabel.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
        endDateLabel.translatesAutoresizingMaskIntoConstraints = false
        endDateLabel.isHidden = true
        contentView.addSubview(endDateLabel)
        
        enddate.datePickerMode = .date
        enddate.translatesAutoresizingMaskIntoConstraints = false
        enddate.isHidden = true
        contentView.addSubview(enddate)
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.titleLabel?.font = UIFont(name: "Lato", size: 17.0)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        contentView.addSubview(saveButton)
    }
    
    func setupConstraints() {
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            medicationNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 80),
            medicationNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            medicationname.topAnchor.constraint(equalTo: medicationNameLabel.bottomAnchor, constant: 8),
            medicationname.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            medicationname.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            dosageLabel.topAnchor.constraint(equalTo: medicationname.bottomAnchor, constant: 20),
            dosageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            dosageStackView.topAnchor.constraint(equalTo: dosageLabel.bottomAnchor, constant: 8),
            dosageStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dosageStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            startDateLabel.topAnchor.constraint(equalTo: dosageStackView.bottomAnchor, constant: 20),
            startDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            startdate.topAnchor.constraint(equalTo: startDateLabel.bottomAnchor, constant: 8),
            startdate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            startdate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            frequencyLabel.topAnchor.constraint(equalTo: startdate.bottomAnchor, constant: 20),
            frequencyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            frequency.topAnchor.constraint(equalTo: frequencyLabel.bottomAnchor, constant: 8),
            frequency.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            frequency.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            discontinueLabel.topAnchor.constraint(equalTo: frequency.bottomAnchor, constant: 20),
            discontinueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            enableEndDateSwitch.topAnchor.constraint(equalTo: discontinueLabel.bottomAnchor, constant: 8),
            enableEndDateSwitch.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            endDateLabel.topAnchor.constraint(equalTo: enableEndDateSwitch.bottomAnchor, constant: 20),
            endDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            enddate.topAnchor.constraint(equalTo: endDateLabel.bottomAnchor, constant: 8),
            enddate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            enddate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            notesButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                    notesButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

                    // Notes text field constraints
                    notesTextField.topAnchor.constraint(equalTo: notesButton.bottomAnchor, constant: 10),
                    notesTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                    notesTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                    notesTextField.heightAnchor.constraint(equalToConstant: 40),
            
            saveButton.topAnchor.constraint(equalTo: enddate.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardSize.cgRectValue
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc func notesButtonTapped() {
        notesTextField.isHidden = !notesTextField.isHidden
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func discontinueSwitchChanged(_ sender: UISwitch) {
        endDateLabel.isHidden = !sender.isOn
        enddate.isHidden = !sender.isOn
    }
    //added childname
    @objc func saveButtonTapped() {
        if isEditMode {
            let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "userName == %@ AND childName == %@ AND medName == %@", user,childName, medicationName)
            do {
                let medications = try managedObjectContext.fetch(fetchRequest)
                if let existingMedication = medications.first {
                    existingMedication.userName = user
                    existingMedication.childName = childName
                    existingMedication.medName = medicationname.text
                    existingMedication.notes = ""
                    existingMedication.medunits = dosageUnits[medicationunits.selectedRow(inComponent: 0)]
                    existingMedication.amount = "\(dosageNumberPicker.selectedRow(inComponent: 0) + 1)"
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
            newMedication.userName = user
            newMedication.childName = childName
            newMedication.medName = medicationname.text
            newMedication.notes = ""
            newMedication.medunits = dosageUnits[medicationunits.selectedRow(inComponent: 0)]
            newMedication.amount = "\(dosageNumberPicker.selectedRow(inComponent: 0) + 1)"
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
            print("Medication saved successfully!")
            delegate?.didSaveNewMedication()
            self.navigationController?.popViewController(animated: true)
        } catch {
            print("Error saving medication: \(error)")
        }
    }
    // added childname
    func populateDataForEditing() {
        let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userName == %@ AND childName == %@ AND medName == %@", user,childName ,medicationName)
        do {
            let medications = try managedObjectContext.fetch(fetchRequest)
            if let existingMedication = medications.first {
                medicationname.text = existingMedication.medName
                medicationunits.selectRow(dosageUnits.firstIndex(of: existingMedication.medunits ?? "") ?? 0, inComponent: 0, animated: false)
                dosageNumberPicker.selectRow(Int(existingMedication.amount ?? "1")! - 1, inComponent: 0, animated: false)
                frequency.text = existingMedication.frequency
                startdate.date = existingMedication.startdate ?? Date()
                
                if let enddate = existingMedication.enddate {
                    enableEndDateSwitch.isOn = true
                    endDateLabel.isHidden = false
                    self.enddate.isHidden = false
                    self.enddate.date = enddate
                } else {
                    enableEndDateSwitch.isOn = false
                    endDateLabel.isHidden = true
                    self.enddate.isHidden = true
                }
            }
        } catch {
            print("Error fetching medication for editing: \(error)")
        }
    }
    
    // MARK: - UIPickerView DataSource & Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == dosageNumberPicker {
            return 1000
        } else if pickerView == medicationunits {
            return dosageUnits.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == dosageNumberPicker {
            return "\(row + 1)"
        } else if pickerView == medicationunits {
            return dosageUnits[row]
        }
        return nil
    }
}
