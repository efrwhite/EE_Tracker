//
//  QualityofLifeTableViewCell.swift
//  Testing_Ground
//
//  Created by Brianna Boston on 6/9/23.
//

import UIKit

class QualityofLifeTableViewCell: UITableViewCell {

    @IBOutlet weak var pickers: UIPickerView!
    @IBOutlet weak var questionlabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
