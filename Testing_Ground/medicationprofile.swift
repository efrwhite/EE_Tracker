import Foundation
import UIKit
import CoreData

class MedicationProfile: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, AddMedicationDelegate {
    var user = ""
    
    @IBOutlet weak var currentTableView: UITableView!
    let currentCellIdentifier = "currentcell1"
    
    @IBOutlet weak var discontinuedTableView: UITableView!
    let discontinuedCellIdentifier = "discontinuedcell"
    
    // Create fetchedResultsController for all medications
    var allFetchedResultsController: NSFetchedResultsController<Medication>!
    
    // Create arrays to hold current and discontinued medications
    var currentMedications: [Medication] = []
    var discontinuedMedications: [Medication] = []
    
    // Create a reference to the Core Data managed object context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the fetched results controllers
        setupFetchedResultsControllers()
        
        // Configure table views and set delegates
        currentTableView.delegate = self
        currentTableView.dataSource = self
        currentTableView.register(UITableViewCell.self, forCellReuseIdentifier: currentCellIdentifier)
        
        discontinuedTableView.delegate = self
        discontinuedTableView.dataSource = self
        discontinuedTableView.register(UITableViewCell.self, forCellReuseIdentifier: discontinuedCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Refresh data when the view appears
        setupFetchedResultsControllers()
        currentTableView.reloadData()
        discontinuedTableView.reloadData()
    }
    
    func setupFetchedResultsControllers() {
        let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "medName", ascending: true)]
        
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
            currentMedications = allFetchedResultsController.fetchedObjects?.filter { $0.enddate == nil } ?? []
            discontinuedMedications = allFetchedResultsController.fetchedObjects?.filter { $0.enddate != nil } ?? []
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    func didSaveNewMedication() {
        // Refresh data when a new medication is saved
        setupFetchedResultsControllers()
        currentTableView.reloadData()
        discontinuedTableView.reloadData()
    }
    
    // MARK: - Table View Data Source and Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == currentTableView {
            return currentMedications.count
        } else if tableView == discontinuedTableView {
            return discontinuedMedications.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if tableView == currentTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: currentCellIdentifier, for: indexPath)
            cell.textLabel?.text = currentMedications[indexPath.row].medName
        } else if tableView == discontinuedTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: discontinuedCellIdentifier, for: indexPath)
            cell.textLabel?.text = discontinuedMedications[indexPath.row].medName
        } else {
            cell = UITableViewCell()
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addmedsegue", let displayVC = segue.destination as? AddMedicationViewController {
            displayVC.user = user
            displayVC.delegate = self
        }
    }
}
