//
//  Diet4ViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 7/7/23.
//

import Foundation
import UIKit

class Diet4ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
    }
    
    private func setupScene() {
        
        
        // Create and configure the header label
        let headerLabel = UILabel()
        headerLabel.text = "Diet 4"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 24)
        headerLabel.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
        headerLabel.textAlignment = .center
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerLabel)
        
        // Create and configure the diet label
        let dietLabel = UILabel()
        dietLabel.text = "Dairy, Gluten, Soy, Egg"
        dietLabel.font = UIFont.systemFont(ofSize: 18)
        dietLabel.textColor = UIColor.blue
        dietLabel.textAlignment = .center
        dietLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(dietLabel)
        
        // Create and configure the description label
        let descriptionLabel = UILabel()
        descriptionLabel.text = """
        This is a longer description of the diet.

        Eosinophilic Esophagitis (EoE) is a chronic immune system disease that affects the esophagus. There are several diet types that can help manage EoE, including:

        - Elimination Diet: Removing specific food triggers from the diet.
        - Elemental Diet: Consuming a specialized amino acid-based formula.
        - Six Food Elimination Diet: Avoiding milk, soy, wheat, egg, peanut, and seafood.

        It's important to work with a healthcare professional to determine the most suitable diet plan for managing EoE.
        """
        descriptionLabel.font = UIFont.systemFont(ofSize: 20)
        descriptionLabel.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0) // Updated color
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(descriptionLabel)
        
        // Add constraints for the labels
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            dietLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10),
            dietLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dietLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: dietLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20)
        ])
    }
    
}
