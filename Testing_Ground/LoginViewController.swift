import UIKit
import CoreData

var defaultUsername = "username"
var defaultPassword = "password"

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var stackView: UIStackView! // IBOutlet for the stack view

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the delegates for the text fields
        Password.delegate = self
        Username.delegate = self

        // Gesture to collapse/dismiss keyboard on click outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // Add observers for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        // Remove observers when the view controller is deallocated
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func EnterButton(_ sender: Any) {
        guard let username = Username.text, let password = Password.text else { return }
        // Check for default credentials
        if username == defaultUsername && password == defaultPassword {
            // Perform the segue with the default login information
            performSegue(withIdentifier: "homesegue", sender: nil)
        } else {
            // Add your custom login validation logic here
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

    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            
            let keyboardHeight = keyboardFrame.height
            UIView.animate(withDuration: duration) {
                self.view.frame.origin.y = -keyboardHeight / 2 // Adjust this value as needed
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            
            UIView.animate(withDuration: duration) {
                self.view.frame.origin.y = 0
            }
        }
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
