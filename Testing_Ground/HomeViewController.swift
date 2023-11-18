import Foundation
import CoreData
import UIKit

class HomeViewController: UIViewController {
    var mainChildProfile: Child?

    var user = ""
    @IBOutlet weak var childnames: UILabel!
    @IBOutlet weak var childsimage: UIImageView!
    @IBOutlet weak var childsdiet: UILabel!
    var isButtonEnabled = true // Add a property to track button state
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Home Username: ", user)
        
        // Fetch the first child entity with username == user
        mainChildProfile = fetchMainChildProfile(username: user)
        
        // Do any additional setup after loading the view.
        print("Main Child Profile: \(mainChildProfile?.firstName ?? "N/A")")
        updateUIWithMainChildProfile()
    }
    
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


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profilessegue", let displayVC = segue.destination as? HomeProfilePageViewController {
            // Pass any necessary data to HomeViewController if needed
            displayVC.user = user
            print("User value sent to HomeProfilePage: \(user)")
        }
        else if segue.identifier == "plansegue", let displayVC = segue.destination as? YourPlanViewController{
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

    
}
