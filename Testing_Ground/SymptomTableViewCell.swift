import UIKit

protocol SymTableViewCellDelegate: AnyObject {
    func didEditTextField(_ text: String, atIndexPath indexPath: IndexPath)
}

class SymTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var Ratingtext: UITextField!
    
    weak var delegate: SymTableViewCellDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Safely unwrap Ratingtext and set its properties
        if let ratingText = Ratingtext {
            ratingText.delegate = self
            ratingText.keyboardType = .numberPad
            ratingText.font = UIFont.systemFont(ofSize: 17)
        }

        // Set font size
        if let questionLbl = questionLabel {
            questionLbl.font = UIFont.systemFont(ofSize: 14)
        }
    }   


    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, let indexPath = indexPath {
            let validatedText = validateInput(text: text, section: indexPath.section)
            textField.text = validatedText
            delegate?.didEditTextField(validatedText, atIndexPath: indexPath)
        }
    }

    private func validateInput(text: String, section: Int) -> String {
        guard let number = Int(text) else { return "" }

        if section == 0 {
            return (0...5).contains(number) ? text : ""
        } else if section == 1 {
            return (0...1).contains(number) ? text : ""
        }

        return ""
    }
}
