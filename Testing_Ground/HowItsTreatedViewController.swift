//
//  HowItsTreatedViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 7/17/23.
//

import Foundation
import UIKit

class HowItsTreatedViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var label1: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        label1.text = """
                    There are three main types of treatments available for EoE (as below). Please consult your doctor for a detailed discussion on these options and see what works best for you and your family a. Empiric food elimination  b. Medical therapy  c. Elemental diet
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
