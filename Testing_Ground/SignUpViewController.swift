//
//  SignUpViewController.swift
//  EOEPractice
//
//  Created by Brianna Boston on 5/22/23.
//

import Foundation
import UIKit
import CoreData
class SignUpViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Mobile: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var ConfirmPassword: UITextField!
//    var Accounts = [Account]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Password.delegate = self
        Username.delegate = self
        Mobile.delegate = self
        ConfirmPassword.delegate = self
        Email.delegate = self
    }
    @IBAction func EnterButton(_ sender: Any) {
        let username = Username.text ?? ""
        let password = Password.text ?? ""
        let userPhone = Mobile.text ?? ""
        let emails = Email.text ?? ""
        let confirmPassword = ConfirmPassword.text ?? ""
        if(username.isEmpty || userPhone.isEmpty || password.isEmpty || confirmPassword.isEmpty || emails.isEmpty){
           
            let alertController = UIAlertController(title: "Incomplete Form", message: "Please complete the sign-up form", preferredStyle: .alert)

            let confirmAction = UIAlertAction(title: "OK", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                print("cancel alert")
            })
            alertController.addAction(confirmAction)

            present(alertController, animated: true, completion: nil)

        }
        else{
            //Saving Account Information in CoreData
//            let newAccount = Account(context: self.context)
//            newAccount.username = Username.text!
//            newAccount.phone = Mobile.text!
//            newAccount.email = Email.text!
//            newAccount.password = Password.text!
//            self.Accounts.append(newAccount)
//            self.SaveItems()
        }
    }
   
    func SaveItems(){
        do {
            try context.save()
        }
        catch{
            print("Error Saving")
        }
    }
    
}

