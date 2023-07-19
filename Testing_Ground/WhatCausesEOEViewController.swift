//
//  WhatCausesEOEViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 7/17/23.
//

import Foundation
import UIKit

class WhatCausesEOEViewController: UIViewController {
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
        headlineLabel.text = "What Causes EOE?"
        headlineLabel.font = UIFont.boldSystemFont(ofSize: 18)
        borderView.addSubview(headlineLabel)
        
        // Create and configure the affected text label
        let affectedLabel = UILabel()
        affectedLabel.translatesAutoresizingMaskIntoConstraints = false
        affectedLabel.numberOfLines = 0
        affectedLabel.textAlignment = .center
        affectedLabel.text = """
            This condition is usually caused by an immune response to food ingestion. However, the relationship between food allergy and EoE is complex. Unlike many well known food allergens which causes symptoms right after exposure such as hives, lip swelling, vomiting and breathing issues, the EoE allergen induced reactions are often delayed, and can develop over several days making it difficult to pinpoint the specific food allergen. Environmental allergies to substances like pollen, dust, mold and animals also appear to play a role in triggering EoE and exacerbating EoE symptoms.
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


