import UIKit

class Diet1BadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let sectionTitle = "Foods Not Okay to Eat"
    var items = [
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
        "Yogurt"
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Set up automatic row height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.numberOfLines = 0 // Allow unlimited lines
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        return cell
    }
    
    // Method to add a new food item
    func addFood(_ food: String) {
        items.append(food)
        tableView.reloadData()
    }
}
