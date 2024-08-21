import Foundation
import UIKit
import CoreData

class AddAllergenViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, AddAllergenDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var currentAllergenTableView: UITableView!
    @IBOutlet weak var discontinuedAllergenTableView: UITableView!

    // MARK: - Properties
    var user = ""
    let currentCellIdentifier = "AllergenCell"
    let discontinuedCellIdentifier = "AllergenCell"
    
    // Fetched Results Controllers
    var allFetchedResultsController: NSFetchedResultsController<Allergies>!
    
    // Allergens Data Arrays
    var currentIgEAllergens: [Allergies] = []
    var currentNonIgEAllergens: [Allergies] = []
    var clearedIgEAllergens: [Allergies] = []
    var clearedNonIgEAllergens: [Allergies] = []
    
    // Core Data Context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the fetched results controllers
        setupFetchedResultsControllers()
        
        // Configure table views and set delegates
        currentAllergenTableView.delegate = self
        currentAllergenTableView.dataSource = self
        discontinuedAllergenTableView.delegate = self
        discontinuedAllergenTableView.dataSource = self
        
        // Setup to dismiss keyboard
        setupKeyboardDismissRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Refresh data when the view appears
        setupFetchedResultsControllers()
        currentAllergenTableView.reloadData()
        discontinuedAllergenTableView.reloadData()
    }
    
    // MARK: - Data Fetching and Filtering
    func setupFetchedResultsControllers() {
        let fetchRequest: NSFetchRequest<Allergies> = Allergies.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        // Filter for allergens for a specific user
        let userPredicate = NSPredicate(format: "username == %@", user)
        fetchRequest.predicate = userPredicate
        
        allFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                 managedObjectContext: managedObjectContext,
                                                                 sectionNameKeyPath: nil,
                                                                 cacheName: nil)
        
        do {
            try allFetchedResultsController.performFetch()
            
            // Split fetched allergens into groups
            let allAllergens = allFetchedResultsController.fetchedObjects ?? []
            currentIgEAllergens = allAllergens.filter { $0.enddate == nil && $0.isIgE }
            currentNonIgEAllergens = allAllergens.filter { $0.enddate == nil && !$0.isIgE }
            clearedIgEAllergens = allAllergens.filter { $0.enddate != nil && $0.isIgE }
            clearedNonIgEAllergens = allAllergens.filter { $0.enddate != nil && !$0.isIgE }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    // MARK: - Table View Data Source and Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == currentAllergenTableView {
            return currentIgEAllergens.count + currentNonIgEAllergens.count
        } else if tableView == discontinuedAllergenTableView {
            return clearedIgEAllergens.count + clearedNonIgEAllergens.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllergenCell", for: indexPath) as! AllergenCell
        
        // Initialize the allergen variable to avoid usage before initialization errors
        var allergen: Allergies
        
        if tableView == currentAllergenTableView {
            if indexPath.row < currentIgEAllergens.count {
                allergen = currentIgEAllergens[indexPath.row]
            } else {
                allergen = currentNonIgEAllergens[indexPath.row - currentIgEAllergens.count]
            }
        } else if tableView == discontinuedAllergenTableView {
            if indexPath.row < clearedIgEAllergens.count {
                allergen = clearedIgEAllergens[indexPath.row]
            } else {
                allergen = clearedNonIgEAllergens[indexPath.row - clearedIgEAllergens.count]
            }
        } else {
            // Fallback to avoid compiler errors, although this branch should never be reached
            fatalError("Unexpected table view")
        }
        
        // Configure the custom cell
        cell.allergenNameLabel.text = allergen.name
        cell.allergyTypeLabel.text = allergen.isIgE ? "IgE" : "Non-IgE"
        cell.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        return cell
    }

    
    // MARK: - Button Actions
    @objc func editButtonTapped(sender: UIButton) {
        var selectedAllergen: String?
        
        if let cell = sender.superview?.superview as? AllergenCell,
           let indexPath = currentAllergenTableView.indexPath(for: cell) {
            selectedAllergen = currentIgEAllergens[indexPath.row].name
        } else if let cell = sender.superview?.superview as? AllergenCell,
                  let indexPath = discontinuedAllergenTableView.indexPath(for: cell) {
            selectedAllergen = clearedIgEAllergens[indexPath.row].name
        }
        
        performSegue(withIdentifier: "addAllergenSegue", sender: (true, selectedAllergen))
    }

    // MARK: - Add Allergen Button Action
    @IBAction func addAllergenTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addAllergenSegue", sender: nil)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addAllergenSegue",
           let displayVC = segue.destination as? AllergenViewController {
            displayVC.user = user
            
            if let (isEdit, allergenName) = sender as? (Bool, String) {
                displayVC.isEditMode = isEdit
                displayVC.allergenName = allergenName
            } else {
                displayVC.isEditMode = false
                displayVC.allergenName = ""
            }
            
            displayVC.delegate = self
        }
    }
    
    // MARK: - AddAllergenDelegate Implementation
    func didSaveNewAllergen() {
        // Refresh the data and reload both table views
        setupFetchedResultsControllers()
        currentAllergenTableView.reloadData()
        discontinuedAllergenTableView.reloadData()
    }
    
    // MARK: - Keyboard Dismissal
    func setupKeyboardDismissRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapRecognizer)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
