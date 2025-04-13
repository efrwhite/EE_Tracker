//
//  nodietplanviewcontroller.swift
//  Testing_Ground
//
//  Created by Brianna Boston on 4/11/25.
//

import Foundation
import UIKit
import CoreData

class nodietplanviewcontroller: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dietEntries: [String] = [] // Replace with your Diet model if needed
    var childName = ""
    var user = ""
    let tableView = UITableView()
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "No Diet, Go to profiles page to set your diet."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupTableView()
        setupPlaceholderLabel()
        loadDietData()
    }

    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DietCell")
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func setupPlaceholderLabel() {
        view.addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func loadDietData() {
        // Load dietEntries from Core Data or other source
        // For now, it's just an empty array for the placeholder example
        dietEntries = [] // Load your actual data here

        placeholderLabel.isHidden = !dietEntries.isEmpty
        tableView.reloadData()
    }

    // MARK: - UITableView DataSource Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dietEntries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DietCell", for: indexPath)
        cell.textLabel?.text = dietEntries[indexPath.row]
        return cell
    }

    // MARK: - UITableView Delegate (optional)

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle selection
    }
}
