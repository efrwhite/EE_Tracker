import Foundation
import UIKit
import CoreData

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Mobile: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var ConfirmPassword: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var receivedString = ""
    var parents = [Parent]()
    var seguePerformed = false // Flag to track whether the segue has been performed
    
    var originalY: CGFloat = 0.0 // Store the original Y position of the view

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Store the original Y position of the view
        originalY = self.view.frame.origin.y
        
        // Add a tap gesture recognizer to dismiss the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        // Add observers for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        receivedString = Username.text!
    }
    
    deinit {
        // Remove observers when the view controller is deallocated
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func EnterButton(_ sender: Any) {
        let username = Username.text ?? ""
        let password = Password.text ?? ""
        let userPhone = Mobile.text ?? ""
        let emails = Email.text ?? ""
        let confirmPassword = ConfirmPassword.text ?? ""
        
        if(username.isEmpty || userPhone.isEmpty || password.isEmpty || confirmPassword.isEmpty || emails.isEmpty) {
            
            let alertController = UIAlertController(title: "Incomplete Form", message: "Please complete the sign-up form", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "OK", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                print("cancel alert")
            })
            alertController.addAction(confirmAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
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
            print("SignUP", receivedString)
            displayVC.usernamesup = Username.text!
        }
    }
    
    // Enter dismisses keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Dismiss keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let keyboardHeight = keyboardFrame.height
        
        // Only move the view if it's not already moved up
        if self.view.frame.origin.y == originalY {
            UIView.animate(withDuration: duration) {
                self.view.frame.origin.y = self.originalY - keyboardHeight / 2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        // Reset the view position when the keyboard hides
        UIView.animate(withDuration: duration) {
            self.view.frame.origin.y = self.originalY
        }
    }
    
    func SaveItems() {
        do {
            try context.save()
        } catch {
            print("Error Saving")
        }
    }
}
