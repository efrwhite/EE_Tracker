import Foundation
import CoreData
import UIKit

class HomeViewController: UIViewController {

    var mainChildProfile: Child?
    var user = ""
    var childselected = ""
    @IBOutlet weak var childnames: UILabel!
    @IBOutlet weak var childsimage: UIImageView!
    @IBOutlet weak var childsdiet: UILabel!
    var isButtonEnabled = true // Add a property to track button state

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Home Username: ", user)
        print("Home Childuser: ", childselected)

        // Fetch the main child entity with username == user
        mainChildProfile = fetchMainChildProfile(username: user)

        // Fetch the selected child if available
        let selectedChildProfile = fetchChildProfile(username: user, childName: childselected)

        // Use the selected child profile if available, otherwise use the main child profile
        if let selectedChildProfile = selectedChildProfile {
            updateUIWithChildProfile(childProfile: selectedChildProfile)
        } else {
            // If no selected child, use the first child found by the user
            mainChildProfile = fetchFirstChild(username: user)
            updateUIWithMainChildProfile()
        }

        // Hide the back button
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        // Setup the stack view
        setupChildViews()

        // Add a button (person icon) to the top right corner of the navigation bar
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "person.circle"), for: .normal)
        button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func setupChildViews() {
        childnames.translatesAutoresizingMaskIntoConstraints = false
        childsimage.translatesAutoresizingMaskIntoConstraints = false
        childsdiet.translatesAutoresizingMaskIntoConstraints = false

        // Assuming you want to maintain the aspect ratio of the image
        let imageAspectRatioConstraint = childsimage.widthAnchor.constraint(equalTo: childsimage.heightAnchor, multiplier: 1.0) // Adjust multiplier as needed based on your image's aspect ratio

        // Set a fixed height for the image view
        let imageHeightConstraint = childsimage.heightAnchor.constraint(equalToConstant: 90) // Adjust this constant to fit your design

        NSLayoutConstraint.activate([imageAspectRatioConstraint, imageHeightConstraint])

        let stackView = UIStackView(arrangedSubviews: [childnames, childsimage, childsdiet])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 20 // Adjust the spacing as needed

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20), // Adjust this as needed
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
        ])
    }



    @objc func showAlert() {
        let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .alert)
        
        let logoutAction = UIAlertAction(title: "Log Out", style: .destructive) { (_) in
            if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
                self.navigationController?.setNavigationBarHidden(true, animated: false)
                self.navigationController?.pushViewController(loginVC, animated: true)
                self.navigationController?.setNavigationBarHidden(false, animated: false)
            }
        }
        alertController.addAction(logoutAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }



//THIS was never called
    func updateUIWithMainChildProfile() {
        if let mainChildProfile = mainChildProfile {
            // Update the name label with child's name
            childnames.text = "\(mainChildProfile.firstName!) \(mainChildProfile.lastName!)"

            // Assuming you have a property called 'imageData' in Child entity that stores image data
            if let imageData = mainChildProfile.image {
                // Update the image view with child's image
                childsimage.image = UIImage(data: imageData)
            } else {
                // If there is no image data, you can set a default image or handle it as needed
                childsimage.image = UIImage(named: "DefaultImage")
            }

            // Update the diet label with child's diet type
            childsdiet.text = "Diet: \(String(describing: mainChildProfile.diettype!))"
            // Update other UI elements as needed
        } else {
            // Handle the case when no main child profile is found
            childnames.text = "Welcome!"
            childsimage.image = nil
            childsdiet.text = "Diet: Diet Type"
            // Update other UI elements as needed
        }
    }

    func updateUIWithChildProfile(childProfile: Child) {
        // Update the UI based on the selected child's profile
        childnames.text = "\(childProfile.firstName!) \(childProfile.lastName!)"

        if let imageData = childProfile.image {
            childsimage.image = UIImage(data: imageData)
        } else {
            childsimage.image = UIImage(named: "DefaultImage")
        }

        childsdiet.text = "Diet: \(String(describing: childProfile.diettype!))"
        // Update other UI elements as needed
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View will Appear Home Username: ", user)
        print("View will Appear Home Childuser: ", childselected)
        
        // Fetch the main child entity with username == user
        mainChildProfile = fetchMainChildProfile(username: user)

        // Fetch the selected child if available
        let selectedChildProfile = fetchChildProfile(username: user, childName: childselected)

        // Use the selected child profile if available, otherwise use the main child profile
        if let selectedChildProfile = selectedChildProfile {
            updateUIWithChildProfile(childProfile: selectedChildProfile)
        } else {
            // If no selected child, use the first child found by the user
            mainChildProfile = fetchFirstChild(username: user)
            updateUIWithMainChildProfile()
        }

        // Hide the back button
        self.navigationItem.setHidesBackButton(true, animated: false)

        // Remove the sign-up view controller from the navigation stack
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is SignUpViewController {
                    var newViewControllers = viewControllers
                    if let index = newViewControllers.firstIndex(of: viewController) {
                        newViewControllers.remove(at: index)
                        self.navigationController?.viewControllers = newViewControllers
                    }
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profilessegue", let displayVC = segue.destination as? HomeProfilePageViewController {
            // Pass any necessary data to HomeViewController if needed
            displayVC.user = user
            displayVC.selected = childselected
            print("User value sent to HomeProfilePage: \(user)")
        } else if segue.identifier == "plansegue", let displayVC = segue.destination as? YourPlanViewController {
            displayVC.user = user
            print("User value sent to Plan: ", user)
        }
    }

    func fetchMainChildProfile(username: String) -> Child? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Child> = Child.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", user)

        do {
            let childProfiles = try context.fetch(fetchRequest)
            return childProfiles.first // Get the first child profile that matches the predicate
        } catch {
            print("Error fetching main child profile: \(error)")
            return nil
        }
    }

    func fetchChildProfile(username: String, childName: String) -> Child? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Child> = Child.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND firstName == %@", user, childselected)

        do {
            let childProfiles = try context.fetch(fetchRequest)
            return childProfiles.first // Get the first child profile that matches the predicate
        } catch {
            print("Error fetching child profile: \(error)")
            return nil
        }
    }

    func fetchFirstChild(username: String) -> Child? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Child> = Child.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", user)

        do {
            let childProfiles = try context.fetch(fetchRequest)
            return childProfiles.first // Get the first child profile that matches the predicate
        } catch {
            print("Error fetching first child: \(error)")
            return nil
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Show the back button when leaving the view controller
        self.navigationItem.setHidesBackButton(false, animated: false)
    }
}
