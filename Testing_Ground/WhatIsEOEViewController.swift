//
//  WhatIsEOEViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 7/17/23.
//

import Foundation
import UIKit

class WhatIsEOEViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a border around the entire screen
        let borderView = UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.layer.borderWidth = 1.0
        borderView.layer.borderColor = UIColor.black.cgColor
        view.addSubview(borderView)
        
        // Create and configure the headline label
        let headlineLabel = UILabel()
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        headlineLabel.text = "What Is EOE?"
        headlineLabel.font = UIFont.boldSystemFont(ofSize: 18)
        borderView.addSubview(headlineLabel)
        
        // Create and configure the affected text label
        let affectedLabel = UILabel()
        affectedLabel.translatesAutoresizingMaskIntoConstraints = false
        affectedLabel.numberOfLines = 0
        affectedLabel.textAlignment = .center
        affectedLabel.text = """
            Eosinophilic esophagitis (EoE), also known as allergic esophagitis is a chronic immune system disease where a white blood cell called Eosinophil builds up in the lining of the tube (Esophagus) that connects your mouth to your stomach. These eosinophils can release chemicals into the surrounding tissues that cause inflammation.
            """
        borderView.addSubview(affectedLabel)
        

        
        // Set up constraints
        
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            borderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            borderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            borderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            headlineLabel.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
            headlineLabel.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 20),
            
            affectedLabel.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 20),
            affectedLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -20),
            affectedLabel.centerYAnchor.constraint(equalTo: borderView.centerYAnchor),
                    ])
    }
    

    }

