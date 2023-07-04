//
//  SignInViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 7/1/23.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Username: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        Password.delegate = self
        Username.delegate = self
    }

    @IBAction func EnterButton(_ sender: Any) {
        let username = Username.text ?? ""
        let password = Password.text ?? ""
        
        if username.isEmpty {
            let usernameAlert = UIAlertController(title: nil, message: "Please enter username", preferredStyle: .alert)
            usernameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(usernameAlert, animated: true, completion: nil)
            return
        }
        
        if password.isEmpty {
            let passwordAlert = UIAlertController(title: nil, message: "Please enter password", preferredStyle: .alert)
            passwordAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(passwordAlert, animated: true, completion: nil)
            return
        }
        
        if !isPasswordValid(password) {
            let invalidPasswordAlert = UIAlertController(title: nil, message: "Password must contain at least one uppercase letter, one lowercase letter, one symbol, and one number. It should be at least 7 characters long.", preferredStyle: .alert)
            invalidPasswordAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(invalidPasswordAlert, animated: true, completion: nil)
            return
        }
        
        // Password is valid, continue with login process
        // ...
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == Username {
            Password.becomeFirstResponder()
        } else if textField == Password {
            textField.resignFirstResponder()
            EnterButton(self)
        }
        return true
    }

    // Helper method to validate password
    func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{7,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
}

