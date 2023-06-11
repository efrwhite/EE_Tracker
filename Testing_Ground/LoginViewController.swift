//
//  ViewController.swift
//  EOEPractice
//
//  Created by Brianna Boston on 5/19/23.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

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
        if (username.isEmpty){
            let usernamealert = UIAlertController(title: nil, message: "Please enter username", preferredStyle: UIAlertController.Style.alert)
            usernamealert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
               self.present(usernamealert, animated: true, completion: nil)
           }
        
        // empty password alert
        if (password.isEmpty) {
               let passwordalert = UIAlertController(title: nil, message: "Please enter password", preferredStyle: UIAlertController.Style.alert)
               passwordalert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                   self.present(passwordalert, animated: true, completion: nil)
           }
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
    
}

