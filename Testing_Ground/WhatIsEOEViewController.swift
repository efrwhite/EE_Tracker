//
//  WhatIsEOEViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 7/17/23.
//  Editted By Brianna Boston on Sept 10th
//
import UIKit

class WhatIsEOEViewController: UIViewController {
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set the font size to 20.0
        label1.font = UIFont.systemFont(ofSize: 20.0)
        
        label1.text = """
            Eosinophilic esophagitis (EoE), also known as allergic esophagitis, is a chronic immune system disease where a white blood cell called eosinophil builds up in the lining of the tube (esophagus) that connects your mouth to your stomach. These eosinophils can release chemicals into the surrounding tissues that cause inflammation.
        """
        
        // Set the label's text to wrap and display the full content
        label1.numberOfLines = 0
        label1.lineBreakMode = .byWordWrapping
        
        // Center the label text horizontally
        label1.textAlignment = .center
        
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
            label1.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor), // Center horizontally
        ])
        
        // Update the scrollView's contentSize to fit the label's frame
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: label1.frame.size.height + 32.0) // Adjust the padding as needed
    }
}
