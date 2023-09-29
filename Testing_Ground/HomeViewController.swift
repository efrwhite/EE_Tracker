import Foundation
import CoreData
import UIKit

class HomeViewController: UIViewController {
    var user = ""
    var isButtonEnabled = true // Add a property to track button state
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Home Username: ", user)
        
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        // Check if the button is enabled
        guard isButtonEnabled else {
            return
        }
        
        // Disable the button to prevent multiple taps
        isButtonEnabled = false
        
        // Create an instance of HomeProfilePageViewController
        let homeProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeProfilePageViewController") as! HomeProfilePageViewController
        
        // Set the logged-in username
        homeProfileVC.user = user
        
        // Present the HomeProfilePageViewController
        navigationController?.pushViewController(homeProfileVC, animated: true)
        
        // Re-enable the button after a delay (adjust the delay as needed)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isButtonEnabled = true
        }
    }
    
    
    func loadItems(){
        // Load database items into Home Page based on child.user
        
    }
}

