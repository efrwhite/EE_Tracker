//
//  MoreInfoViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 7/10/23.
//

import Foundation
import UIKit

class MoreInfoViewController: UIViewController {
    // Declare the affected label as a class-level property
    var affectedLabel: UILabel!
    
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
        headlineLabel.text = "Where Can I Find More Information?"
        headlineLabel.font = UIFont.boldSystemFont(ofSize: 18)
        borderView.addSubview(headlineLabel)
        
        // Create and configure the affected text label
        affectedLabel = UILabel() // Remove the "let" keyword here
        affectedLabel.translatesAutoresizingMaskIntoConstraints = false
        affectedLabel.numberOfLines = 0
        affectedLabel.textAlignment = .center
        
        let attributedText = NSMutableAttributedString(string: """
                    The following links will take you to additional resources for EoE.

                    North American Society For Pediatric Gastroenterology, Hepatology & Nutrition (NASPGHAN)

                    NASPGHAN - Home

                    American Academy of Allergy, Asthma & Immunology

                    www.aaaai.org
                    
                    American Partnership for Eosinophilic Disorders

                    www.apfed.org

                    
                    """)

                // Set link attributes to make the text appear as clickable links
                let linkAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.blue,
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ]
                
                // NASPGHAN link
                let naspghanLink = URL(string: "https://naspghan.org")!
                attributedText.setAttributes(linkAttributes, range: NSRange(location: 94, length: 22))
                attributedText.addAttribute(.link, value: naspghanLink, range: NSRange(location: 94, length: 22))
                
                // aaaai.org link
                let aaaaiLink = URL(string: "http://www.aaaai.org")!
                attributedText.setAttributes(linkAttributes, range: NSRange(location: 177, length: 14))
                attributedText.addAttribute(.link, value: aaaaiLink, range: NSRange(location: 177, length: 14))

                // apfed.org link
                let apfedLink = URL(string: "http://www.apfed.org")!
                attributedText.setAttributes(linkAttributes, range: NSRange(location: 245, length: 14))
                attributedText.addAttribute(.link, value: apfedLink, range: NSRange(location: 245, length: 14))

                affectedLabel.attributedText = attributedText

        
        borderView.addSubview(affectedLabel)
        
        
       
        
        // Make links clickable
        affectedLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openLink(_:)))
        affectedLabel.addGestureRecognizer(tapGesture)
        
        
        // Set up constraints
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            borderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            borderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            borderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            headlineLabel.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
            headlineLabel.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 20),
            
            affectedLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 20),
            affectedLabel.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 20),
            affectedLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -20),
            
        ])
    }
    
    
    @objc func openLink(_ sender: UITapGestureRecognizer) {
        guard let text = affectedLabel.text else { return }
        let types: NSTextCheckingResult.CheckingType = .link
        let detector = try? NSDataDetector(types: types.rawValue)
        detector?.enumerateMatches(in: text, range: NSRange(text.startIndex..., in: text), using: { (result, _, _) in
            if let url = result?.url {
                UIApplication.shared.open(url)
            }
        })
    }
}
