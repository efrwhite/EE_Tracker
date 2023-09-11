//
//  WhatIsEOEViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 7/17/23.
//  Editted By Brianna Boston on Sept 10th
//
import Foundation
import UIKit

class WhatIsEOEViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var label1: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label1.text = """
            Eosinophilic esophagitis (EoE), also known as allergic esophagitis, is a chronic immune system disease where a white blood cell called eosinophil builds up in the lining of the tube (esophagus) that connects your mouth to your stomach. These eosinophils can release chemicals into the surrounding tissues that cause inflammation.
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


