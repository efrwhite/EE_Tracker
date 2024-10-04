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

        if let ratingText = Ratingtext {
            ratingText.delegate = self
            ratingText.keyboardType = .numberPad
            ratingText.font = UIFont.systemFont(ofSize: 17)
            ratingText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }

        if let questionLbl = questionLabel {
            questionLbl.font = UIFont.systemFont(ofSize: 14)
        }
    }
    
    func configureCell(for section: Int) {
        Ratingtext.isHidden = section != 0
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, let indexPath = indexPath {
            delegate?.didEditTextField(text, atIndexPath: indexPath)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, let indexPath = indexPath {
            let validatedText = validateInput(text: text)
            textField.text = validatedText
            delegate?.didEditTextField(validatedText, atIndexPath: indexPath)
        }
    }

    private func validateInput(text: String) -> String {
        guard let number = Int(text) else { return "" }
        return (0...5).contains(number) ? text : ""
    }
}
