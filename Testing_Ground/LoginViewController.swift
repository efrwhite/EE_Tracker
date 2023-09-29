import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{

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
        if username.isEmpty {
            let usernamealert = UIAlertController(title: nil, message: "Please enter username", preferredStyle: .alert)
            usernamealert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(usernamealert, animated: true, completion: nil)
        }
        
        if password.isEmpty {
            let passwordalert = UIAlertController(title: nil, message: "Please enter password", preferredStyle: .alert)
            passwordalert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(passwordalert, animated: true, completion: nil)
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func LoadItems() {
        // Validate username and password in the database, if true, send the username to the home page
    }
}
