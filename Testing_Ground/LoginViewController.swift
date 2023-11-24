import UIKit
import CoreData

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Username: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegates for the text fields
        Password.delegate = self
        Username.delegate = self
        
        // Gesture to collapse/dismiss keyboard on click outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    override func updateViewConstraints() {
        // Update or adjust constraints here
        super.updateViewConstraints()
    }

    @IBAction func EnterButton(_ sender: Any) {
        let username = Username.text ?? ""
        let password = Password.text ?? ""

        if username.isEmpty || password.isEmpty {
            // Handle empty username or password
            let alert = UIAlertController(title: nil, message: "Please enter both username and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("Username:",username)
            print("Password:",password)
        } else if validateLogin(username: username, password: password) {
            // You don't need to performSegue here, as it's handled by the Storyboard
            
            print("Username:",username)
            print("Password:",password)
        } else {
            // Invalid username or password
            print("Else Block Error:")
            print("Username:",username)
            print("Password:",password)
            let alert = UIAlertController(title: nil, message: "Username or password is incorrect", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == Username {
            Password.becomeFirstResponder()
        } else if textField == Password {
            textField.resignFirstResponder()
            // You can also call your EnterButton function here if needed.
        }
        return true
    }

    func validateLogin(username: String, password: String) -> Bool {
        // Assuming you have a Core Data entity named 'Parent' with attributes 'username' and 'password'
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Parent> = Parent.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)

        do {
            let matchingParents = try context.fetch(fetchRequest)
            return !matchingParents.isEmpty
        } catch {
            print("Error validating login: \(error)")
            return false
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func LoadItems() {
        // Validate username and password in the database, if true, send the username to the home page
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homesegue", let destinationVC = segue.destination as? HomeViewController {
            destinationVC.user = Username.text ?? "" // Pass the username to HomeViewController
        }
    }

}
