//
//  WhatAreSymptomsViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 7/17/23.
//

import Foundation
import UIKit

class WhatAreSymptomsViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var label1: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       label1.text = """
           Patients with EoE can experience several symptoms including difficulty in swallowing, choking, food getting stuck in the esophagus and symptoms of gastroesophageal reflux such as vomiting, heartburn and regurgitation. Infants and young children may present with food refusal and poor weight gain and growth.
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

