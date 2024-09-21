//
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
        
        // Attempt to fetch the specific child profile
        selectedChildProfile = fetchChildProfile(username: user, childName: childName)
        
        // Fallback to main child profile if the specific child profile is not found
        if selectedChildProfile == nil {
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
        
        do {
            let childProfiles = try context.fetch(fetchRequest)
            return childProfiles.first
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
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "medsegue", let displayVC = segue.destination as? MedicationProfile {
            // Pass the 'user' variable to MedicationProfile
            displayVC.user = user
            displayVC.childName = childName //added by bri you need this to figure out the child you are saving information too
            print("User value sent to MedicationProfile: \(user)")
        } else if segue.identifier == "dietsegue", let displayVC = segue.destination as? DietPlanViewController {
            // Pass the 'user' variable to DietPlanViewController
            displayVC.user = user
            displayVC.childName = childName //added by bri you need this to figure out the child you are saving information too
            print("User value sent to DietPlanViewController: \(user)")
        } else if segue.identifier == "documentsegue", let displayVC = segue.destination as? AddDocumentsViewController {
            // Pass the 'user' variable to DietPlanViewController
            displayVC.user = user
            displayVC.childName = childName //added by bri you need this to figure out the child you are saving information too
            print("User value sent to DietPlanViewController: \(user)")
        }
        else if segue.identifier == "expsegue", let displayVC = segue.destination as? AccidentalExposureViewController{
            // Pass the 'user' variable to DietPlanViewController
            displayVC.user = user
            displayVC.childName = childName //added by bri you need this to figure out the child you are saving information too
            print("User value sent to DietPlanViewController: \(user)")
        }
        else if segue.identifier == "docsegue", let displayVC = segue.destination as? AddDocumentsViewController{
            // Pass the 'user' variable to DietPlanViewController
            displayVC.user = user
            displayVC.childName = childName //added by bri you need this to figure out the child you are saving information too
            print("User value sent to AddDocumentsViewController: \(user)")
        }
    }
    
    
}
