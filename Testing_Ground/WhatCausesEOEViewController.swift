//
//  WhatCausesEOEViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 7/17/23.
//

import Foundation
import UIKit

class WhatCausesEOEViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var label1: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        label1.text = """
                    This condition is usually caused by an immune response to food ingestion. However, the relationship between food allergy and EoE is complex. Unlike many well known food allergens which causes symptoms right after exposure such as hives, lip swelling, vomiting and breathing issues, the EoE allergen induced reactions are often delayed, and can develop over several days making it difficult to pinpoint the specific food allergen. Environmental allergies to substances like pollen, dust, mold and animals also appear to play a role in triggering EoE and exacerbating EoE symptoms.
        """
        
      
        // Set the label's text to wrap and display the full content
        label1.numberOfLines = 0
        label1.lineBreakMode = .byWordWrapping
        
        // Update the label's frame and size it to fit its content
        label1.sizeToFit()
        
        // Add the label to the scrollView's content view
        scrollView.addSubview(label1)
        
        // Update the scrollView's contentSize to fit the label's frame
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: label1.frame.size.height)
        
    
    }
    

    }


