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
    
    //edited by brianna for dynamic segues to controllers
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
        
        case "No Diet Plan":
            if let diet1 = storyboard!.instantiateViewController(withIdentifier: "NoDietPlan") as? nodietplanviewcontroller {
                diet1.user = self.user
                diet1.childName = childName
                self.navigationController?.pushViewController(diet1, animated: true)
                
            }
        case "Diet 1":
            if let diet1 = storyboard!.instantiateViewController(withIdentifier: "Diet1ViewController TEST") as? Diet1TestViewController {
                diet1.user = self.user
                diet1.childName = childName
                self.navigationController?.pushViewController(diet1, animated: true)
                
            }
            //change
        case "Diet 2":
            if let diet1 = storyboard!.instantiateViewController(withIdentifier: "Diet2ViewController TEST") as? Diet2TestViewController {
                diet1.user = self.user
                diet1.childName = childName
                self.navigationController?.pushViewController(diet1, animated: true)
                
            }
            //change
        case "Diet 4":
            if let diet1 = storyboard!.instantiateViewController(withIdentifier: "Diet4ViewController TEST") as? Diet4TestViewController {
                diet1.user = self.user
                diet1.childName = childName
                self.navigationController?.pushViewController(diet1, animated: true)
                
            }
            //change
        case "Diet 6":
            if let diet1 = storyboard!.instantiateViewController(withIdentifier: "Diet6ViewController TEST") as? Diet6TestViewController {
                diet1.user = self.user
                diet1.childName = childName
                self.navigationController?.pushViewController(diet1, animated: true)
                
            }
        
        default:
            print("Segue doesnt work Diet")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "medsegue", let displayVC = segue.destination as? MedicationProfile {
            // Pass the 'user' variable to MedicationProfile
            displayVC.user = user
            displayVC.childName = childName //added by bri you need this to figure out the child you are saving information to
            print("User value sent to MedicationProfile: \(user)")
        }
        //somehow this was overwritten and I just fixed it again
         else if segue.identifier == "docsegue", let displayVC = segue.destination as? AddDocumentsViewController {
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


