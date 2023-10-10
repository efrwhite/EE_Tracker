import Foundation
import UIKit
import CoreData


class ParentViewController: UIViewController {
    
    // Your Core Data context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var profiles = [Parent]()
    var receivedString = ""
    var user = ""
    var isEditingParent: Bool = false
    var isAddingParent: Bool = false
    var parentName: String?
    var usernamep: String?
    
    @IBOutlet weak var parentLastName: UITextField!
    @IBOutlet weak var parentFirstName: UITextField!
    @IBOutlet weak var parentUserName: UITextField!
    @IBOutlet weak var parentimage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("You are on Parent")
        print(user)
        if isEditingParent {
                    // Load and populate data for editing
                    if let parentName = parentName, let usernamep = usernamep {
                        loadParentProfile(parentName: parentName, usernamep: usernamep)
                    }
                }
        // Gesture to collapse/dismiss keyboard on click outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
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
    @IBAction func saveButton(_ sender: Any) {
        // Ensure that all required fields are not empty
        guard let lastName = parentLastName.text,
              let firstName = parentFirstName.text,
              !lastName.isEmpty, !firstName.isEmpty else {
            showAlert(title: "Missing Information", message: "Please fill in all fields.")
            return
        }
        
        let userName = user
        
        if isEditingParent {
            // You are editing an existing profile
            // Use the 'parentName' and 'usernamep' to identify the profile to edit
            // Update the attributes of the existing entity
            if let parentName = parentName, let usernamep = usernamep {
                updateParentProfile(lastName: lastName, firstName: firstName, userName: userName, parentName: parentName, usernamep: usernamep)
                performSegue(withIdentifier: "unwindToHomeProfilePageSegue", sender: self)
            }
        } else if isAddingParent {
            // You are adding a new profile
            // Create a new 'Parent' entity and set its attributes
            createNewParentProfile(lastName: lastName, firstName: firstName, userName: userName)
           
            showAlert(title: "Success", message: "Profile created successfully.")
                    // Clear text fields and reset isAddingParent
    
            // Trigger the unwind segue to go back to HomeProfileViewController
            // Send the username back to HomeProfilePageViewController
            // Perform the unwind segue to go back to HomeProfilePageViewController
            performSegue(withIdentifier: "unwindToHomeProfilePageSegue", sender: self)
      
        } else {
            // You are adding a new profile or updating an existing one
               // Check if a profile with the same parentName and usernamep exists
               let fetchRequest: NSFetchRequest<Parent> = Parent.fetchRequest()
               fetchRequest.predicate = NSPredicate(format: "username == %@", user)

               do {
                   let results = try context.fetch(fetchRequest)
                   if let profile = results.first {
                       // Update the attributes of the fetched entity
                       profile.lastname = lastName
                       profile.firstname = firstName
                       let imageData = parentimage.image?.pngData()
                       profile.image = imageData

                       // Save the context to persist the changes
                       saveContext()
                       showAlert(title: "Success", message: "Profile updated successfully.")
                   } else {
                       // No matching profile found, create a new one
                       createNewParentProfile(lastName: lastName, firstName: firstName, userName: userName)
                   }
               } catch {
                   print("Error fetching or updating entity: \(error)")
                   showAlert(title: "Error", message: "Failed to update profile.")
               }
        }
    }
    
    
    @IBAction func unwindToHomeProfilePage(_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ChildViewController {
            // Pass the username back to HomeProfilePageViewController
            if let homeProfileViewController = navigationController?.viewControllers.first(where: { $0 is HomeProfilePageViewController }) as? HomeProfilePageViewController {
                homeProfileViewController.user = sourceViewController.user
            }
            
            // Perform the unwind segue to go back to HomeProfilePageViewController
            navigationController?.popViewController(animated: true)
        }
    }

    // Function to update an existing Parent entity
    func updateParentProfile(lastName: String, firstName: String, userName: String, parentName: String, usernamep: String) {
        let fetchRequest: NSFetchRequest<Parent> = Parent.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND firstname == %@", usernamep, parentName)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let profile = results.first {
                // Update the attributes of the fetched entity
                profile.lastname = lastName
                profile.firstname = firstName
                let imageData = parentimage.image?.pngData()
                profile.image = imageData
                
                // Save the context to persist the changes
                saveContext()
                showAlert(title: "Success", message: "Profile updated successfully.")
            } else {
                showAlert(title: "Profile Not Found", message: "No matching profile found.")
            }
        } catch {
            print("Error fetching or updating entity: \(error)")
            showAlert(title: "Error", message: "Failed to update profile.")
        }
    }

    // Function to create a new Parent entity
    func createNewParentProfile(lastName: String, firstName: String, userName: String) {
        // Create a new 'Parent' entity and set its attributes
        let newProfile = Parent(context: context)
        newProfile.lastname = lastName
        newProfile.firstname = firstName
        newProfile.username = userName
        let imageData = parentimage.image?.pngData()
        newProfile.image = imageData
        
        // Save the context to persist the changes
        saveContext()
        showAlert(title: "Success", message: "Profile created successfully.")
    }
    func loadParentProfile(parentName: String, usernamep: String) {
            let fetchRequest: NSFetchRequest<Parent> = Parent.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "username == %@ AND firstname == %@", usernamep, parentName)
            
            do {
                let results = try context.fetch(fetchRequest)
                if let profile = results.first {
                    parentLastName.text = profile.lastname
                    parentFirstName.text = profile.firstname
                    
                    if let imageData = profile.image {
                        parentimage.image = UIImage(data: imageData)
                    }
                } else {
                    showAlert(title: "Profile Not Found", message: "No matching profile found.")
                }
            } catch {
                print("Error fetching entity: \(error)")
                showAlert(title: "Error", message: "Failed to load profile.")
            }
        }
    
    // Helper method to save the Core Data context
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error Saving context \(error)")
        }
    }
    
    @IBAction func selectImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

    // Helper method to display an alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "childSegue", let displayVC = segue.destination as? ChildViewController {
            displayVC.user = user
        }
    }
    
}
// MARK: - PICKERVIEW FUNCTIONS IMAGE
extension ParentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            parentimage.image = image
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    
}
