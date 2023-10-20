import UIKit
import CoreData
protocol AddAllergenDelegate: class {
    func didSaveNewAllergen()
}

class AddAllergenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddAllergenDelegate {
    var user = "" // Set the user as needed
    

    @IBOutlet weak var currentAllergen: UITableView!
    let currentCellIdentifier = "currentcell"

    @IBOutlet weak var discontinuedAllergen: UITableView!
    let discontinuedCellIdentifier = "notcurrentcell"

    // Create fetchedResultsController for current and discontinued allergies
    var currentFetchedResultsController: NSFetchedResultsController<Allergies>!
    var discontinuedFetchedResultsController: NSFetchedResultsController<Allergies>!

    // Create a reference to the Core Data managed object context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ADD ALLERGY USER: ",user)
        // Set up the fetched results controllers
        setupFetchedResultsControllers()

        // Configure table views and set delegates
        currentAllergen.delegate = self
        currentAllergen.dataSource = self
        currentAllergen.register(UITableViewCell.self, forCellReuseIdentifier: currentCellIdentifier)

        discontinuedAllergen.delegate = self
        discontinuedAllergen.dataSource = self
        discontinuedAllergen.register(UITableViewCell.self, forCellReuseIdentifier: discontinuedCellIdentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Refresh data when the view appears
        setupFetchedResultsControllers()
        currentAllergen.reloadData()
        discontinuedAllergen.reloadData()
    }

    func setupFetchedResultsControllers() {
        let fetchRequest: NSFetchRequest<Allergies> = Allergies.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        // Filter for current allergies for a specific user
        let currentPredicate = NSPredicate(format: "enddate == nil AND username == %@", user)
        currentFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                    managedObjectContext: managedObjectContext,
                                                                    sectionNameKeyPath: nil,
                                                                    cacheName: nil)
        currentFetchedResultsController.fetchRequest.predicate = currentPredicate

        // Filter for discontinued allergies for a specific user
        let discontinuedPredicate = NSPredicate(format: "enddate != nil AND username == %@", user)
        discontinuedFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                        managedObjectContext: managedObjectContext,
                                                                        sectionNameKeyPath: nil,
                                                                        cacheName: nil)
        discontinuedFetchedResultsController.fetchRequest.predicate = discontinuedPredicate

        do {
            try currentFetchedResultsController.performFetch()
            try discontinuedFetchedResultsController.performFetch()
        } catch {
            print("Error fetching data: \(error)")
        }
    }

    func didSaveNewAllergen() {
        // Refresh data when a new allergen is saved
        setupFetchedResultsControllers()
        currentAllergen.reloadData()
        discontinuedAllergen.reloadData()
    }


    // MARK: - Table View Data Source and Delegate

    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == currentAllergen {
            return currentFetchedResultsController.sections?.count ?? 0
        } else if tableView == discontinuedAllergen {
            return discontinuedFetchedResultsController.sections?.count ?? 0
        }
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == currentAllergen {
            return currentFetchedResultsController.sections?[section].numberOfObjects ?? 0
        } else if tableView == discontinuedAllergen {
            return discontinuedFetchedResultsController.sections?[section].numberOfObjects ?? 0
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if tableView == currentAllergen {
            cell = tableView.dequeueReusableCell(withIdentifier: currentCellIdentifier, for: indexPath)
        } else if tableView == discontinuedAllergen {
            cell = tableView.dequeueReusableCell(withIdentifier: discontinuedCellIdentifier, for: indexPath)
        } else {
            cell = UITableViewCell()
        }

        let allergy: Allergies
        if tableView == currentAllergen {
            allergy = currentFetchedResultsController.object(at: indexPath)
        } else {
            allergy = discontinuedFetchedResultsController.object(at: indexPath)
        }

        cell.textLabel?.text = allergy.name

        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addAsegue", let displayVC = segue.destination as? AllergenViewController {
            displayVC.user = user
           // displayVC.delegate = self
            print("User value sent to Allergen: \(user)")
        }
    
    }
}
