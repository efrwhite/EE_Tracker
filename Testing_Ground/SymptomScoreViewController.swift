import UIKit
import CoreData

protocol SymptomScoreViewControllerDelegate: AnyObject {
    func symptomScoreViewController(_ controller: SymptomScoreViewController, didUpdateSymptomEntries entries: [SymptomScoreViewController.SymptomEntry])
}

class SymptomScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SymTableViewCellDelegate {
    weak var delegate: SymptomScoreViewControllerDelegate?
    var capturedData: [[String: Any]] = []
    
    let questions = [
        "Visit date",
        "How often does your child have trouble swallowing?",
        "How bad is your child's trouble swallowing?",
        "How often does your child feel like food gets stuck in their throat or chest?",
        "How bad is it when your child gets food stuck in their throat or chest?",
        "How often does your child need to drink a lot to help them swallow food?",
        "How bad is it when your child needs to drink a lot to help them swallow food?",
        "How often does your child eat less than others?",
        "How often does your child need more time to eat than others?",
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
            "For the questions below, insert a value from 0-5\n0 = No pain, 5 = Excruciating pain",
            "For the following questions insert a value from 0-1\n0 = No, 1 = Yes"
        ]
        
        @IBOutlet weak var tableView: UITableView!
        var responses: [[String?]] = []

        override func viewDidLoad() {
            super.viewDidLoad()
            
            let nib = UINib(nibName: "SymptomTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "SymptomTableViewCell")
            tableView.delegate = self
            tableView.dataSource = self
            tableView.estimatedRowHeight = 100
            tableView.rowHeight = UITableView.automaticDimension
            
            responses = [Array(repeating: nil, count: questions.count), Array(repeating: nil, count: yesnoquestions.count)]
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return sections.count
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return sections[section]
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return section == 0 ? questions.count : yesnoquestions.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SymptomTableViewCell", for: indexPath) as? SymTableViewCell else {
                fatalError("Expected SymptomTableViewCell")
            }
            
            let question = indexPath.section == 0 ? questions[indexPath.row] : yesnoquestions[indexPath.row]
            cell.questionLabel.text = question
            cell.Ratingtext.text = responses[indexPath.section][indexPath.row]
            cell.delegate = self
            cell.indexPath = indexPath
            
            return cell
        }
        
        func didEditTextField(_ text: String, atIndexPath indexPath: IndexPath) {
            responses[indexPath.section][indexPath.row] = text
        }
        
    @IBAction func saveButtonTapped(_ sender: Any) {
        print("Save button tapped in SymptomScoreViewController")
        
        captureData()
        
        let entries = saveDataToCoreData()
        if !entries.isEmpty {
            delegate?.symptomScoreViewController(self, didUpdateSymptomEntries: entries)
        } else {
            print("Failed to save data or no entries to update.")
        }
    }

        
    func captureData() {
        // Initialize sum variable
        var sum = 0

        // Calculate sum for the first section responses
        for response in responses[0] where response != nil {
            if let intValue = Int(response!) {
                sum += intValue
            }
        }

        // Calculate sum for the second section responses
        for response in responses[1] where response != nil {
            if let intValue = Int(response!) {
                sum += intValue
            }
        }

        // Store the sum and current date as a single entry
        capturedData = [["sum": sum, "date": Date()]]
    }

        
    func saveDataToCoreData() -> [SymptomEntry] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Could not get appDelegate")
            return []
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        // Calculate the sum of responses
        let sumOfResponses = responses.flatMap { $0 }.compactMap { Int($0 ?? "0") }.reduce(0, +)
        
        // Create a new Symptom object
        let newSymptom = Symptom(context: context)
        newSymptom.symptomSum = Int64(sumOfResponses)  // Assuming 'symptomSum' is the correct attribute name
        newSymptom.date = Date()  // Set the current date
        
        var entries: [SymptomEntry] = []
        
        do {
            try context.save()
            // Create a SymptomEntry with the saved data to return
            let entry = SymptomEntry(sum: sumOfResponses, date: newSymptom.date!)
            entries.append(entry)
            
            print("Data saved successfully")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        return entries
    }


        
    struct SymptomEntry {
        let sum: Int
        let date: Date
    }


}
