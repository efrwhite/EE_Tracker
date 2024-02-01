import UIKit

class Diet1BadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let sectionTitle = "Foods Not Okay to Eat"
    let items = [
        "Milk",
        "Butter",
        "Cream",
        "Buttermilk",
        "Half & half",
        "Yogurt",
        "Cheese",
        "Ice cream",
        "Sour cream",
        "Cottage cheese",
        "Chocolates and candy",
        "“Whey” listed in ingredients",
        "“Casein” listed in ingredients"
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
}
