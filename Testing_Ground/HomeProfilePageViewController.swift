import UIKit

class HomeProfilePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the data source and delegate to self
        tableView.dataSource = self
        tableView.delegate = self
    }

    // Define the number of sections in the table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // Two sections: Child Profile and Parent Profile
    }

    // Define the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Always return at least 1 row for each section, even if there's no data
        return 1
    }

    // Define the header title for each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Child Profile"
        } else {
            return "Parent Profile"
        }
    }
    
    // Implement cellForRowAt to populate your cells with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YourCellIdentifier", for: indexPath)
        
        // Configure the cell based on the section and indexPath
        // You can add code here to populate the cells when you have data
        
        return cell
    }
}
