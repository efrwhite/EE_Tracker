import UIKit

class SymptomScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    let questions = [
        "Visit date",
        "How often does your child have trouble swallowing?",
        "How bad is your child's trouble swallowing?",
        "How often does your child feel like food gets stuck in their throat or chest?",
        "How bad is it when your child gets food stuck in their throat or chest?",
        "How often does your child need to drink a lot to help them swallow food?",
        "How bad is it when your child needs to drink a lot to help them swallow food?",
        "How often does your child eat less than others?",
        "How often does your child need more time to eat than other?",
        "How often does your child have heartburn?",
        "How bad is your child's heartburn (burning in the chest, mouth, or throat)?",
        "How often does your child have food come back up in their throat when eating?",
        "How bad is it when food comes back up in your child's throat?",
        "How often does your child vomit (throw up)?",
        "How bad is your child's vomiting?",
        "How often does your child feel nauseous (feel like throwing up, but doesn't)?",
        "How bad is your child's nausea (feel like throwing up, but doesn't)?",
        "How often does your child have chest pain, ache, or hurt?",
        "How bad is your child's chest pain, ache, or hurt?",
        "How often does your child have stomach aches or belly aches?",
        "How bad are your child's stomach aches or belly aches?"
    ]
    
    let yesnoquestions = [
        "Feeding is difficult/refuses food?",
        "Slow eating",
        "Prolonged chewing",
        "Swallowing liquids with solid food",
        "Avoidance of solid food",
        "Retching",
        "Choking",
        "Food Impaction",
        "Hoarseness",
        "Constipation",
        "Poor weight gain",
        "Diarrhea"
    ]
    
    let text = ["","","","","","","","","","","","","","","","","","","",""]
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "SymptomTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SymptomTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return questions.count
        } else {
            return yesnoquestions.count + 1 // Add 1 for the header
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SymptomTableViewCell", for: indexPath) as! SymTableViewCell
        
        if indexPath.section == 0 {
            cell.questionlabel.text = questions[indexPath.row]
        } else {
            if indexPath.row == 0 {
                cell.questionlabel.text = "Please answer yes or no for the following questions below:"
                cell.ratingtext.text = ""
            } else {
                let adjustedIndex = indexPath.row - 1
                if adjustedIndex < yesnoquestions.count {
                    cell.questionlabel.text = yesnoquestions[adjustedIndex]
                    cell.ratingtext.text = text[adjustedIndex]
                } else {
                    cell.questionlabel.text = ""
                    cell.ratingtext.text = ""
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let label = UILabel()
        
        if section == 0 {
            label.text = "0-5 Rating Questions"
        } else {
            label.text = "Yes/No Questions"
        }
        
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        
        let headerHeight = heightForLabel(label, width: tableView.frame.width - 32) + 16
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
        return UITableView.automaticDimension
    }
}

