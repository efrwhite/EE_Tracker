//accidentalexposure
//created by vivek
//database edited by brianna

import UIKit
import CoreData

class AccidentalExposureViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    // CoreData context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var user = "" // User variable
    var childName = "" // Child variable
    
    // Assuming a child object is passed to this view controller
    var child: NSManagedObject?
    
    // Form UI elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Accidental Exposure"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    let itemExposedLabel: UILabel = {
        let label = UILabel()
        label.text = "Item Exposed To:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let itemExposedTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Item"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Description"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Exposure", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addExposure), for: .touchUpInside)
        return button
    }()
    
    // History UI elements
    let historyLabel: UILabel = {
        let label = UILabel()
        label.text = "Accidental Exposure History"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let historyTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var exposureHistory: [NSManagedObject] = []
    var expandedIndexSet = Set<IndexPath>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Accidental Exposure User: ", user)
        print("Accidental Exposure Child: ", childName)

        view.backgroundColor = .white
        
        // Add subviews
        setupSubviews()

        // Additional setup for the table view
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.register(ExposureTableViewCell.self, forCellReuseIdentifier: "ExposureTableViewCell")
        
        // Load exposure history from CoreData
        loadExposureHistory()
        
        // Dismiss keyboard on tap outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load data and reload the tableView when view reappears
        loadExposureHistory()
        historyTableView.reloadData()
    }
    
    // Setup all the subviews and their constraints
    func setupSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        view.addSubview(datePicker)
        view.addSubview(itemExposedLabel)
        view.addSubview(itemExposedTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTextField)
        view.addSubview(addButton)
        view.addSubview(historyLabel)
        view.addSubview(historyTableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            datePicker.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            itemExposedLabel.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            itemExposedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            itemExposedTextField.topAnchor.constraint(equalTo: itemExposedLabel.bottomAnchor, constant: 8),
            itemExposedTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            itemExposedTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: itemExposedTextField.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            addButton.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            historyLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20),
            historyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            historyTableView.topAnchor.constraint(equalTo: historyLabel.bottomAnchor, constant: 8),
            historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            historyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
    }
    
    @objc func addExposure() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let date = dateFormatter.string(from: datePicker.date)
        
        guard let item = itemExposedTextField.text, !item.isEmpty,
              let description = descriptionTextField.text, !description.isEmpty else {
            // Show alert for missing fields
            let alert = UIAlertController(title: "Missing Information", message: "Please fill out all fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        // Create a new AccidentalExposure entity
        let entity = NSEntityDescription.entity(forEntityName: "AccidentalExposure", in: context)!
        let newExposure = NSManagedObject(entity: entity, insertInto: context)
        newExposure.setValue(datePicker.date, forKey: "date")
        newExposure.setValue(item, forKey: "item")
        newExposure.setValue(description, forKey: "desc")
        newExposure.setValue(childName, forKey: "childname")
        newExposure.setValue(user, forKey: "username")
        
        // Save to CoreData
        do {
            try context.save()
            exposureHistory.append(newExposure)
            loadExposureHistory()
            historyTableView.reloadData()
            print("Exposure saved: \(date) - \(item) - \(description)")
        } catch {
            print("Failed to save exposure: \(error)")
        }
        
        // Clear text fields
        itemExposedTextField.text = ""
        descriptionTextField.text = ""
    }
    
    // Load exposure history from CoreData
    func loadExposureHistory() {
        let request = NSFetchRequest<NSManagedObject>(entityName: "AccidentalExposure")
        request.predicate = NSPredicate(format: "username == %@ && childname == %@", user, childName)
        
        do {
            exposureHistory = try context.fetch(request)
            print("Loaded \(exposureHistory.count) exposures")
            historyTableView.reloadData()
        } catch {
            print("Failed to load exposures: \(error)")
        }
    }
    
    // Dismiss keyboard on tap outside
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exposureHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExposureTableViewCell", for: indexPath) as! ExposureTableViewCell
        let exposure = exposureHistory[indexPath.row]
        
        // Configure the cell
        let date = exposure.value(forKey: "date") as? Date ?? Date()
        let item = exposure.value(forKey: "item") as? String ?? ""
        let desc = exposure.value(forKey: "desc") as? String ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        cell.dateLabel.text = dateFormatter.string(from: date)
        cell.itemLabel.text = item
        cell.descriptionLabel.text = desc
        cell.descriptionLabel.numberOfLines = expandedIndexSet.contains(indexPath) ? 0 : 1
        
        return cell
    }
    
    // Expand/collapse cell description on tap
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if expandedIndexSet.contains(indexPath) {
            expandedIndexSet.remove(indexPath)
        } else {
            expandedIndexSet.insert(indexPath)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}


