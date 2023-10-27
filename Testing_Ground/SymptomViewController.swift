import UIKit
import CoreData

class SymptomScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SymTableViewCellDelegate, UITextFieldDelegate {
    var symptomResponses: [Symptom] = []
    var userInputArray: [String?] = []
    var userInputArrayQuestions: [String?] = [] // For questions
    var userInputArrayYesNo: [String?] = []    // For yes/no questions

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
    let sections = [
        """
For the following questions insert a value 0-5 based on the ranking below\n
Pain Scale: 0-5

""",
        """
For the following questions insert a value 0 or 1 based on the ranking below\n
0 = No
1 = Yes
"""
    ]
    @IBOutlet weak var symptomtableview: UITableView!
    
    @IBAction func savebutton(_ sender: UIButton) {
        let currentDate = Date() // Get the current date
        
        for (index, response) in userInputArrayQuestions.enumerated() {
            if let response = response {
                saveSymptom(date: currentDate, response: response, question: questions[index])
            }
        }

        for (index, response) in userInputArrayYesNo.enumerated() {
            if let response = response {
                saveSymptom(date: currentDate, response: response, question: yesnoquestions[index])
            }
        }
    }

    func saveSymptom(date: Date, response: String, question: String) {
        // Get the managed object context from the app delegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext

            // Create a new Symptom managed object
            let newSymptom = Symptom(context: context)
            
            // Set the properties of the Symptom object
            newSymptom.date = date // Use the provided date
            newSymptom.response = response
            newSymptom.question = question
            
            // Save the context to persist the Symptom object
            do {
                try context.save()
                print("Symptom saved successfully")
            } catch {
                print("Failed to save Symptom: \(error)")
            }
        }
    }

    
    override func viewDidLoad() {
            super.viewDidLoad()

            symptomtableview.register(UINib(nibName: "SymptomTableViewCell", bundle: nil), forCellReuseIdentifier: "SymptomTableViewCell")
            symptomtableview.rowHeight = UITableView.automaticDimension
            symptomtableview.delegate = self
            symptomtableview.dataSource = self
            symptomtableview.estimatedRowHeight = 65

            // Initialize userInputArrayQuestions and userInputArrayYesNo with nil values
            userInputArrayQuestions = Array(repeating: nil, count: questions.count)
            userInputArrayYesNo = Array(repeating: nil, count: yesnoquestions.count)
        }

        func numberOfSections(in tableView: UITableView) -> Int {
            return sections.count
        }

        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return sections[section]
        }

       
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerText = sections[section]
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17) // Adjust font size as needed
        label.numberOfLines = 0
        label.text = headerText
        label.lineBreakMode = .byWordWrapping

        let maxSize = CGSize(width: tableView.frame.size.width - 32, height: CGFloat.greatestFiniteMagnitude)
        let expectedSize = label.sizeThatFits(maxSize)

        return max(40, expectedSize.height + 32) // Ensure it's at least 40, your desired minimum height
    }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 0 {
                return questions.count
            } else {
                return yesnoquestions.count
            }
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SymptomTableViewCell", for: indexPath) as! SymTableViewCell

            if indexPath.section == 0 {
                cell.questionLabel.text = questions[indexPath.row]
                cell.Ratingtext.text = userInputArrayQuestions[indexPath.row]
            } else if indexPath.section == 1 {
                cell.questionLabel.text = yesnoquestions[indexPath.row]
                cell.Ratingtext.text = userInputArrayYesNo[indexPath.row]
            }

            cell.delegate = self
            cell.indexPath = indexPath

            return cell
        }

        // Implement the SymTableViewCellDelegate method
        func didEditTextField(_ text: String, atIndexPath indexPath: IndexPath) {
            if indexPath.section == 0 {
                userInputArrayQuestions[indexPath.row] = text
            } else if indexPath.section == 1 {
                userInputArrayYesNo[indexPath.row] = text
            }
        }
}
