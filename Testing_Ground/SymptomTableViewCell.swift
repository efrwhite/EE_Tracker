//
//  SymTableViewCell.swift
//  Testing_Ground
//
//  Created by Brianna Boston on 6/7/23.
//

import UIKit

class SymTableViewCell: UITableViewCell {

    @IBOutlet weak var questionlabel: UILabel!
    @IBOutlet weak var ratingtext: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
