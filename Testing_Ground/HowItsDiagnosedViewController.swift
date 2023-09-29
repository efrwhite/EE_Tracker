//
//  HowItsDiagnosedViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 7/17/23.
//

import UIKit

class HowItsDiagnosedViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        
        // Set the font size to 20.0
        label1.font = UIFont.systemFont(ofSize: 20.0)
        
        label1.text = """
            EoE is diagnosed by performing an upper endoscopy with biopsies. Upper endoscopy is a medical procedure where a flexible tube with a light and camera at the tip is passed through the mouth into the esophagus. This procedure will help visualize the lining of the esophagus and also let your doctor take small tissue samples from the lining of the esophagus to examine under the microscope for the presence of eosinophils. In an unaffected individual, there are no eosinophils in the esophagus, but in patients with EoE, the tissue samples may show numerous eosinophils and signs of inflammation.
            """
        
        // Set the label's text to wrap and display the full content
        label1.numberOfLines = 0
        label1.lineBreakMode = .byWordWrapping
        
        // Add the label and image to the scrollView's content view
        scrollView.addSubview(label1)
        scrollView.addSubview(imageView)
        
        // Set constraints for the label and image
        label1.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Label constraints
            label1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.0),
            label1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16.0),
            label1.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.0),
            label1.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32.0), // Adjust the constant as needed
            
            // Image constraints (adjust these as needed)
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.0),
            imageView.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 16.0),
            imageView.widthAnchor.constraint(equalToConstant: 200.0), // Adjust the width
            imageView.heightAnchor.constraint(equalToConstant: 200.0), // Adjust the height
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16.0),
        ])
        
        // Update the scrollView's contentSize to fit the label's frame and image
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: label1.frame.size.height + imageView.frame.size.height + 32.0) // Adjust the padding as needed
    }
}
