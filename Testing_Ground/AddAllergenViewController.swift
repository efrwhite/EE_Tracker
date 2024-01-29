import Foundation
import UIKit
import CoreData

class AddAllergenViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, AddAllergenDelegate {
    func didSaveNewAllergen() {
        setupFetchedResultsControllers()
        currentAllergenTableView.reloadData()
        discontinuedAllergenTableView.reloadData()
    }
    
    var user = ""
    
    @IBOutlet weak var currentAllergenTableView: UITableView!
    let currentCellIdentifier = "currentcell"
    
    @IBOutlet weak var discontinuedAllergenTableView: UITableView!
    let discontinuedCellIdentifier = "discontinuedAllergenCell"
    
    // Create fetchedResultsController for all medications
    var allFetchedResultsController: NSFetchedResultsController<Allergies>!
    
    // Create arrays to hold current and discontinued medications
    var currentAllergens: [Allergies] = []
    var discontinuedAllergens: [Allergies] = []
    
    // Create a reference to the Core Data managed object context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the fetched results controllers
        setupFetchedResultsControllers()
        
        // Configure table views and set delegates
        currentAllergenTableView.delegate = self
        currentAllergenTableView.dataSource = self
        currentAllergenTableView.register(UITableViewCell.self, forCellReuseIdentifier: currentCellIdentifier)
        
        discontinuedAllergenTableView.delegate = self
        discontinuedAllergenTableView.dataSource = self
        discontinuedAllergenTableView.register(UITableViewCell.self, forCellReuseIdentifier: discontinuedCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Refresh data when the view appears
        setupFetchedResultsControllers()
        currentAllergenTableView.reloadData()
        discontinuedAllergenTableView.reloadData()
    }
    
    func setupFetchedResultsControllers() {
        let fetchRequest: NSFetchRequest<Allergies> = Allergies.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        // Filter for medications for a specific user
        let userPredicate = NSPredicate(format: "username == %@", user)
        fetchRequest.predicate = userPredicate
        
        allFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                               managedObjectContext: managedObjectContext,
                                                               sectionNameKeyPath: nil,
                                                               cacheName: nil)
        
        do {
            try allFetchedResultsController.performFetch()
            
            // Filter medications into current and discontinued based on enddate
            currentAllergens = allFetchedResultsController.fetchedObjects?.filter { $0.enddate == nil } ?? []
            discontinuedAllergens = allFetchedResultsController.fetchedObjects?.filter { $0.enddate != nil } ?? []
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    func didSaveNewMedication() {
        // Refresh data when a new medication is saved
        setupFetchedResultsControllers()
        currentAllergenTableView.reloadData()
        discontinuedAllergenTableView.reloadData()
    }
    
    // MARK: - Table View Data Source and Delegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.frame = CGRect(x: 15, y: 0, width: tableView.frame.size.width - 30, height: 30)
        
        if tableView == currentAllergenTableView {
            label.text = "Current Allergens"
        } else if tableView == discontinuedAllergenTableView {
            label.text = "Discontinued Allergens"
        }
        
        headerView.addSubview(label)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == currentAllergenTableView {
            return currentAllergens.count
        } else if tableView == discontinuedAllergenTableView {
            return discontinuedAllergens.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if tableView == currentAllergenTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: currentCellIdentifier, for: indexPath)
            cell.textLabel?.text = currentAllergens[indexPath.row].name
        } else if tableView == discontinuedAllergenTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: discontinuedCellIdentifier, for: indexPath)
            cell.textLabel?.text = discontinuedAllergens[indexPath.row].name
        } else {
            cell = UITableViewCell()
        }
        
        // Check if the edit button is already added, and if not, add it
        if cell.contentView.subviews.first(where: { $0 is UIButton }) == nil {
            // Calculate the X position based on the cell's width and button width
            let buttonWidth: CGFloat = 50
            let xPosition = cell.contentView.frame.size.width - buttonWidth - 10 // 10 is the right margin

            // Set up the frame for the edit button
            let editButton = UIButton(type: .system)
            editButton.setTitle("Edit", for: .normal)
            editButton.frame = CGRect(x: xPosition, y: 5, width: buttonWidth, height: 30)
            editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
            
            cell.contentView.addSubview(editButton)
        }
        
        return cell
    }


    @objc func editButtonTapped(sender: UIButton) {
        var selectedAllergen: String?
        
        if let cell = sender.superview?.superview as? UITableViewCell, let indexPath = currentAllergenTableView.indexPath(for: cell) {
            // Handle editing for the currentTableView
            selectedAllergen = currentAllergens[indexPath.row].name
            // Implement the editing logic for the selected medication
        } else if let cell = sender.superview?.superview as? UITableViewCell, let indexPath = discontinuedAllergenTableView.indexPath(for: cell) {
            // Handle editing for the discontinuedTableView
            selectedAllergen = discontinuedAllergens[indexPath.row].name
            // Implement the editing logic for the selected medication
        }
        
        // Perform the segue and pass the isEdit boolean and selected medication name
        performSegue(withIdentifier: "addAsegue", sender: (true, selectedAllergen))
    }





    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addAsegue", let displayVC = segue.destination as? AllergenViewController {
            displayVC.user = user
            
            if let (isEdit, allergenName) = sender as? (Bool, String) {
                displayVC.isEditMode = isEdit // Updated the property name
                displayVC.allergenName = allergenName
            } else {
                displayVC.isEditMode = false
                displayVC.allergenName = ""
            }
            
            displayVC.delegate = self
        }
    }




}
