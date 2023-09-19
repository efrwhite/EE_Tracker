//
//  HowItsDiagnosedViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 7/17/23.
//

import Foundation
import UIKit

class HowItsDiagnosedViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var label1: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label1.text = """
            EoE is diagnosed by performing an upper endoscopy with biopsies. Upper endoscopy is a medical procedure where a flexible tube with a light and camera at the tip is passed through the mouth into the esophagus. This procedure will help visualize the lining of the esophagus and also let your doctor take small tissue samples from the lining of the esophagus to examine under microscope for the presence of eosinophils. In an unaffected individual, there are no eosinophils in the esophagus but in patients with EoE, the tissue samples may show numerous eosinophils and signs of inflammation.
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

