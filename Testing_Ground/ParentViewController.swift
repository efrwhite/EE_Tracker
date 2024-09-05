//import Foundation
//import UIKit
//import CoreData
//
//class ParentViewController: UIViewController {
//
//    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    var profiles = [Parent]()
//    var receivedString = ""
//    var user = ""
//    var usernamesup = ""
//    var isEditingParent: Bool = false
//    var isAddingParent: Bool = false
//    var parentName: String?
//    var usernamep: String?
//    
//    @IBOutlet weak var parentLastName: UITextField!
//    @IBOutlet weak var parentFirstName: UITextField!
//    @IBOutlet weak var parentUserName: UITextField!
//    @IBOutlet weak var parentimage: UIImageView!
//    @IBOutlet weak var stackView: UIStackView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Disable user interaction for the parentUserName text field
//        parentUserName.isUserInteractionEnabled = false
//        print("You are on Parent") //empty what the fuck are we passing through???
//        print("Parent user", user)
//        
//        
//        print(receivedString)
//        print("Edit Button Pushed: ", isEditingParent )
//        print("ADD Button Pushed: ", isAddingParent )
//
//        if isEditingParent {
//            print("Edit User: ", user)
//            print("Parent name", parentName!)
//            if user != "", ((parentName?.isEmpty) != nil) {
//                print("sending data to function")
//                loadParentProfile(parentName: parentName!, usernamep: user)
//                }
//            //loadView()
//            }
//        
//
//    }
//
//  //I deleted keyboard logic it needs to be in a header section to ensure the flow of the code makes sense
//    
//// SAVE BUTTON MAKES NO SENSE
//    @IBAction func saveButton(_ sender: Any) {
//        //this is not working Im deleting and modifying this
//        // Ensure that all required fields are not empty ( THIS makes no sense) absolutely a shit show
//        guard let lastName = parentLastName.text, !lastName.isEmpty,
//              let firstName = parentFirstName.text, !firstName.isEmpty,
//              let userName = parentUserName.text, !userName.isEmpty, //No this is not correct and will cause issues should be rethough on this logic because it is not correct but I will make it work
//              let _ = parentimage.image else {
//            return showAlert(title: "Missing Information", message: "Please fill in all fields.")
//            
//        }
//        print("firstname",firstName,"lastname",lastName)
//        if isEditingParent {
//            print("Saved in Editing Parent")
//            // You are editing an existing profile
//            updateParentProfile(lastName: lastName, firstName: firstName, userName: userName, parentName: parentName!, usernamep: user)
//            navigateToProfileController()
//            
//        } else if isAddingParent {
//            print("Saved in Adding Parent")
//            // You are adding a new profile
//            // Check if usernamesup is provided
//            if let usernamesup = parentUserName.text, !user.isEmpty {
//                createNewParentProfile(lastName: lastName, firstName: firstName, userName: user)
//                showAlert(title: "Success", message: "Profile created successfully.")
//                navigateToProfileController()
//            } else {
//                showAlert(title: "Missing Information", message: "Username is missing.")
//            }
//        } else {
//            print("save and move to child controller")
//            // You are updating an existing profile
//            if let username = parentUserName.text, !user.isEmpty {
//                updateExistingProfile(lastName: lastName, firstName: firstName, userName: user)
//                showAlert(title: "Success", message: "Profile updated successfully.")
//                navigateToChildViewController()
//            } else {
//                showAlert(title: "Missing Information", message: "Username is missing.")
//            }
//        }
//    }
//    func navigateToChildViewController() {
//            performSegue(withIdentifier: "childSegue", sender: self)
//        }
//    func navigateToProfileController(){
//        if let viewControllers = navigationController?.viewControllers {
//            for controller in viewControllers {
//                if controller is HomeProfilePageViewController {
//                    navigationController?.popToViewController(controller, animated: true)
//                    break
//                }
//            }
//        }
//
//    }
//    // Function to update an existing profile entity
//    func updateExistingProfile(lastName: String, firstName: String, userName: String) {
//        let fetchRequest: NSFetchRequest<Parent> = Parent.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "username == %@", userName)
//
//        do {
//            let results = try context.fetch(fetchRequest)
//            if let profile = results.first {
//                // Update the attributes of the fetched entity
//                profile.lastname = lastName
//                profile.firstname = firstName
//                let imageData = parentimage.image?.pngData()
//                profile.image = imageData
//
//                // Save the context to persist the changes
//                saveContext()
//            } else {
//                showAlert(title: "Profile Not Found", message: "No matching profile found.")
//            }
//        } catch {
//            print("Error fetching or updating entity: \(error)")
//            showAlert(title: "Error", message: "Failed to update profile.")
//        }
//    }
//
//    // Function to update an existing Parent entity
//    func updateParentProfile(lastName: String, firstName: String, userName: String, parentName: String, usernamep: String) {
//        let fetchRequest: NSFetchRequest<Parent> = Parent.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "username == %@ AND firstname == %@", usernamep, parentName)
//        
//        do {
//            let results = try context.fetch(fetchRequest)
//            if let profile = results.first {
//                // Update the attributes of the fetched entity
//                profile.lastname = lastName
//                profile.firstname = firstName
//                let imageData = parentimage.image?.pngData()
//                profile.image = imageData
//                
//                // Save the context to persist the changes
//                saveContext()
//                showAlert(title: "Success", message: "Profile updated successfully.")
//            } else {
//                showAlert(title: "Profile Not Found", message: "No matching profile found.")
//            }
//        } catch {
//            print("Error fetching or updating entity: \(error)")
//            showAlert(title: "Error", message: "Failed to update profile.")
//        }
//    }
//
//    // Function to create a new Parent entity
//    func createNewParentProfile(lastName: String, firstName: String, userName: String) {
//        // Create a new 'Parent' entity and set its attributes
//        let newProfile = Parent(context: context)
//        newProfile.lastname = lastName
//        newProfile.firstname = firstName
//        newProfile.username = usernamep
//        let imageData = parentimage.image?.pngData()
//        newProfile.image = imageData
//        
//        // Save the context to persist the changes
//        saveContext()
//        showAlert(title: "Success", message: "Profile created successfully.")
//    }
//    
//    func loadParentProfile(parentName: String, usernamep: String) {
//        let fetchRequest: NSFetchRequest<Parent> = Parent.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "username == %@ AND firstname == %@", usernamep, parentName)
//        print("In Load Function: ",usernamep,parentName)
//        do {
//            let results = try context.fetch(fetchRequest)
//            if let profile = results.first {
//                parentLastName.text = profile.lastname
//                parentFirstName.text = profile.firstname
//                parentUserName.text = profile.username
//                
//                if let imageData = profile.image {
//                    parentimage.image = UIImage(data: imageData)
//                }
//            } else {
//                showAlert(title: "Profile Not Found", message: "No matching profile found.")
//            }
//        } catch {
//            print("Error fetching entity: \(error)")
//            showAlert(title: "Error", message: "Failed to load profile.")
//        }
//    }
//    
//    // Helper method to save the Core Data context
//    func saveContext() {
//        do {
//            try context.save()
//        } catch {
//            print("Error Saving context \(error)")
//        }
//    }
//    
//    @IBAction func selectImage(_ sender: Any) {
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = .photoLibrary
//        imagePicker.allowsEditing = true
//        present(imagePicker, animated: true, completion: nil)
//    }
//
//    // Helper method to display an alert
//    func showAlert(title: String, message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }
// 
//   
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "childSegue", let displayVC = segue.destination as? ChildViewController {
//            displayVC.user = user
//        }
//    }
//}
//
//// MARK: - PICKERVIEW FUNCTIONS IMAGE
//extension ParentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//            parentimage.image = image
//        }
//        picker.dismiss(animated: true)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true)
//    }
//}
import Foundation
import UIKit
import CoreData

class ParentViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var profiles = [Parent]()
    var receivedString = ""
    var user = ""
    var usernamesup = ""
    var isEditingParent: Bool = false
    var isAddingParent: Bool = false
    var parentName: String?
    var usernamep: String?

    @IBOutlet weak var parentLastName: UITextField!
    @IBOutlet weak var parentFirstName: UITextField!
    @IBOutlet weak var parentUserName: UITextField!
    @IBOutlet weak var parentimage: UIImageView!
    @IBOutlet weak var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("User in Parent",user)
        // Disable user interaction for the parentUserName text field
        parentUserName.isUserInteractionEnabled = false

        if isEditingParent {
            if let parentName = parentName, !parentName.isEmpty {
                loadParentProfile(parentName: parentName, usernamep: user)
            }
        } else if isAddingParent{
            parentUserName.text = user
            print("username",user)
        }
    }

    @IBAction func saveButton(_ sender: Any) {
        guard let lastName = parentLastName.text, !lastName.isEmpty,
              let firstName = parentFirstName.text, !firstName.isEmpty,
              let userName = parentUserName.text, !user.isEmpty,
              let _ = parentimage.image else {
            return showAlert(title: "Missing Information", message: "Please fill in all fields.")
        }

        if isEditingParent {
            print("edit statement save button")
            updateParentProfile(lastName: lastName, firstName: firstName, userName: userName, parentName: parentName!, usernamep: user)
            showAlertAndNavigate(shouldNavigateToHome: false, shouldPopViewController: true)
        } else if isAddingParent {
            print("add statement save button")
            if let usernamesup = parentUserName.text, !user.isEmpty {
                createNewParentProfile(lastName: lastName, firstName: firstName, userName: user)
                showAlertAndNavigate(shouldNavigateToHome: false, shouldPopViewController: true)
            } else {
                showAlert(title: "Missing Information", message: "Username is missing.")
            }
        } else {
            print("else statement save button")
            if let username = parentUserName.text, !user.isEmpty {
                updateExistingProfile(lastName: lastName, firstName: firstName, userName: user)
                showAlertAndNavigate(shouldNavigateToHome: true, shouldPopViewController: false)
            } else {
                showAlert(title: "Missing Information", message: "Username is missing.")
            }
        }
    }

    func showAlertAndNavigate(shouldNavigateToHome: Bool, shouldPopViewController: Bool) {
        let alert = UIAlertController(title: "Success", message: "Profile saved successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }

            // Print statements for debugging
            print("shouldNavigateToHome: \(shouldNavigateToHome)")
            print("shouldPopViewController: \(shouldPopViewController)")

            if shouldNavigateToHome {
                // Navigate to the childViewController
                if let childViewController = self.navigationController?.viewControllers.first(where: { $0 is ChildViewController }) as? ChildViewController {
                    childViewController.user = self.user
                    print("Navigating to ChildViewController")
                    self.navigationController?.popToViewController(childViewController, animated: true)
                } else {
                    // If the ChildViewController is not found in the stack, push it
                    print("Pushing to ChildViewController")
                    self.navigateToChildViewController()
                }
            } else if shouldPopViewController {
                // Pop the current view controller
                print("Popping current ViewController")
                self.navigationController?.popViewController(animated: true)
            }
        })

        // Present the alert
        present(alert, animated: true, completion: nil)
    }


    func updateExistingProfile(lastName: String, firstName: String, userName: String) {
        let fetchRequest: NSFetchRequest<Parent> = Parent.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", userName)

        do {
            let results = try context.fetch(fetchRequest)
            if let profile = results.first {
                profile.lastname = lastName
                profile.firstname = firstName
                let imageData = parentimage.image?.pngData()
                profile.image = imageData
                saveContext()
            } else {
                showAlert(title: "Profile Not Found", message: "No matching profile found.")
            }
        } catch {
            print("Error fetching or updating entity: \(error)")
            showAlert(title: "Error", message: "Failed to update profile.")
        }
    }

    func updateParentProfile(lastName: String, firstName: String, userName: String, parentName: String, usernamep: String) {
        let fetchRequest: NSFetchRequest<Parent> = Parent.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND firstname == %@", usernamep, parentName)

        do {
            let results = try context.fetch(fetchRequest)
            if let profile = results.first {
                profile.lastname = lastName
                profile.firstname = firstName
                let imageData = parentimage.image?.pngData()
                profile.image = imageData
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

    func createNewParentProfile(lastName: String, firstName: String, userName: String) {
        let newProfile = Parent(context: context)
        newProfile.lastname = lastName
        newProfile.firstname = firstName
        newProfile.username = user
        let imageData = parentimage.image?.pngData()
        newProfile.image = imageData
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
                parentUserName.text = profile.username
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

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func navigateToChildViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let childVC = storyboard.instantiateViewController(withIdentifier: "ChildViewController") as? ChildViewController {
            childVC.user = self.user
            self.navigationController?.pushViewController(childVC, animated: true)
        }
    }

}

// MARK: - PICKERVIEW FUNCTIONS IMAGE
extension ParentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
