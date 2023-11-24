import Foundation
import UIKit
import CoreData

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
//Something is wrong here with username and password not syncing LOOK INTO LOGIN TOO
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
       // NSLog(@"Session ID in viewDidLoad: %@", mySessionID);
        // Add a tap gesture recognizer to dismiss the keyboard
          let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
          tapGesture.cancelsTouchesInView = false
          view.addGestureRecognizer(tapGesture)
        receivedString = Username.text!
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
            print("SignUP",receivedString)
            displayVC.usernamesup = Username.text!
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

