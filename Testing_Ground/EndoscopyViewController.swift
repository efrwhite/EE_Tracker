//
//  EndoscopyViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 1/29/24.
//

import Foundation
import UIKit

class EndoscopyViewController: UIViewController {
    
    // MARK: - Properties
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Endoscopy Results"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date:"
        label.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
        return label
    }()
    
    let eoELabel: UILabel = {
        let label = UILabel()
        label.text = "EoE"
        label.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
        return label
    }()
    
    let proximateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "#input"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let middleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "#input"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let lowerTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "#input"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let stomachLabel: UILabel = {
        let label = UILabel()
        label.text = "Stomach"
        label.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
        return label
    }()
    
    let stomachTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "#input"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let duodenumLabel: UILabel = {
        let label = UILabel()
        label.text = "Duodenum"
        label.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
        return label
    }()
    
    let duodenumTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "#input"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let colonLabel: UILabel = {
        let label = UILabel()
        label.text = "Colon"
        label.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
        return label
    }()
    
    let rightColonTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Right: #input"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let middleColonTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Middle: #input"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let leftColonTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Left: #input"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(dateLabel)
        mainStackView.addArrangedSubview(eoELabel)
        mainStackView.addArrangedSubview(proximateTextField)
        mainStackView.addArrangedSubview(middleTextField)
        mainStackView.addArrangedSubview(lowerTextField)
        mainStackView.addArrangedSubview(stomachLabel)
        mainStackView.addArrangedSubview(stomachTextField)
        mainStackView.addArrangedSubview(duodenumLabel)
        mainStackView.addArrangedSubview(duodenumTextField)
        mainStackView.addArrangedSubview(colonLabel)
        mainStackView.addArrangedSubview(rightColonTextField)
        mainStackView.addArrangedSubview(middleColonTextField)
        mainStackView.addArrangedSubview(leftColonTextField)
        mainStackView.addArrangedSubview(saveButton)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Button Action
    
    @objc func saveButtonTapped() {
        // Handle save button action
    }
}


