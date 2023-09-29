//
//  MoreInfoViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 7/10/23.
//

import Foundation
import UIKit

class MoreInfoViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let naspghanButton = UIButton(type: .system)
        naspghanButton.backgroundColor = UIColor(red: 57.0/255.0, green: 67.0/255.0, blue: 144.0/255.0, alpha: 1)
        naspghanButton.setTitle("NASPGHAN", for: .normal)
        naspghanButton.setTitleColor(UIColor.white, for: .normal)
        naspghanButton.titleLabel?.font = UIFont(name: "Lato", size: 17.0)
        naspghanButton.layer.cornerRadius = 10 // Adjust as needed
        naspghanButton.addTarget(self, action: #selector(openNASPGHANWebsite), for: .touchUpInside)
        
        let aaaaiButton = UIButton(type: .system)
        aaaaiButton.backgroundColor = UIColor(red: 57.0/255.0, green: 67.0/255.0, blue: 144.0/255.0, alpha: 1)
        aaaaiButton.setTitle("AAAI", for: .normal)
        aaaaiButton.setTitleColor(UIColor.white, for: .normal)
        aaaaiButton.titleLabel?.font = UIFont(name: "Lato", size: 17.0)
        aaaaiButton.layer.cornerRadius = 10 // Adjust as needed
        aaaaiButton.addTarget(self, action: #selector(openAAAIIWebsite), for: .touchUpInside)
        
        let apfedButton = UIButton(type: .system)
        apfedButton.backgroundColor = UIColor(red: 57.0/255.0, green: 67.0/255.0, blue: 144.0/255.0, alpha: 1)
        apfedButton.setTitle("APFED", for: .normal)
        apfedButton.setTitleColor(UIColor.white, for: .normal)
        apfedButton.titleLabel?.font = UIFont(name: "Lato", size: 17.0)
        apfedButton.layer.cornerRadius = 10 // Adjust as needed
        apfedButton.addTarget(self, action: #selector(openAPFEDWebsite), for: .touchUpInside)
        
        let infoLabel = UILabel()
        infoLabel.text = "Click the above buttons for more information about EoE. The first button takes you to the North American Society for Pediatric Gastroenterology, Hepatology, and Nutrition website, where you can learn more about other relating diseases to EoE. The second button takes you to the American Academy of Allergy, Asthma & Immunology website, where you can learn about allergies, allergists, immunology, and immune deficiency disorders. The third button takes you to the American Partnership for Eosinophilic Disorders website, where you can learn about other eosinophilic diseases as well as EoE."
        infoLabel.textColor = UIColor(red: 57.0/255.0, green: 67.0/255.0, blue: 144.0/255.0, alpha: 1)
        infoLabel.font = UIFont(name: "Times New Roman", size: 20.0)
        infoLabel.numberOfLines = 0
        infoLabel.lineBreakMode = .byWordWrapping
        
        self.view.addSubview(naspghanButton)
        self.view.addSubview(aaaaiButton)
        self.view.addSubview(apfedButton)
        self.view.addSubview(infoLabel)
        
        // Set Constraints for Buttons
        naspghanButton.translatesAutoresizingMaskIntoConstraints = false
        aaaaiButton.translatesAutoresizingMaskIntoConstraints = false
        apfedButton.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // NASPGHAN Button Constraints
            naspghanButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0),
            naspghanButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            naspghanButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            naspghanButton.heightAnchor.constraint(equalToConstant: 50.0),
            
            // AAAAI Button Constraints
            aaaaiButton.topAnchor.constraint(equalTo: naspghanButton.bottomAnchor, constant: 20.0),
            aaaaiButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            aaaaiButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            aaaaiButton.heightAnchor.constraint(equalToConstant: 50.0),
            
            // APFED Button Constraints
            apfedButton.topAnchor.constraint(equalTo: aaaaiButton.bottomAnchor, constant: 20.0),
            apfedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            apfedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            apfedButton.heightAnchor.constraint(equalToConstant: 50.0),
            
            // Label Constraints
            infoLabel.topAnchor.constraint(equalTo: apfedButton.bottomAnchor, constant: 50.0), // Adjust the constant to move the label down
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
        ])
    }
    //Links functions
    @objc func openNASPGHANWebsite() {
        if let url = URL(string: "https://naspghan.org") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func openAAAIIWebsite() {
        if let url = URL(string: "http://www.aaaai.org") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func openAPFEDWebsite() {
        if let url = URL(string: "http://www.apfed.org") {
            UIApplication.shared.open(url)
        }
    }
}
