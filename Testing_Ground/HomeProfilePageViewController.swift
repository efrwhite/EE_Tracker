import UIKit
import CoreData

class HomeProfilePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var user = ""
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
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            // Reload data for both table views
            childProfiles = fetchChildProfiles(username: user)
            parentProfiles = fetchParentProfiles(username: user)

            tableView.reloadData()
            tableView2.reloadData()
        }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return childProfiles.count
        } else if tableView == self.tableView2 {
            return parentProfiles.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableviewOne, for: indexPath) as! ProfilesTableviewcell
            let childProfile = childProfiles[indexPath.row]
            // Set the child name in the cell
            cell.namelabel.text = childProfile.firstName // Update the label using your IBOutlet
            
            // Add the button actions for the first table view
            cell.addbutton.tag = indexPath.row
            cell.addbutton.addTarget(self, action: #selector(addButtonPressed(_:)), for: .touchUpInside)
            
            cell.editbutton.tag = indexPath.row
            cell.editbutton.addTarget(self, action: #selector(editButtonPressed(_:)), for: .touchUpInside)
            
            return cell
        } else if tableView == self.tableView2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableviewTwo, for: indexPath) as! ParentTableViewCell
            let parentProfile = parentProfiles[indexPath.row]
            // Set the parent name in the cell
            cell.parentname.text = parentProfile.firstname // Update the label using your IBOutlet
            
            // Add the button actions for the second table view
            cell.addbutton.tag = indexPath.row
            cell.addbutton.addTarget(self, action: #selector(addParentButtonPressed(_:)), for: .touchUpInside)
            
            cell.editbutton.tag = indexPath.row
            cell.editbutton.addTarget(self, action: #selector(editParentButtonPressed(_:)), for: .touchUpInside)
            
            return cell
        }
        
        // This should not happen, return an empty cell if it does
        return UITableViewCell()
    }


    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        let label = UILabel(frame: CGRect(x: 15, y: 10, width: tableView.frame.size.width - 30, height: 20))

        if tableView == self.tableView {
            label.text = "Child"
        } else if tableView == self.tableView2 {
            label.text = "Parent"
        }

        headerView.backgroundColor = UIColor.white
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18) // Increase font size
        headerView.addSubview(label)

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    // Your fetchChildProfiles and fetchParentProfiles functions here...
    func fetchChildProfiles(username: String) -> [Child] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Child> = Child.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching child profiles: \(error)")
            return []
        }
    }
    
    @objc func addButtonPressed(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let childProfile = childProfiles[indexPath.row]
        
        let childViewController = storyboard?.instantiateViewController(withIdentifier: "ChildViewController") as! ChildViewController
        childViewController.isAddingChild = true
        childViewController.childName = childProfile.firstName
        childViewController.user = user // Set the user property here
        
        navigationController?.pushViewController(childViewController, animated: true)
    }

    @objc func editButtonPressed(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let childProfile = childProfiles[indexPath.row]
        
        let childViewController = storyboard?.instantiateViewController(withIdentifier: "ChildViewController") as! ChildViewController
        childViewController.isEditingChild = true
        childViewController.childName = childProfile.firstName
        childViewController.user = user // Set the user property here
        
        navigationController?.pushViewController(childViewController, animated: true)
    }


   


    @objc func addParentButtonPressed(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let parentProfile = parentProfiles[indexPath.row]
        
        let parentViewController = storyboard?.instantiateViewController(withIdentifier: "ParentViewController") as! ParentViewController
        parentViewController.isAddingParent = true
        parentViewController.parentName = parentProfile.firstname
        parentViewController.usernamep = user
        
        navigationController?.pushViewController(parentViewController, animated: true)
    }

    @objc func editParentButtonPressed(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let parentProfile = parentProfiles[indexPath.row]
        
        let parentViewController = storyboard?.instantiateViewController(withIdentifier: "ParentViewController") as! ParentViewController
        parentViewController.isEditingParent = true
        parentViewController.parentName = parentProfile.firstname
        parentViewController.usernamep = user
        
        navigationController?.pushViewController(parentViewController, animated: true)
    }

    func fetchParentProfiles(username: String) -> [Parent] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Parent> = Parent.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)
        
        do {
            var parentProfiles = try context.fetch(fetchRequest)
            
            // Filter and remove empty or invalid profiles
            parentProfiles = parentProfiles.filter { !$0.firstname!.isEmpty } // Adjust the condition as needed
            
            return parentProfiles
        } catch {
            print("Error fetching parent profiles: \(error)")
            return []
        }
    }

}
