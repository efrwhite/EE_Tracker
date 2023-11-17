//
//  AccidentalExposureViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 11/15/23.
//

import Foundation
import UIKit

class AccidentalExposureViewController: UIViewController {

    // Top view UI elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Accidental Exposure"
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

    let dateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Select Date"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let itemExposedLabel: UILabel = {
        let label = UILabel()
        label.text = "Item Exposed To:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let itemExposedTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Item"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    // Bottom view UI elements
    let historyLabel: UILabel = {
        let label = UILabel()
        label.text = "Accidental Exposure History"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let historyTableView: UITableView = {
        let tableView = UITableView()
        // Additional setup for your table view (e.g., registering cells)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        // Add subviews
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        view.addSubview(dateTextField)
        view.addSubview(itemExposedLabel)
        view.addSubview(itemExposedTextField)
        view.addSubview(historyLabel)
        view.addSubview(historyTableView)

        // Set constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            dateTextField.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            dateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            itemExposedLabel.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 20),
            itemExposedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            itemExposedTextField.topAnchor.constraint(equalTo: itemExposedLabel.bottomAnchor, constant: 8),
            itemExposedTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            itemExposedTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            historyLabel.topAnchor.constraint(equalTo: itemExposedTextField.bottomAnchor, constant: 20),
            historyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            historyTableView.topAnchor.constraint(equalTo: historyLabel.bottomAnchor, constant: 8),
            historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            historyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])

        // Additional setup for the table view (e.g., setting delegate and data source)
    }
}

