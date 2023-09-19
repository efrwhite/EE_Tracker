//
//  ParentViewController.swift
//  Testing_Ground
//
//  Created by Brianna Boston on 9/18/23.
//

import Foundation
import UIKit
import CoreData

class ParentViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
    @IBOutlet weak var parentLastName: UITextField!
    @IBOutlet weak var parentFirstName: UITextField!
    @IBOutlet weak var parentUserName: UITextField!
    @IBOutlet weak var parentimage: UIImageView!
    override func viewDidLoad() {
        print("You are on Parent")
    }
    
    //Save User information when button is pressed
    
    @IBAction func saveButton(_ sender: Any) {
    }
    
    @IBAction func selectimage(_ sender: Any) {
    }
    
    
    //LoadItems into CoreData
    
    func loadItems(){
        
    }
    // Save items into CoreData
    func saveItems(){
        do {
            try context.save()
        } catch {
            print("Error Saving context \(error)")
        }
    }
    
}
