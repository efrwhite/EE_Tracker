import UIKit
import CoreData

// Add an extension to Array for safe subscripting
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class HomeProfilePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var user = ""
    var selectedChild: Child?
    var selected = ""

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    var childProfiles: [Child] = []
    var parentProfiles: [Parent] = []

    let TableviewOne = "ProfilesTableviewcell" // Use the correct identifier
    let TableviewTwo = "ParentTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        // Register the custom cell from the XIB for the first table view
        let nib1 = UINib(nibName: "ProfilesTableviewcell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: TableviewOne)

        tableView2.dataSource = self
        tableView2.delegate = self

        // Register the custom cell from the XIB for the second table view
        let nib2 = UINib(nibName: "ParentTableViewCell", bundle: nil)
        tableView2.register(nib2, forCellReuseIdentifier: TableviewTwo)

        // Call your fetch functions here to load the data
        childProfiles = fetchChildProfiles(username: user)
        parentProfiles = fetchParentProfiles(username: user)

        // Debugging print statements
        print("Child Profiles Count: \(childProfiles.count)")
        print("Parent Profiles Count: \(parentProfiles.count)")

        // Reload table views to populate data
        tableView.reloadData()
        tableView2.reloadData()
        if !user.isEmpty {
            print("Profile User: \(user)")
        } else {
            print("user is nil")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Reload data for both table views
        childProfiles = fetchChildProfiles(username: user)
        parentProfiles = fetchParentProfiles(username: user)

        tableView.reloadData()
        tableView2.reloadData()
    }
   


//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == self.tableView {
//            return childProfiles.count
//        } else if tableView == self.tableView2 {
//            return parentProfiles.count
//        }
//        return 0
//    }
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView == self.tableView {
//            selectedChild = childProfiles[indexPath.row]
//            
//            // Print the selected child's name to the debug console
//            if let child = selectedChild, let childName = child.firstName {
//                print("Selected Child: \(childName)")
//            }
//            
//            // Reload the table view to apply the new selection style
//            tableView.reloadData()
//            
//            // Show a popup message with the selected child's name
//            if let child = selectedChild, let childName = child.firstName {
//                let alertController = UIAlertController(
//                    title: "Main Patient Selection",
//                    message: "\(childName) is chosen as the Active Patient.",
//                    preferredStyle: .alert
//                )
//                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                present(alertController, animated: true, completion: nil)
//            }
//        }
//    }

  

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView == self.tableView {
//            selectedChild = childProfiles[indexPath.row]
//            
//            // Print the selected child's name to the debug console
//            if let child = selectedChild, let childName = child.firstName {
//                print("Selected Child: \(childName)")
//                //this is where we fire off the childname segue
//            }
//            
//            // Reload the table view to apply the new selection style
//            tableView.reloadData()
//            
//            // Show a popup message with the selected child's name
//            if let child = selectedChild, let childName = child.firstName {
//                let alertController = UIAlertController(title: "Main Patient Selection", message: "\(childName) is chosen as the Active Patient.", preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                present(alertController, animated: true, completion: nil)
//            }
//        }
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if tableView == self.tableView {
//            let cell = tableView.dequeueReusableCell(withIdentifier: TableviewOne, for: indexPath) as! ProfilesTableviewcell
//            let childProfile = childProfiles[indexPath.row]
//            
//            cell.namelabel.text = childProfile.firstName // Update the label using your IBOutlet
//            
//            // Check if the current child profile is the selected one
//            if childProfile == selectedChild {
//                // Highlight the cell if it's the selected child
//                cell.backgroundColor = .lightGray
//            } else {
//                // Reset the cell's appearance for unselected children
//                cell.backgroundColor = .white
//            }
//            
//            cell.editbutton.tag = indexPath.row
//            cell.editbutton.addTarget(self, action: #selector(editButtonPressed(_:)), for: .touchUpInside)
//            
//            return cell
//        } else if tableView == self.tableView2 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: TableviewTwo, for: indexPath) as! ParentTableViewCell
//            let parentProfile = parentProfiles[indexPath.row]
//            
//            cell.parentname.text = parentProfile.firstname // Update the label using your IBOutlet
//            
//            cell.editbutton.tag = indexPath.row
//            cell.editbutton.addTarget(self, action: #selector(editParentButtonPressed(_:)), for: .touchUpInside)
//            
//            return cell
//        }
//        
//        // This should not happen, return an empty cell if it does
//        return UITableViewCell()
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40  // Adjust the height to add space above the header
//    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
//
//        let label = UILabel(frame: CGRect(x: 15, y: 10, width: tableView.frame.size.width - 30, height: 20))
//
//        if tableView == self.tableView {
//            label.text = "Patient"
//        } else if tableView == self.tableView2 {
//            label.text = "Caregiver"
//        }
//
//        headerView.backgroundColor = UIColor.white
//        label.textColor = UIColor.black
//        label.font = UIFont.boldSystemFont(ofSize: 18)
//        headerView.addSubview(label)
//
//        let addButton = UIButton(type: .system)
//        addButton.setTitle("Add", for: .normal)
//        addButton.frame = CGRect(x: tableView.frame.size.width - 75, y: 10, width: 40, height: 20)
//        addButton.addTarget(self, action: #selector(addButtonPressed(_:)), for: .touchUpInside)
//        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18) // Change font and size
//        headerView.addSubview(addButton)
//
//        return headerView
//    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableView {
            return 2 // [0: "Please select", 1: Patient List]
        } else if tableView == self.tableView2 {
            return 1 // [0: Caregiver List]
        }
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            selectedChild = childProfiles[indexPath.row]
            
            // Print the selected child's name to the debug console
            if let child = selectedChild, let childName = child.firstName {
                print("Selected Child: \(childName)")
                // This is where we fire off the child name segue
            }
            
            // Reload the table view to apply the new selection style
            tableView.reloadData()
            
            // Show a popup message with the selected child's name
            if let child = selectedChild, let childName = child.firstName {
                let alertController = UIAlertController(title: "Main Patient Selection",
                                                        message: "\(childName) is chosen as the Active Patient.",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
        }
    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if tableView == self.tableView {
//            let cell = tableView.dequeueReusableCell(withIdentifier: TableviewOne, for: indexPath) as! ProfilesTableviewcell
//            let childProfile = childProfiles[indexPath.row]
//            
//            cell.namelabel.text = childProfile.firstName // Update the label using IBOutlet
//            
//            // Check if the current child profile is the selected one
//            if childProfile == selectedChild {
//                cell.backgroundColor = .lightGray // Highlight selection
//            } else {
//                cell.backgroundColor = .white // Default color
//            }
//            
//            cell.editbutton.tag = indexPath.row
//            cell.editbutton.addTarget(self, action: #selector(editButtonPressed(_:)), for: .touchUpInside)
//            
//            return cell
//        } else if tableView == self.tableView2 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: TableviewTwo, for: indexPath) as! ParentTableViewCell
//            let parentProfile = parentProfiles[indexPath.row]
//            
//            cell.parentname.text = parentProfile.firstname // Update the label
//            
//            cell.editbutton.tag = indexPath.row
//            cell.editbutton.addTarget(self, action: #selector(editParentButtonPressed(_:)), for: .touchUpInside)
//            
//            
//            return cell
//        }
//        
//        // This should not happen, return an empty cell if it does
//        return UITableViewCell()
//    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50  // Adjust the height to add space above the header
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = .white

        let label = UILabel(frame: CGRect(x: 15, y: 10, width: 200, height: 20))
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        headerView.addSubview(label)

        let addButton = UIButton(type: .system)
        addButton.setTitle("Add", for: .normal)
        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        addButton.frame = CGRect(x: tableView.frame.width - 60, y: 5, width: 50, height: 30)

        if tableView == self.tableView {
            if section == 0 {
                label.text = "Please select a patient"
            } else if section == 1 {
                label.text = "Patient"
                addButton.addTarget(self, action: #selector(addChildButtonPressed), for: .touchUpInside)
                headerView.addSubview(addButton)
            }
        }

        if tableView == self.tableView2 {
            if section == 0 {
                label.text = "Caregiver"
                addButton.addTarget(self, action: #selector(addParentButtonPressed), for: .touchUpInside)
                headerView.addSubview(addButton)
            }
        }

        return headerView
    }


  
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.section {
//        case 1: // children
//            let cell = tableView.dequeueReusableCell(withIdentifier: TableviewOne, for: indexPath) as! ProfilesTableviewcell
//            let child = childProfiles[indexPath.row]
//            cell.namelabel.text = child.firstName
//            cell.editbutton.tag = indexPath.row
//            cell.editbutton.addTarget(self, action: #selector(editButtonPressed(_:)), for: .touchUpInside)
//            return cell
//        case 2: // parents
//            let cell = tableView.dequeueReusableCell(withIdentifier: TableviewTwo, for: indexPath) as! ParentTableViewCell
//            let parent = parentProfiles[indexPath.row]
//            cell.parentname.text = parent.firstname
//            cell.editbutton.tag = indexPath.row
//            cell.editbutton.addTarget(self, action: #selector(editParentButtonPressed(_:)), for: .touchUpInside)
//            return cell
//        default:
//            return UITableViewCell()
//        }
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            // For child/patient tableView
            if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TableviewOne, for: indexPath) as! ProfilesTableviewcell
                let childProfile = childProfiles[indexPath.row]
                cell.namelabel.text = childProfile.firstName
                cell.editbutton.tag = indexPath.row
                cell.editbutton.addTarget(self, action: #selector(editButtonPressed(_:)), for: .touchUpInside)
                return cell
            }
        } else if tableView == self.tableView2 {
            // For caregiver tableView2
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TableviewTwo, for: indexPath) as! ParentTableViewCell
                let parentProfile = parentProfiles[indexPath.row]
                cell.parentname.text = parentProfile.firstname // ✅ Make sure this IBOutlet exists in your XIB
                cell.editbutton.tag = indexPath.row
                cell.editbutton.addTarget(self, action: #selector(editParentButtonPressed(_:)), for: .touchUpInside)
                return cell
            }
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return section == 1 ? childProfiles.count : 0
        } else if tableView == self.tableView2 {
            return section == 0 ? parentProfiles.count : 0
        }
        return 0
    }


    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
//        headerView.backgroundColor = UIColor.white
//
//        let label = UILabel(frame: CGRect(x: 15, y: 10, width: tableView.frame.size.width - 30, height: 20))
//        label.textColor = UIColor.black
//        label.font = UIFont.boldSystemFont(ofSize: 18)
//
//        // First Section: "Please select a patient"
//        if section == 0 {
//            label.text = "Please select a patient"
//            headerView.addSubview(label)
//            return headerView
//        }
//
//        // Second Section: "Patients" + Add Button + edit button
//        if section == 1 && tableView == self.tableView {
//            label.text = "Patients"
//            headerView.addSubview(label)
//
//            let addButton = UIButton(type: .system)
//            addButton.setTitle("Add", for: .normal)
//            addButton.frame = CGRect(x: tableView.frame.size.width - 75, y: 10, width: 40, height: 20)
//            addButton.addTarget(self, action: #selector(addChildButtonPressed), for: .touchUpInside)
//            addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
//            headerView.addSubview(addButton)
//            
//            return headerView
//        }
//
//        // Third Section: "Caregivers" + Add Button + edit button
//        if section == 1 && tableView == self.tableView2 {
//            label.text = "Caregivers"
//            headerView.addSubview(label)
//
//            let addButton = UIButton(type: .system)
//            addButton.setTitle("Add", for: .normal)
//            addButton.frame = CGRect(x: tableView.frame.size.width - 75, y: 10, width: 40, height: 20)
//            addButton.addTarget(self, action: #selector(addParentButtonPressed), for: .touchUpInside)
//            addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
//            headerView.addSubview(addButton)
//
//            return headerView
//        }
//
//        return headerView
//    }



    // MARK: - Add Button Actions
    @objc func addChildButtonPressed() {
        let childViewController = storyboard?.instantiateViewController(withIdentifier: "ChildViewController") as! ChildViewController
        childViewController.isAddingChild = true
        childViewController.user = user
        navigationController?.pushViewController(childViewController, animated: true)
    }

    @objc func addParentButtonPressed() {
        let parentViewController = storyboard?.instantiateViewController(withIdentifier: "ParentViewController") as! ParentViewController
        parentViewController.isAddingParent = true
        parentViewController.user = user
        navigationController?.pushViewController(parentViewController, animated: true)
    }

    // MARK: - End of new functionality
    @objc func addButtonPressed(_ sender: UIButton) {
        // Determine which table view's "Add" button was pressed
        if let tableView = sender.superview?.superview as? UITableView {
            if tableView == self.tableView {
                // Handle the "Add" button press for the child table view
                let childViewController = storyboard?.instantiateViewController(withIdentifier: "Patient Profile") as! ChildViewController
                childViewController.isAddingChild = true
                childViewController.user = user // Set the user property here
                navigationController?.pushViewController(childViewController, animated: true)
            } else if tableView == self.tableView2 {
                // Handle the "Add" button press for the parent table view
                let parentViewController = storyboard?.instantiateViewController(withIdentifier: "ParentViewController") as! ParentViewController
                parentViewController.isAddingParent = true
                parentViewController.user = user
                navigationController?.pushViewController(parentViewController, animated: true)
            }
        }
    }

    @objc func editButtonPressed(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        if let childProfile = childProfiles[safe: indexPath.row] {
            let childViewController = storyboard?.instantiateViewController(withIdentifier: "Patient Profile") as! ChildViewController
            childViewController.isEditingChild = true
            childViewController.childName = childProfile.firstName ?? "Default Child Name"
            childViewController.user = user
            navigationController?.pushViewController(childViewController, animated: true)
        }
    }

    @objc func editParentButtonPressed(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        if let parentProfile = parentProfiles[safe: indexPath.row] {
            let parentViewController = storyboard?.instantiateViewController(withIdentifier: "ParentViewController") as! ParentViewController
            parentViewController.isEditingParent = true
            parentViewController.parentName = parentProfile.firstname ?? "Default Parent Name"
            parentViewController.user = user
            navigationController?.pushViewController(parentViewController, animated: true)
        }
    }

    func fetchChildProfiles(username: String) -> [Child] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Child> = Child.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)

        do {
            let childProfiles = try context.fetch(fetchRequest)

            // Filter and remove empty or invalid profiles
            let validChildProfiles = childProfiles.filter { $0.firstName != nil && !$0.firstName!.isEmpty }

            return validChildProfiles
        } catch {
            print("Error fetching child profiles: \(error)")
            return []
        }
    }

    func fetchParentProfiles(username: String) -> [Parent] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Parent> = Parent.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)
        
        do {
            let parentProfiles = try context.fetch(fetchRequest)
            
            // Filter and remove empty or invalid profiles
            let validParentProfiles = parentProfiles.filter { $0.firstname != nil && !$0.firstname!.isEmpty }
            
            return validParentProfiles
        } catch {
            print("Error fetching parent profiles: \(error)")
            return []
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Call saveAndUnwind before the view disappears
        if isMovingFromParent || isBeingDismissed {
            saveAndUnwind(self)
        }
    }
//programmatically in use for  when we go back to homescreen
    @IBAction func saveAndUnwind(_ sender: Any) {
          if let navController = navigationController {
              // Iterate over view controllers in the navigation stack to find HomeViewController
              if let homeViewController = navController.viewControllers.first(where: { $0 is HomeViewController }) as? HomeViewController {
                  homeViewController.user = self.user
                  homeViewController.childselected = self.selectedChild?.firstName ?? selected
                  print("Returning to HomeViewController with user: \(self.user) and child: \(self.selectedChild?.firstName ?? selected)")
              }
              // Pop the current view controller
              //navController.popViewController(animated: true)
          }
      }
}

