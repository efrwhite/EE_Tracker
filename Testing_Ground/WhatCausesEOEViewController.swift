//
//  WhatCausesEOEViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 7/17/23.
//

import UIKit

class WhatCausesEOEViewController: UIViewController {
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the font size to 20.0
        label1.font = UIFont.systemFont(ofSize: 20.0)
        
        label1.text = """
            This condition is usually caused by an immune response to food ingestion. However, the relationship between food allergy and EoE is complex. Unlike many well-known food allergens that cause symptoms right after exposure such as hives, lip swelling, vomiting, and breathing issues, the EoE allergen-induced reactions are often delayed, and can develop over several days making it difficult to pinpoint the specific food allergen. Environmental allergies to substances like pollen, dust, mold, and animals also appear to play a role in triggering EoE and exacerbating EoE symptoms.
        """
        
        // Set the label's text to wrap and display the full content
        label1.numberOfLines = 0
        label1.lineBreakMode = .byWordWrapping
        
        // Set text alignment to left
        label1.textAlignment = .left
        
        // Update the label's frame and size it to fit its content
        label1.sizeToFit()
        
        // Add the label to the scrollView's content view
        scrollView.addSubview(label1)
        
        // Set constraints for the label
        label1.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Label constraints
            label1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.0),
            label1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16.0),
            label1.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.0),
            label1.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32.0), // Adjust the constant as needed
        ])
        
        // Update the scrollView's contentSize to fit the label's frame
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: label1.frame.size.height + 32.0) // Adjust the padding as needed
    }
}
