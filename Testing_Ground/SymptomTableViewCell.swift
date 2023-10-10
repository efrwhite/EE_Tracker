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
        }

    }
    
    func setupTextField() {
        Ratingtext.isHidden = false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, let indexPath = indexPath {
            delegate?.didEditTextField(text, atIndexPath: indexPath)
        }
    }
}
