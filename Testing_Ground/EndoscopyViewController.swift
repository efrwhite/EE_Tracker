//
//  EndoscopyViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 11/15/23.
//

import Foundation
import UIKit

class EndoscopyViewController: UIViewController {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Endoscopy Results"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let eoELabel: UILabel = {
        let label = UILabel()
        label.text = "EoE"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let proximateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "#input"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let middleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "#input"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let lowerTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "#input"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let stomachLabel: UILabel = {
        let label = UILabel()
        label.text = "Stomach:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let stomachTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "#input"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let duodenumLabel: UILabel = {
        let label = UILabel()
        label.text = "Duodenum:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let duodenumTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "#input"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let colonLabel: UILabel = {
        let label = UILabel()
        label.text = "Colon"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let rightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "#input"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let middleColonTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "#input"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let leftTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "#input"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 57.0/255.0, green: 67.0/255.0, blue: 144.0/255.0, alpha: 1)

        // Add subviews
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        view.addSubview(eoELabel)
        view.addSubview(proximateTextField)
        view.addSubview(middleTextField)
        view.addSubview(lowerTextField)
        view.addSubview(stomachLabel)
        view.addSubview(stomachTextField)
        view.addSubview(duodenumLabel)
        view.addSubview(duodenumTextField)
        view.addSubview(colonLabel)
        view.addSubview(rightTextField)
        view.addSubview(middleColonTextField)
        view.addSubview(leftTextField)

        // Set constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            eoELabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            eoELabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            proximateTextField.topAnchor.constraint(equalTo: eoELabel.bottomAnchor, constant: 8),
            proximateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            proximateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            middleTextField.topAnchor.constraint(equalTo: proximateTextField.bottomAnchor, constant: 8),
            middleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            middleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            lowerTextField.topAnchor.constraint(equalTo: middleTextField.bottomAnchor, constant: 8),
            lowerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lowerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            stomachLabel.topAnchor.constraint(equalTo: lowerTextField.bottomAnchor, constant: 20),
            stomachLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            stomachTextField.topAnchor.constraint(equalTo: stomachLabel.bottomAnchor, constant: 8),
            stomachTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stomachTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            duodenumLabel.topAnchor.constraint(equalTo: stomachTextField.bottomAnchor, constant: 20),
            duodenumLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            duodenumTextField.topAnchor.constraint(equalTo: duodenumLabel.bottomAnchor, constant: 8),
            duodenumTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            duodenumTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            colonLabel.topAnchor.constraint(equalTo: duodenumTextField.bottomAnchor, constant: 20),
            colonLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            rightTextField.topAnchor.constraint(equalTo: colonLabel.bottomAnchor, constant: 8),
            rightTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            rightTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            middleColonTextField.topAnchor.constraint(equalTo: rightTextField.bottomAnchor, constant: 8),
            middleColonTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            middleColonTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            leftTextField.topAnchor.constraint(equalTo: middleColonTextField.bottomAnchor, constant: 8),
            leftTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            leftTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
}

