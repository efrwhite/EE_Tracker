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
    var user = ""
    var child = [Child]()
    @IBOutlet weak var diettype: UIButton!
    @IBOutlet weak var gender: UIButton!
    @IBOutlet weak var birthdate: UIDatePicker!
    @IBOutlet weak var childFirstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var childimage: UIImageView!
    override func viewDidLoad() {
        print("You are on Child")
        print("Child User: ", user)
        setpopupbutton()
        // Gesture to collapse/dismiss keyboard on click outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    //Save User information when button is pressed
    
    @IBAction func selectImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    func setpopupbutton(){
        let optional = {(action: UIAction) in print(action.title)}

        gender.menu = UIMenu(children:[
            UIAction(title:"Male",state: .on, handler: optional),
            UIAction(title:"Female", handler: optional),
        
        ])
        let optional2 = {(action: UIAction) in print(action.title)}

        diettype.menu = UIMenu(children:[
            UIAction(title:"Diet1",state: .on, handler: optional2),
            UIAction(title:"Diet2", handler: optional2),
            UIAction(title:"Diet4", handler: optional2),
            UIAction(title:"Diet6", handler: optional2)
        
        ])
        diettype.showsMenuAsPrimaryAction = true
        diettype.changesSelectionAsPrimaryAction = true
        gender.showsMenuAsPrimaryAction = true
        gender.changesSelectionAsPrimaryAction = true
        
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        
        let newchild = Child(context: self.context)
        newchild.username = user
        newchild.firstName = childFirstName.text!
        newchild.lastName = lastName.text!
        newchild.birthday = birthdate.date
        newchild.gender = gender.currentTitle
        newchild.diettype = diettype.currentTitle
        self.child.append(newchild)
        self.saveItems()
        
        
    }
    
    
    //LoadItems into CoreData
    
    func loadItems(){
        
    }
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeSegue", let displayVC = segue.destination as? HomeViewController {
            displayVC.user = user
            print("User value sent to HomeViewController: \(user)")
        }
    }
    // Enter dismisses keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // dismiss Keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
// MARK: - PICKERVIEW FUNCTIONS IMAGE
extension ChildViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            childimage.image = image
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    
}
