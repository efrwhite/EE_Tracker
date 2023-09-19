//
//  ChildViewController.swift
//  Testing_Ground
//
//  Created by Brianna Boston on 9/18/23.
//
import UIKit
import CoreData
import Foundation
class ChildViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
    @IBOutlet weak var diettype: UIButton!
    @IBOutlet weak var gender: UIButton!
    @IBOutlet weak var birthdate: UIDatePicker!
    @IBOutlet weak var childFirstName: UITextField!
    @IBOutlet weak var childimage: UIImageView!
    override func viewDidLoad() {
        print("You are on Child")
    }
    
    //Save User information when button is pressed
    
    @IBAction func selectImage(_ sender: Any) {
    }
    
    @IBAction func saveButton(_ sender: Any) {
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
