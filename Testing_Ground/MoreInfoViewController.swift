//
//  MoreInfoViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 7/10/23.
//

import Foundation
import UIKit

class MoreInfoViewController: UIViewController {
    
    
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        


        
//        let attributedText = NSMutableAttributedString(string: """
//                    The following links will take you to additional resources for EoE.
//
//                    North American Society For Pediatric Gastroenterology, Hepatology & Nutrition (NASPGHAN)
//
//                        link1
//
//                    American Academy of Allergy, Asthma & Immunology
//                        link2
//
//                    American Partnership for Eosinophilic Disorders
//                        link3
//
//                    """)
//
//
//                // NASPGHAN link
//                let naspghanLink = URL(string: "https://naspghan.org")!
//
//
//                // aaaai.org link
//                let aaaaiLink = URL(string: "http://www.aaaai.org")!
//
//                // apfed.org link
//                let apfedLink = URL(string: "http://www.apfed.org")!
        let attributedString = NSMutableAttributedString(string: "North American Society For Pediatric Gastroenterology, Hepatology & Nutrition (NASPGHAN)")
        let url = URL(string: "https://naspghan.org")!

  
        
    }
    
    

}
