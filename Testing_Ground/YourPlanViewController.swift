//  YourPlanViewController.swift
//  Testing_Ground
//
//  Created by Brianna Boston on 10/18/23.
//

import Foundation
import UIKit
import CoreData

class YourPlanViewController: UIViewController {
    var user = ""
    var childName = "" // This should be set before the view controller is presented
    var selectedChildProfile: Child?
    
    @IBOutlet weak var childNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Debugging print
        print("Fetching for user: \(user) and childName: \(childName)")
        
        // Attempt to fetch the specific child profile
        selectedChildProfile = fetchChildProfile(username: user, childName: childName)
        
        // Fallback to main child profile if the specific child profile is not found
        if selectedChildProfile == nil {
            print("Specific child profile not found, attempting to fetch main child profile.")
            selectedChildProfile = fetchMainChildProfile(username: user)
        }
        
        // Update the UI with the child's profile
        updateUIWithChildProfile()
        
        print("User: ", user)
        print("Child in Your Plan", childName)
    }
    
    func fetchChildProfile(username: String, childName: String) -> Child? {
        // Fetch logic for a specific child profile
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Child> = Child.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND firstName == %@", username, childName)
        
        
        //added this loop here to log the diet type and try to debug with print statements
        do {
            let childProfiles = try context.fetch(fetchRequest)
            if let childProfile = childProfiles.first {
                // Log the dietType for debugging
                print("Fetched Child Profile: \(childProfile.firstName!), Diet Type: \(childProfile.diettype ?? "nil")")
                return childProfile
            } else {
                print("No child profile found.")
                return nil
            }
        } catch {
            print("Error fetching child profile: \(error)")
            return nil
        }
    }

    func fetchMainChildProfile(username: String) -> Child? {
        // Fetch logic for the main child profile
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Child> = Child.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)
        
        do {
            let childProfiles = try context.fetch(fetchRequest)
            return childProfiles.first // Assuming the first child is the main child
        } catch {
            print("Error fetching main child profile: \(error)")
            return nil
        }
    }
    
    func updateUIWithChildProfile() {
        // Update the UI with the child's profile information
        if let childProfile = selectedChildProfile {
            childNameLabel.text = "\(childProfile.firstName!) \(childProfile.lastName!)"
        } else {
            childNameLabel.text = "Child Name"
        }
    }
    
    
    //added this dietButtonTapped method to try to create a way for the segue to be performed based on the diet type, i was looking at the other segues and since they're not dynamic (only one possible outcome) the button-tapped method wasn't necessary. but i added it here
    @IBAction func dietButtonTapped(_ sender: UIButton) {
        // Determine the diet type from the selected child's profile
        guard let diettype = selectedChildProfile?.diettype else {
            print("No diet type available for the selected child profile.")
            return
        }
        
        // Log the diet type for debugging
        print("Diet Type before switching: \(diettype)")
        
        // Perform the segue based on the diet type
        switch diettype {
        case "Diet1":
            performSegue(withIdentifier: "diet1segue", sender: self)
        case "Diet2":
            performSegue(withIdentifier: "diet2segue", sender: self)
        case "Diet4":
            performSegue(withIdentifier: "diet4segue", sender: self)
        case "Diet6":
            performSegue(withIdentifier: "diet6segue", sender: self)
        default:
            print("Unknown diet type: \(diettype)")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "medsegue", let displayVC = segue.destination as? MedicationProfile {
            // Pass the 'user' variable to MedicationProfile
            displayVC.user = user
            displayVC.childName = childName //added by bri you need this to figure out the child you are saving information to
            print("User value sent to MedicationProfile: \(user)")
        } else if segue.identifier == "diet1segue", let displayVC = segue.destination as? Diet1TestViewController {
            // Pass the 'user' and 'childName' to Diet1TestViewController
            displayVC.user = user
            displayVC.childName = childName //added by bri you need this to figure out the child you are saving information to
            
            //from here onwards i replaced the DietPlan segue stuff with programmatic segues for each diet (1,2,4,6) segues
            print("User value sent to Diet1TestViewController: \(user)")
        } else if segue.identifier == "diet2segue", let displayVC = segue.destination as? Diet2TestViewController {
            // Pass the 'user' and 'childName' to Diet2TestViewController
            displayVC.user = user
            displayVC.childName = childName
            print("User value sent to Diet2TestViewController: \(user)")
        } else if segue.identifier == "diet4segue", let displayVC = segue.destination as? Diet4TestViewController {
            // Pass the 'user' and 'childName' to Diet4TestViewController
            displayVC.user = user
            displayVC.childName = childName
            print("User value sent to Diet4TestViewController: \(user)")
        } else if segue.identifier == "diet6segue", let displayVC = segue.destination as? Diet6TestViewController {
            // Pass the 'user' and 'childName' to Diet6TestViewController
            displayVC.user = user
            displayVC.childName = childName
            print("User value sent to Diet6TestViewController: \(user)")
        } else if segue.identifier == "documentsegue", let displayVC = segue.destination as? AddDocumentsViewController {
            displayVC.user = user
            displayVC.childName = childName
            print("User value sent to AddDocumentsViewController: \(user)")
        } else if segue.identifier == "expsegue", let displayVC = segue.destination as? AccidentalExposureViewController {
            displayVC.user = user
            displayVC.childName = childName //added by bri you need this to figure out the child you are saving information to
            print("User value sent to AccidentalExposureViewController: \(user)")
        } else if segue.identifier == "edosegue", let displayVC = segue.destination as? EndoscopyViewController {
            displayVC.user = user
            displayVC.childName = childName //added by bri you need this to figure out the child you are saving information to
            print("User value sent to EndoscopyViewController: \(user)")
        }
    }
}
