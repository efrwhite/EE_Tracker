import Foundation
import UIKit
import CoreData

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var PasswordRequirements: UILabel!
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Mobile: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var ConfirmPassword: UITextField!
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var receivedString = ""
    var parents = [Parent]()
    var seguePerformed = false // Flag to track whether the segue has been performed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the text of the PasswordRequirements label
        PasswordRequirements.text = "Password Requirements:\n- 7 Characters long\n- 1 Capital letter\n- 1 Symbol !@#$\n- 1 Number"
        
        // Allow label to wrap to multiple lines
        PasswordRequirements.numberOfLines = 0
        PasswordRequirements.lineBreakMode = .byWordWrapping
        
        // Calculate the required size for the label
        let requiredSize = PasswordRequirements.sizeThatFits(CGSize(width: PasswordRequirements.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        
        // Update the label's frame to fit the content
        PasswordRequirements.frame = CGRect(origin: PasswordRequirements.frame.origin, size: requiredSize)
        
        // Set delegates for other text fields
        Password.delegate = self
        Username.delegate = self
        Mobile.delegate = self
        ConfirmPassword.delegate = self
        Email.delegate = self
        receivedString = Username.text!
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
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
        else {
            // Saving Account Information in CoreData
            let newAccount = Parent(context: self.context)
            newAccount.username = Username.text!
            newAccount.phone = Mobile.text!
            newAccount.email = Email.text!
            newAccount.password = Password.text!
            self.parents.append(newAccount)
            self.SaveItems()
            
            if !seguePerformed {
                // Perform the segue only if it hasn't been performed already
                seguePerformed = true
                receivedString = Username.text!
                //performSegue(withIdentifier: "parentSegue", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "parentSegue", let displayVC = segue.destination as? ParentViewController {
            displayVC.user = receivedString
        }
    }
    // Enter dismisses keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // dismiss Keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func SaveItems(){
        do {
            try context.save()
        }
        catch {
            print("Error Saving")
        }
    }
}

