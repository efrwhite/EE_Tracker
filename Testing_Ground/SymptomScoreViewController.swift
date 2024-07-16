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
        "For the following questions, use the switch to indicate Yes or No"
    ]
    
    @IBOutlet weak var tableView: UITableView!
    var responses: [[String?]] = []
    var yesnoResponses: [Bool] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "SymptomTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SymptomTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        responses = [Array(repeating: nil, count: questions.count), Array(repeating: nil, count: yesnoquestions.count)]
        yesnoResponses = Array(repeating: false, count: yesnoquestions.count)
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
        cell.configureCell(for: indexPath.section)
        
        if indexPath.section == 0 {
            cell.Ratingtext.text = responses[indexPath.section][indexPath.row]
        } else {
            cell.yesNoSwitch.isOn = yesnoResponses[indexPath.row]
            cell.yesNoSwitch.tag = indexPath.row
            cell.yesNoSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        }
        
        cell.delegate = self
        cell.indexPath = indexPath
        
        return cell
    }
    
    func didEditTextField(_ text: String, atIndexPath indexPath: IndexPath) {
        responses[indexPath.section][indexPath.row] = text
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        yesnoResponses[sender.tag] = sender.isOn
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        print("Save button tapped in SymptomScoreViewController")
        
        captureData()
        
        let entries = saveDataToCoreData()
        if !entries.isEmpty {
            delegate?.symptomScoreViewController(self, didUpdateSymptomEntries: entries)
            performSegue(withIdentifier: "SymptomResultSegue", sender: self)
        } else {
            print("Failed to save data or no entries to update.")
        }
    }

    func captureData() {
        var sum = 0

        for response in responses[0] where response != nil {
            if let intValue = Int(response!) {
                sum += intValue
            }
        }

        for (index, _) in yesnoquestions.enumerated() {
            if yesnoResponses[index] {
                sum += 1
            }
        }

        capturedData = [["sum": sum, "date": Date()]]
    }

    func saveDataToCoreData() -> [SymptomEntry] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Could not get appDelegate")
            return []
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let sumOfResponses = responses.flatMap { $0 }.compactMap { Int($0 ?? "0") }.reduce(0, +) + yesnoResponses.filter { $0 }.count
        
        let newSymptom = Symptom(context: context)
        newSymptom.symptomSum = Int64(sumOfResponses)
        newSymptom.date = Date()
        
        var entries: [SymptomEntry] = []
        
        do {
            try context.save()
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
