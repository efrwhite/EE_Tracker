
import UIKit
import CoreData

class Diet6GoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    var user = ""
    var childName = ""

    let categories = ["Endoscopy", "Allergies", "Medication", "Accidental Exposure", "Symptom Score", "Quality of Life"]
    var selectedCategory: String?

    var tableViewData: [(date: String, descriptor: String)] = []

    let categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In Journal, ",user, childName)
        view.backgroundColor = .white
        setupPicker()
        setupTableView()
    }
    
    func setupPicker() {
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        view.addSubview(categoryPicker)
        
        NSLayoutConstraint.activate([
            categoryPicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            categoryPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryPicker.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    // MARK: - UIPickerView DataSource & Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categories[row]
        fetchData(for: selectedCategory!)
    }
 
    func fetchData(for category: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        var fetchRequest: NSFetchRequest<NSManagedObject>?

        switch category {
        case "Endoscopy":
            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Endoscopy")
        case "Allergies":
            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Allergies")
        case "Medication":
            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Medication")
        case "Accidental Exposure":
            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AccidentalExposure")
        case "Symptom Score":
            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Symptom")
        case "Quality of Life":
            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Quality")
        default:
            return
        }
       
        // Apply correct predicates based on entity type
        var userPredicate: NSPredicate?
        //let userPredicate = NSPredicate(format: "username == %@", user)
        var childPredicate: NSPredicate?
        switch category {
        case "Quality of Life", "Symptom Score":
            userPredicate = NSPredicate(format: "user == %@", user)
        case "Endoscopy", "Medication", "Allergies", "Accidental Exposure":
            userPredicate = NSPredicate(format: "username == %@", user)
        default:
            break
        }
        switch category {
        case "Endoscopy", "Medication":
            childPredicate = NSPredicate(format: "childName == %@", childName)
        case "Allergies", "Accidental Exposure":
            childPredicate = NSPredicate(format: "childname == %@", childName) // Lowercase "childname"
        
        default:
            break
        }

//        if let childPredicate = childPredicate {
//            fetchRequest?.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, childPredicate])
//        } else {
//            fetchRequest?.predicate = userPredicate
//        }
        if let userPredicate = userPredicate {
            if let childPredicate = childPredicate {
                fetchRequest?.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, childPredicate])
            } else {
                fetchRequest?.predicate = userPredicate
            }
        } else if let childPredicate = childPredicate {
            fetchRequest?.predicate = childPredicate
        } else {
            fetchRequest?.predicate = nil // or handle fallback
        }


        do {
            let results = try context.fetch(fetchRequest!)
            let formatter = DateFormatter()
            formatter.dateStyle = .short

            tableViewData = results.map {
                var dateString = "N/A"
                var descriptor = "N/A"

                switch category {
                case "Endoscopy":
                    if let procedureDate = $0.value(forKey: "procedureDate") as? Date {
                        dateString = formatter.string(from: procedureDate)
                    }

                    let duodenum = $0.value(forKey: "duodenum") as? String ?? ""
                    let stomach = $0.value(forKey: "stomach") as? String ?? ""
                    let leftColon = $0.value(forKey: "leftColon") as? String ?? ""
                    let middleColon = $0.value(forKey: "middleColon") as? String ?? ""
                    let rightColon = $0.value(forKey: "rightColon") as? String ?? ""

                    if !leftColon.isEmpty || !middleColon.isEmpty || !rightColon.isEmpty {
                        descriptor = "Endoscopy Colon"
                    } else if !duodenum.isEmpty {
                        descriptor = "Endoscopy Duodenum"
                    } else if !stomach.isEmpty {
                        descriptor = "Endoscopy Stomach"
                    } else {
                        descriptor = "Endoscopy EoE"
                    }

                case "Allergies":
                    let startDate = $0.value(forKey: "startdate") as? Date
                    let endDate = $0.value(forKey: "enddate") as? Date
                    let start = startDate != nil ? formatter.string(from: startDate!) : "N/A"
                    let end = endDate != nil ? formatter.string(from: endDate!) : "N/A"
                    dateString = "Start: \(start), End: \(end)"
                    descriptor = $0.value(forKey: "name") as? String ?? "Unknown Allergen"

                case "Medication":
                    let startDate = $0.value(forKey: "startdate") as? Date
                    let endDate = $0.value(forKey: "enddate") as? Date
                    let start = startDate != nil ? formatter.string(from: startDate!) : "N/A"
                    let end = endDate != nil ? formatter.string(from: endDate!) : "N/A"
                    dateString = "Start: \(start), End: \(end)"
                    descriptor = $0.value(forKey: "medName") as? String ?? "Unknown Medication"

                case "Accidental Exposure":
                    if let exposureDate = $0.value(forKey: "date") as? Date {
                        dateString = formatter.string(from: exposureDate)
                    }
                    descriptor = $0.value(forKey: "item") as? String ?? "Unknown Substance"
                case "Symptom Score":
                    let startDate = $0.value(forKey: "date") as? Date
                    dateString = "Date: \(String(describing: startDate))"
                    let sum = $0.value(forKey: "symptomSum") as? Int
                    descriptor = "Symptom Score: \(String(describing: sum))"
                case "Quality of Life":
                    let startDate = $0.value(forKey: "date") as? Date
                    dateString = "Date: \(String(describing: startDate))"
                    let sum = $0.value(forKey: "qualitySum") as? Int
                    descriptor = "Quality Score: \(String(describing: sum))"
                default:
                    break
                }

                return (dateString, descriptor)
            }
            tableView.reloadData()
        } catch {
            print("Error fetching \(category) data: \(error)")
        }
    }

    // MARK: - UITableView DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        let entry = tableViewData[indexPath.row]

        cell.textLabel?.text = "Date: \(entry.date) | Info: \(entry.descriptor)"
        cell.textLabel?.numberOfLines = 0

        return cell
    }
}
