//
//  YourPlanViewController.swift
//  Testing_Ground
//
//  Created by Brianna Boston on 10/18/23.
//

import Foundation
import UIKit
class YourPlanViewController: UIViewController {
    var user = ""
    override func viewDidLoad() {
        loadView()
        print("User: ", user)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "medsegue", let displayVC = segue.destination as? MedicationProfile {
            // Pass any necessary data to HomeViewController if needed
            displayVC.user = user
            print("User value sent to HomeProfilePage: \(user)")
        } else if segue.identifier == "dietsegue", let displayVC = segue.destination as? DietPlanViewController{
            // Pass any necessary data to HomeViewController if needed
            displayVC.user = user
            print("User value sent to HomeProfilePage: \(user)")
            
        }
        
        
        
    }
}
