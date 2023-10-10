import UIKit
import CoreData

class ChildViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var user = ""
    var isEditingChild: Bool = false
    var isAddingChild: Bool = false
    var childName: String?
    var usernamec: String?

    var child = [Child]()
    var editingChildProfile: Child?

    @IBOutlet weak var diettype: UIButton!
    @IBOutlet weak var gender: UIButton!
    @IBOutlet weak var birthdate: UIDatePicker!
    @IBOutlet weak var childFirstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var childimage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("You are on Child")
        print("Child User: ", user)
        print("Child name:", childName)
        usernamec = user
        setPopupButton()
        // Check if it's editing mode and load data if needed
                if isEditingChild {
                    // Load and populate data for editing
                    if let childName = childName, let usernamec = usernamec {
                        loadChildProfile(childName: childName, usernamec: usernamec)
                    }
                }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    func setPopupButton() {
        let optional = { (action: UIAction) in print(action.title) }

        gender.menu = UIMenu(children:[
            UIAction(title: "Male", state: .on, handler: optional),
            UIAction(title: "Female", handler: optional),
        ])

        let optional2 = { (action: UIAction) in print(action.title) }

        diettype.menu = UIMenu(children:[
            UIAction(title: "Diet 1", state: .on, handler: optional2),
            UIAction(title: "Diet 2", handler: optional2),
            UIAction(title: "Diet 4", handler: optional2),
            UIAction(title: "Diet 6", handler: optional2)
        ])

        diettype.showsMenuAsPrimaryAction = true
        diettype.changesSelectionAsPrimaryAction = true
        gender.showsMenuAsPrimaryAction = true
        gender.changesSelectionAsPrimaryAction = true
    }

    @IBAction func selectImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func saveButton(_ sender: Any) {
        if isEditingChild {
            print("editing created")
           
            // Get a reference to the HomeProfileViewController
            // Send the username back to HomeProfilePageViewController
            // Get a reference to the HomeProfilePageViewController
            updateChildProfile()
            if let homeProfileViewController = navigationController?.viewControllers.first(where: { $0 is HomeProfilePageViewController }) as? HomeProfilePageViewController {
                    homeProfileViewController.user = user
                    navigationController?.popToViewController(homeProfileViewController, animated: true)
                }
                    // Pop back to the HomeProfilePageViewController
                    navigationController?.popViewController(animated: true)
        } else if isAddingChild {
            print("adding created")
            addChildProfile()
            // Get a reference to the HomeProfileViewController
            // Send the username back to HomeProfilePageViewController
            if let homeProfileViewController = navigationController?.viewControllers.first(where: { $0 is HomeProfilePageViewController }) as? HomeProfilePageViewController {
                    homeProfileViewController.user = user
                    navigationController?.popToViewController(homeProfileViewController, animated: true)
                }
                    // Pop back to the HomeProfilePageViewController
                    navigationController?.popViewController(animated: true)
        } else {
            createChildProfile()
        }
    }
   
  
    func loadChildProfile(childName: String, usernamec: String) {
            let fetchRequest: NSFetchRequest<Child> = Child.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "username == %@ AND firstName == %@", usernamec, childName)
            
            do {
                let results = try context.fetch(fetchRequest)
                if let profile = results.first {
                    childFirstName.text = profile.firstName
                    lastName.text = profile.lastName
                    // Populate other fields as needed (diettype, gender, etc.)
                    // ...
                    if let imageData = profile.image {
                        childimage.image = UIImage(data: imageData)
                    }
                } else {
                    showAlert(title: "Profile Not Found", message: "No matching profile found.")
                }
            } catch {
                print("Error fetching entity: \(error)")
                showAlert(title: "Error", message: "Failed to load profile.")
            }
        }
    
    func updateChildProfile() {
        // Handle editing an existing profile
        if let profileToEdit = editingChildProfile {
            profileToEdit.firstName = childFirstName.text!
            profileToEdit.lastName = lastName.text!
            profileToEdit.username = user
            profileToEdit.diettype = diettype.currentTitle ?? ""
            
            // Update other profile properties as needed
            // ...

            if let selectedImage = childimage.image {
                // Convert the UIImage to Data
                if let imageData = selectedImage.pngData() {
                    profileToEdit.image = imageData
                } else {
                    print("Error converting image to data.")
                }
            } else {
                print("No image selected.")
            }
            
            // Save the changes
            saveContext()
            showAlert(title: "Success", message: "Profile updated successfully.")
        }
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func addChildProfile() {
        // Handle adding a new profile
        let newChild = Child(context: context)
        newChild.firstName = childFirstName.text!
        newChild.lastName = lastName.text!
        newChild.username = user
        newChild.diettype = diettype.currentTitle
        if let selectedImage = childimage.image {
            // Convert the UIImage to Data
            if let imageData = selectedImage.pngData() {
                newChild.image = imageData
            } else {
                print("Error converting image to data.")
            }
        } else {
            print("No image selected.")
        }
        child.append(newChild)
        saveContext()
        print("New profile added successfully.")
    }

    func createChildProfile() {
        // Handle creating a new profile (similar to adding)
        addChildProfile()
    }

    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error Saving context \(error)")
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "homeSegue", let displayVC = segue.destination as? HomeViewController {
               // Pass any necessary data to HomeViewController if needed
               displayVC.user = user
               print("User value sent to HomeViewController: \(user)")
           }
       }
}

extension ChildViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
