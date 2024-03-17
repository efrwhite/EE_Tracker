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
        super.updateViewConstraints()
    }
    
    @IBAction func EnterButton(_ sender: Any) {
        guard let username = Username.text, let password = Password.text else { return }
        // Check for default credentials
        if username == defaultUsername && password == defaultPassword {
            // Perform the segue with the default login information
            performSegue(withIdentifier: "homesegue", sender: nil)
        } else {
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == Username {
            Password.becomeFirstResponder()
        } else if textField == Password {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func validateLogin(username: String, password: String) -> Bool {
        // Login validation logic
        return false // Placeholder return value
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "homesegue" {
            guard let username = Username.text, let password = Password.text, !username.isEmpty, !password.isEmpty else {
                presentAlert(message: "Please enter both username and password")
                return false
            }
            // Prevent the automatic segue if using the default credentials
            return !(username == defaultUsername && password == defaultPassword)
        }
        return true
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

