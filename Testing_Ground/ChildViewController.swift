import UIKit
import CoreData
class ChildViewController: UIViewController,UITextFieldDelegate  {
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
        //NSLog("Session ID in viewDidLoad: ", mySessionID);
        print("You are on Child")
        print("Child User: ", user)
        childimage.layer.cornerRadius = 5
        childimage.layer.borderWidth = 1
        childimage.contentMode = .scaleAspectFill
        childimage.layer.borderColor = UIColor.lightGray.cgColor
        if childName != nil {
            print("Child name:", childName!)
        } else {
            print("No Child name")
        }
        //user textfields to delegate
        childFirstName.delegate = self
        lastName.delegate = self
        
        
        usernamec = user
        setPopupButton()
        // Check if it's editing mode and load data if needed
                if isEditingChild {
                    print("Child Edited")
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
            UIAction(title: "No Diet Plan", state: .on, handler: optional2),
            UIAction(title: "Diet 1", handler: optional2),
            UIAction(title: "Diet 2", handler: optional2),
            UIAction(title: "Diet 4", handler: optional2),
            UIAction(title:"Diet 6", handler: optional2)
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
    func loadChildProfile(childName: String, usernamec: String) {
        let fetchRequest: NSFetchRequest<Child> = Child.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND firstName == %@", usernamec, childName)
        do {
            let results = try context.fetch(fetchRequest)
            if let profile = results.first {
                editingChildProfile = profile // Set the editing profile
                childFirstName.text = profile.firstName
                lastName.text = profile.lastName
                diettype.setTitle(profile.diettype, for: .normal)
                gender.setTitle(profile.gender, for: .normal)
                birthdate.date = profile.birthday ?? Date()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard when the Return key is pressed
        textField.resignFirstResponder()
        return true
    }

    
    func addChildProfile() {
        // Handle adding a new profile
        let newChild = Child(context: context)
        newChild.firstName = childFirstName.text!
        newChild.lastName = lastName.text!
        newChild.username = user
        newChild.diettype = diettype.currentTitle
        newChild.gender = gender.currentTitle ?? "" // Set the gender using selectedGender
        newChild.birthday = birthdate.date
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
    func updateChildProfile() {
        print("Im in edit function for updating")
        if let profileToEdit = editingChildProfile {
            print("name:", childFirstName.text)
            profileToEdit.firstName = childFirstName.text ?? "" // Safely unwrap text
            profileToEdit.lastName = lastName.text ?? "" // Safely unwrap text
            profileToEdit.username = user // Make sure `user` is correctly set
            profileToEdit.diettype = diettype.currentTitle ?? "" // Safely unwrap button title
            profileToEdit.gender = gender.currentTitle ?? "" // Safely unwrap button title
            profileToEdit.birthday = birthdate.date
            if let selectedImage = childimage.image {
                if let imageData = selectedImage.pngData() {
                    profileToEdit.image = imageData
                } else {
                    print("Error converting image to data.")
                }
            } else {
                print("No image selected.")
            }
            saveContext()
            showAlert(title: "Success", message: "Profile updated successfully.")
        } else {
            print("No profile to edit.")
        }
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func createChildProfile() {
        // Handle adding a new profile
        let newChild = Child(context: context)
        newChild.firstName = childFirstName.text!
        newChild.lastName = lastName.text!
        newChild.username = user
        newChild.diettype = diettype.currentTitle
        newChild.gender = gender.currentTitle ?? "" // Set the gender using selectedGender
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
    func showAlertAndNavigate(shouldNavigateToHome: Bool, shouldPopViewController: Bool) {
        let alert = UIAlertController(title: "Success", message: "Child saved successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }
            if shouldNavigateToHome {
                // Navigate to the HomeViewController
                if let homeViewController = self.navigationController?.viewControllers.first(where: { $0 is HomeViewController }) as? HomeViewController {
                    // HomeViewController is already in the stack, pop to it
                    homeViewController.user = self.user
                    self.navigationController?.popToViewController(homeViewController, animated: true)
                } else {
                    // HomeViewController is not in the stack, instantiate and push it
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                        homeViewController.user = self.user
                        homeViewController.childselected = self.childFirstName.text!
                        self.navigationController?.pushViewController(homeViewController, animated: true)
                    } else {
                        print("Error: HomeViewController not found in storyboard")
                    }
                }
            } else if shouldPopViewController {
                // Navigate to the HomeProfilePageViewController
                if let homeProfileViewController = self.navigationController?.viewControllers.first(where: { $0 is HomeProfilePageViewController }) as? HomeProfilePageViewController {
                    // HomeProfilePageViewController is in the stack, pop to it
                    homeProfileViewController.user = self.user
                    self.navigationController?.popToViewController(homeProfileViewController, animated: true)
                } else {
                    // HomeProfilePageViewController is not in the stack, pop the current view controller
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
        present(alert, animated: true, completion: nil)
    }
    @IBAction func saveButton(_ sender: Any) {
        if isEditingChild {
            // Handle editing an existing child profile
            print("Editing child profile")
            updateChildProfile()
            showAlertAndNavigate(shouldNavigateToHome: false, shouldPopViewController: true)
        } else if isAddingChild {
            // Handle adding a new child profile
            print("Adding new child profile")
            addChildProfile()
            showAlertAndNavigate(shouldNavigateToHome: false, shouldPopViewController: true)
        } else {
            // Handle other cases (if needed)
            print("Creating child profile")
            createChildProfile()
            showAlertAndNavigate(shouldNavigateToHome: true, shouldPopViewController: false)
        }
    }
   
}///END
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

