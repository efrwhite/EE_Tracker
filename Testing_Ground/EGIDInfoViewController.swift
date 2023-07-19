//
//  EGIDInfoViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 7/17/23.
//

import Foundation
import UIKit

class EGIDInfoViewController: UIViewController {
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
        headlineLabel.text = "EGID Information"
        headlineLabel.font = UIFont.boldSystemFont(ofSize: 18)
        borderView.addSubview(headlineLabel)
        
        // Create and configure the affected text label
        let affectedLabel = UILabel()
        affectedLabel.translatesAutoresizingMaskIntoConstraints = false
        affectedLabel.numberOfLines = 0
        affectedLabel.textAlignment = .center
        affectedLabel.text = """
            **Waiting on information from Naren
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

