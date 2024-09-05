
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
