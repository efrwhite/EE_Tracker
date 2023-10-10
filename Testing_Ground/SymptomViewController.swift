
import UIKit
import CoreData

struct SymptomResponse {
    var date: Date?
    var response: String?
}


class SymptomScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SymTableViewCellDelegate, UITextFieldDelegate {
    var symptomResponses: [SymptomResponse] = []
    var userInputArray: [String?] = []
   
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
    
   
    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "SymptomTableViewCell", bundle: nil), forCellReuseIdentifier: "SymptomTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
          tableView.estimatedRowHeight = 65

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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "0-5 Rating Questions" : "Yes/No Questions"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SymptomTableViewCell", for: indexPath) as! SymTableViewCell
        
        // Set the indexPath property for the cell
        cell.indexPath = indexPath
        
        // Configure the cell's Ratingtext field
        cell.Ratingtext.delegate = self
        
        if indexPath.section == 1 {
            // Check if it's a "Yes/No Questions" cell
            if indexPath.row < yesnoquestions.count {
                cell.Ratingtext.placeholder = "Yes/No" // Set placeholder for Yes/No questions
                cell.questionLabel.text = yesnoquestions[indexPath.row]
            } else {
                cell.Ratingtext.placeholder = "0-5"
                cell.questionLabel.text = "" // Empty label for this case
            }
        } else {
            // Configure cells in the "0-5 Rating Questions" section
            cell.Ratingtext.placeholder = "0-5" // Set placeholder for 0-5 rating questions
            
            // Set the text for the "0-5 Rating Questions" here
            if indexPath.row < questions.count {
                cell.questionLabel.text = questions[indexPath.row]
            } else {
                cell.questionLabel.text = "" // Empty label for this case
            }
        }
        
        // Allow the label text to wrap to multiple lines
        cell.questionLabel.numberOfLines = 0
        cell.questionLabel.lineBreakMode = .byWordWrapping
        
        // Set the text field's text to the user's input if it exists
        if indexPath.row < userInputArray.count, let userInput = userInputArray[indexPath.row] {
            cell.Ratingtext.text = userInput
        } else {
            cell.Ratingtext.text = "" // Clear the text field if there's no user input
        }
        
        return cell
    }





    @IBAction func Savebutton(_ sender: Any) {
        saveResponsesToCoreData()
    }
    func saveResponsesToCoreData() {
        let currentDate = Date() // Get the current date

        for (index, response) in symptomResponses.enumerated() {
            let symptomEntity = NSEntityDescription.entity(forEntityName: "Symptom", in: context)
            let symptomObject = NSManagedObject(entity: symptomEntity!, insertInto: context)

            symptomObject.setValue(currentDate, forKey: "date") // Set the current date
            symptomObject.setValue(response.response, forKey: "response")

            if index < questions.count {
                let question = questions[index]
                symptomObject.setValue(question, forKey: "question") // Set the question
            }

            // Save the managed object context
            do {
                try context.save()
            } catch {
                print("Error saving response: \(error)")
            }
        }
    }




    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, let cell = textField.superview?.superview as? SymTableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            createSymptomResponseIfNeeded(atIndexPath: indexPath)
            symptomResponses[indexPath.row].response = text
        }
    }



    func createSymptomResponseIfNeeded(atIndexPath indexPath: IndexPath) {
        // Ensure that the array has enough elements for the current index
        while symptomResponses.count <= indexPath.row {
            symptomResponses.append(SymptomResponse(date: nil, response: nil))
        }
    }


    
    func didEditTextField(_ text: String, atIndexPath indexPath: IndexPath) {
        if indexPath.row < symptomResponses.count {
            symptomResponses[indexPath.row].response = text
        }
    }


}

