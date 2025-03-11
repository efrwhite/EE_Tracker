//
//  Diet2TestViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 9/26/24.
//

import Foundation
import UIKit

class Diet2TestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user: String?
    var childName: String?
    
    // Declare the table view
    let tableView = UITableView()
    
    // Foods data source
    var foods = [
        "FOODS THAT MAY CONTAIN DAIRY:",
        "Baked goods",
        "Butter",
        "Buttermilk",
        "Casein",
        "Cheese",
        "Chocolate",
        "Condensed milk",
        "Cottage cheese",
        "Cream",
        "Cream cheese",
        "Curd",
        "Custard",
        "Evaporated milk",
        "Ghee",
        "Goat’s milk",
        "Gravy",
        "Half & half",
        "Ice cream",
        "Lactose",
        "Margarine",
        "Milk",
        "Milk powder",
        "Pastries",
        "Pudding",
        "Salad dressing",
        "Sheep’s milk",
        "Sour cream",
        "Whey",
        "Yogurt",
        "FOODS THAT MAY CONTAIN GLUTEN:",
        "Bread and bread products",
                    "Bagels",
                    "Baked goods",
                    "Barley",
                    "Battered and fried foods",
                    "Bran",
                    "Bulgur",
                    "Cereal",
                    "Couscous",
                    "Crackers",
                    "Durum",
                    "Einkorn",
                    "English muffins",
                    "Farina",
                    "Farro",
                    "Flour",
                    "Flour tortillas",
                    "Gravy or sauces containing a roux",
                    "Licorice",
                    "Naan",
                    "Oats",
                    "Pasta",
                    "Pancakes",
                    "Pastries",
                    "Pita",
                    "Rye",
                    "Sauces",
                    "Semolina",
                    "Spelt",
                    "Soy sauce",
                    "Triticale",
                    "Waffles",
                    "Wheat"
]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up navigation bar
        navigationItem.title = "Diet 2"
        //navigationController?.navigationBar.prefersLargeTitles = true
        
        // Add plus button to navigation bar
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFood))
        navigationItem.rightBarButtonItem = addButton
        
        // Create and configure scroll view
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Create and configure the 'Foods Not Okay to Eat' label
        let foodsNotOkayLabel = UILabel()
        foodsNotOkayLabel.text = "Foods Not Okay to Eat"
        foodsNotOkayLabel.font = UIFont(name: "Times New Roman", size: 17)
        foodsNotOkayLabel.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
        foodsNotOkayLabel.textAlignment = .center
        foodsNotOkayLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(foodsNotOkayLabel)
        
        NSLayoutConstraint.activate([
            foodsNotOkayLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            foodsNotOkayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            foodsNotOkayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Create and configure the 'Diet 1: Dairy Elimination Diet' label
        let dietLabel = UILabel()
        dietLabel.text = "Diet 2: Dairy, Gluten Elimination Diet"
        dietLabel.font = UIFont(name: "Times New Roman", size: 17)
        dietLabel.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
        dietLabel.textAlignment = .center
        dietLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(dietLabel)
        
        NSLayoutConstraint.activate([
            dietLabel.topAnchor.constraint(equalTo: foodsNotOkayLabel.bottomAnchor, constant: 10),
            dietLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dietLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Configure the table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: dietLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.heightAnchor.constraint(equalToConstant: 550) // Adjust the height based on content
        ])
        
        // Create and configure the 'Allergies' button
        let allergiesButton = UIButton(type: .system)
        allergiesButton.setTitle("Allergies", for: .normal)
        allergiesButton.backgroundColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
        allergiesButton.setTitleColor(.white, for: .normal)
        allergiesButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        allergiesButton.layer.cornerRadius = 10
        allergiesButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(allergiesButton)
        
        NSLayoutConstraint.activate([
            allergiesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            allergiesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            allergiesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            allergiesButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        allergiesButton.addTarget(self, action: #selector(allergiesButtonTapped), for: .touchUpInside)
    }
    
    @objc func allergiesButtonTapped() {
     
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Instantiate the AllergiesViewController (AddAllergenViewController)
        if let allergiesVC = storyboard.instantiateViewController(withIdentifier: "AddAllergenViewController") as? AddAllergenViewController {
            
            // Optionally pass any data if needed
            allergiesVC.user = user ?? ""
            
            // Navigate to the AllergiesViewController
            navigationController?.pushViewController(allergiesVC, animated: true)
        }
    }

    
    // Add Food menu
    @objc func addFood() {
        // Create alert controller with text field for adding food
        let alert = UIAlertController(title: "Add Food to List", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter food"
        }
        
        // Define the action for adding food
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            if let foodName = alert.textFields?.first?.text, !foodName.isEmpty {
                self?.foods.append(foodName) // Add food to the data source
                self?.tableView.reloadData()  // Reload table view to display new food
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add actions to alert controller
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        // Present the alert controller
        present(alert, animated: true, completion: nil)
    }
    
    // Table View Data Source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = foods[indexPath.row]
        return cell
    }
}

