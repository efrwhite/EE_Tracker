import UIKit
import CoreData

var defaultUsername = "username"
var defaultPassword = "password"

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
        guard let username = Username.text, let password = Password.text, !username.isEmpty, !password.isEmpty else {
            presentAlert(message: "Please enter both username and password")
            return
        }

        // Check for default credentials
        if username == defaultUsername && password == defaultPassword {
            // Handle default login by segueing Home
            performSegue(withIdentifier: "homesegue", sender: nil)
        } else if validateLogin(username: username, password: password) {
            // Handle normal login flow
            // You don't need to performSegue here, as it's handled by the Storyboard
        } else {
            presentAlert(message: "Username or password is incorrect")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homesegue", let destinationVC = segue.destination as? HomeViewController {
            destinationVC.user = Username.text ?? "" // Pass the username to HomeViewController
        }
    }
    
    func presentAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
