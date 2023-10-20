//
//  DietPlanViewController.swift
//  Testing_Ground
//
//  Created by Brianna Boston on 10/20/23.
//


import Foundation
import UIKit
class DietPlanViewController: UIViewController {
    var user = ""
    override func viewDidLoad() {
        loadView()
        print("Diet Plan User: ", user)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allergysegue", let displayVC = segue.destination as? AddAllergenViewController {
            // Pass any necessary data to HomeViewController if needed
            displayVC.user = user
            print("User value sent to Add Allergy: \(user)")
        }
    
    }
}
