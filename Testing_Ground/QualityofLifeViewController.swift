import UIKit

class QualityofLifeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Define your question arrays
    let symptomsone = ["SYMPTOMS I", "I have chest pain, ache, or hurt", "I have burning in my chest, mouth, or throat (heartburn)", "I have stomach aches or belly aches", "I throw up (vomit)", "I feel like I'm going to throw up, but I don't (nausea)", "When I am eating, food comes back up my throat"]
    
    let symptomstwo = ["SYMPTOMS II", "I have trouble swallowing", "I feel like food gets stuck in my throat or chest", "I need to drink to help me swallow my food", "I need more time to eat than other kids my age"]
    
    let treatment = ["TREATMENT", "It is hard for me to take my medicine", "I do not want to take my medicines", "I do not like going to the doctor", "I do not like getting an endoscopy (scope, EGD)", "I do not like getting allergy testing"]
    
    let worry = ["WORRY", "I worry about having EOE", "I worry about getting sick in front of other people", "I worry about what other people think about me because of EOE","I worry about getting allergy testing"]
    
    let communication = ["COMMUNICATION", "I have trouble telling other people about EOE", "I have trouble talking to my parents about how I feel", "I have trouble talking to other adults about how I feel", "I have trouble talking to my friends about how I feel", "I have trouble talking to doctors or nurses about how I feel"]
    
    let foodandeating = ["FOOD AND EATING","It is hard not being allowed to eat some foods","It is hard for me not to sneak foods I'm allergic to", "It is hard for me to not eat the same things as my family", "It is hard not to eat the same things as my friends"]
    
    let foodfeelingQ = ["FOOD FEELINGS", "I worry about eating foods I'm allergic to or not supposed to eat","I feel mad (get upset) about not eating foods I am allergic to or not supposed to eat","I feel sad about not eating foods I am allergic to or not supposed to eat"]
    
    let text = ["0", "1", "2", "3", "4", "5"]
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "QualityofLifeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "QualityofLifeTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the count of questions for the corresponding section
        switch section {
        case 0:
            return 0 // No rows for "Pain Scale" header
        case 1:
            return symptomsone.count - 1 // Exclude the header
        case 2:
            return symptomstwo.count - 1 // Exclude the header
        case 3:
            return treatment.count - 1 // Exclude the header
        case 4:
            return worry.count - 1 // Exclude the header
        case 5:
            return communication.count - 1 // Exclude the header
        case 6:
            return foodandeating.count - 1 // Exclude the header
        case 7:
            return foodfeelingQ.count - 1 // Exclude the header
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QualityofLifeTableViewCell", for: indexPath) as! QualityofLifeTableViewCell
        
        // Set the cell label text based on the section
        switch indexPath.section {
        case 1:
            cell.questionlabel.text = symptomsone[indexPath.row + 1] // Start from the element after the header
        case 2:
            cell.questionlabel.text = symptomstwo[indexPath.row + 1] // Start from the element after the header
        case 3:
            cell.questionlabel.text = treatment[indexPath.row + 1] // Start from the element after the header
        case 4:
            cell.questionlabel.text = worry[indexPath.row + 1] // Start from the element after the header
        case 5:
            cell.questionlabel.text = communication[indexPath.row + 1] // Start from the element after the header
        case 6:
            cell.questionlabel.text = foodandeating[indexPath.row + 1] // Start from the element after the header
        case 7:
            cell.questionlabel.text = foodfeelingQ[indexPath.row + 1] // Start from the element after the header
        default:
            cell.questionlabel.text = ""
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of question arrays
        return 8
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           // Create a header view with the first element of each array as the header text
           let headerView = UIView()
           let label = UILabel()
           
           switch section {
           case 0:
               // "Pain Scale" header with levels 0-4
               label.text = "Pain Scale:\n0 = pain\n1 = moderate pain\n2 = slight pain\n3 = barely pain\n4 = no pain"
               label.font = UIFont.systemFont(ofSize: 14) // Smaller font size
               label.textAlignment = .left // Align text to the left
               label.numberOfLines = 0 // Allow multiple lines for "Pain Scale"
           case 1:
               label.text = "SYMPTOMS I"
           case 2:
               label.text = "SYMPTOMS II"
           case 3:
               label.text = "TREATMENT"
           case 4:
               label.text = "WORRY"
           case 5:
               label.text = "COMMUNICATION"
           case 6:
               label.text = "FOOD AND EATING"
           case 7:
               label.text = "FOOD FEELINGS"
           default:
               label.text = ""
           }
           
           label.translatesAutoresizingMaskIntoConstraints = false
           headerView.addSubview(label)
           
           NSLayoutConstraint.activate([
               label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16), // Adjust the leading space
               label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16), // Adjust the trailing space
               label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8), // Adjust the top space
               label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8) // Adjust the bottom space
           ])
           
           // Calculate the height needed for the header based on the label's content
           let headerHeight = heightForLabel(label, width: tableView.frame.width - 32) + 16 // Add extra space for padding
           headerView.frame.size.height = headerHeight
           
           return headerView
       }
       
       func heightForLabel(_ label: UILabel, width: CGFloat) -> CGFloat {
           let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
           let text = label.text ?? ""
           let font = label.font ?? UIFont.systemFont(ofSize: 17)
           let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
           let attributes = [NSAttributedString.Key.font: font]
           let boundingRect = text.boundingRect(with: maxSize, options: options, attributes: attributes, context: nil)
           return ceil(boundingRect.height)
       }
       
       func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           // Return the height for the headers
           return UITableView.automaticDimension
       }
}
