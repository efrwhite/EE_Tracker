import UIKit
import CoreData

class QualityofLifeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var capturedData: [[String: Any]] = []

    let symptomsone = [ "I have chest pain, ache, or hurt", "I have burning in my chest, mouth, or throat (heartburn)", "I have stomach aches or belly aches", "I throw up (vomit)", "I feel like I'm going to throw up, but I don't (nausea)", "When I am eating, food comes back up my throat"]
      
      let symptomstwo = ["I have trouble swallowing", "I feel like food gets stuck in my throat or chest", "I need to drink to help me swallow my food", "I need more time to eat than other kids my age"]
      
      let treatment = [ "It is hard for me to take my medicine", "I do not want to take my medicines", "I do not like going to the doctor", "I do not like getting an endoscopy (scope, EGD)", "I do not like getting allergy testing"]
      
      let worry = [ "I worry about having EOE", "I worry about getting sick in front of other people", "I worry about what other people think about me because of EOE","I worry about getting allergy testing"]
      
      let communication = ["I have trouble telling other people about EOE", "I have trouble talking to my parents about how I feel", "I have trouble talking to other adults about how I feel", "I have trouble talking to my friends about how I feel", "I have trouble talking to doctors or nurses about how I feel"]
      
      let foodandeating = ["It is hard not being allowed to eat some foods","It is hard for me not to sneak foods I'm allergic to", "It is hard for me to not eat the same things as my family", "It is hard not to eat the same things as my friends"]
      
      let foodfeelingQ = [ "I worry about eating foods I'm allergic to or not supposed to eat","I feel mad (get upset) about not eating foods I am allergic to or not supposed to eat","I feel sad about not eating foods I am allergic to or not supposed to eat"]
    let sections = [
        """
        For the following sections insert a value 0-5 based on the ranking below
        Pain Scale:
        0 = pain
        1 = moderate pain
        2 = slight pain
        3 = barely pain
        4 = no pain
        """,
        "SYMPTOMS I",
        "SYMPTOMS II",
        "TREATMENT",
        "WORRY",
        "COMMUNICATION",
        "FOOD AND EATING",
        "FOOD FEELINGS"
    ]


    var sectionData: [[String]] {
            return [
                [],  // Empty array for "Pain Scale" section
                symptomsone,
                symptomstwo,
                treatment,
                worry,
                communication,
                foodandeating,
                foodfeelingQ
            ]
        }

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    var sectionResponses: [[String?]] = []
    // Create separate arrays to store responses for each section
       var symptomsOneResponses: [String?] = []
       var symptomsTwoResponses: [String?] = []
       var treatmentResponses: [String?] = []
       var worryResponses: [String?] = []
       var communicationResponses: [String?] = []
       var foodAndEatingResponses: [String?] = []
       var foodFeelingResponses: [String?] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "QualityofLifeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "QualityofLifeTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        // Initialize responses arrays with nil values
            symptomsOneResponses = Array(repeating: nil, count: symptomsone.count)
            symptomsTwoResponses = Array(repeating: nil, count: symptomstwo.count)
            treatmentResponses = Array(repeating: nil, count: treatment.count)
            worryResponses = Array(repeating: nil, count: worry.count)
            communicationResponses = Array(repeating: nil, count: communication.count)
            foodAndEatingResponses = Array(repeating: nil, count: foodandeating.count)
            foodFeelingResponses = Array(repeating: nil, count: foodfeelingQ.count)
        
        // Initialize the sectionResponses array
                for _ in sections {
                    sectionResponses.append(Array(repeating: nil, count: sectionData[sectionResponses.count].count))
                }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QualityofLifeTableViewCell", for: indexPath) as! QualityofLifeTableViewCell

        cell.questionlabel.text = sectionData[indexPath.section][indexPath.row]

        if indexPath.section != 0 {
            cell.ratingText.tag = indexPath.section * 100 + indexPath.row
            cell.ratingText.placeholder = "0-5"
            cell.ratingText.text = getResponseForIndexPath(indexPath)
            cell.ratingText.addTarget(self, action: #selector(responseTextFieldDidChange(_:)), for: .editingChanged)
        }

        return cell
    }

    func getResponseForIndexPath(_ indexPath: IndexPath) -> String? {
        let section = indexPath.section
        let row = indexPath.row

        switch section {
        case 1:
            return symptomsOneResponses[row]
        case 2:
            return symptomsTwoResponses[row]
        case 3:
            return treatmentResponses[row]
        case 4:
            return worryResponses[row]
        case 5:
            return communicationResponses[row]
        case 6:
            return foodAndEatingResponses[row]
        case 7:
            return foodFeelingResponses[row]
        default:
            return nil
        }
    }


    @IBAction func saveButtonTapped(_ sender: Any) {
        captureData()
        saveDataToCoreData()
    }




    @objc func responseTextFieldDidChange(_ textField: UITextField) {
        let section = textField.tag / 100
        let row = textField.tag % 100
        let response = textField.text

        switch section {
        case 1:
            if row < symptomsOneResponses.count {
                symptomsOneResponses[row] = response
            }
        case 2:
            if row < symptomsTwoResponses.count {
                symptomsTwoResponses[row] = response
            }
        case 3:
            if row < treatmentResponses.count {
                treatmentResponses[row] = response
            }
        case 4:
            if row < worryResponses.count {
                worryResponses[row] = response
            }
        case 5:
            if row < communicationResponses.count {
                communicationResponses[row] = response
            }
        case 6:
            if row < foodAndEatingResponses.count {
                foodAndEatingResponses[row] = response
            }
        case 7:
            if row < foodFeelingResponses.count {
                foodFeelingResponses[row] = response
            }
        default:
            break
        }

        // Update the sectionResponses array with the user's response
        sectionResponses[section][row] = response
    }





    func saveDataToCoreData() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext

            for dataItem in capturedData {
                let entity = NSEntityDescription.entity(forEntityName: "Quality", in: context)
                let qualityObject = NSManagedObject(entity: entity!, insertInto: context)

                if let question = dataItem["question"] as? String {
                    qualityObject.setValue(question, forKey: "question")
                }

                if let response = dataItem["response"] as? String {
                    qualityObject.setValue(response, forKey: "response")
                }

                if let date = dataItem["date"] as? Date {
                    qualityObject.setValue(date, forKey: "date")
                }

                do {
                    try context.save()
                } catch {
                    print("Failed to save response: \(error)")
                }
            }
        }
    }
    func captureData() {
        capturedData.removeAll() // Clear the previous captured data

        for sectionIndex in 1..<sectionData.count {
            for rowIndex in 0..<sectionData[sectionIndex].count {
                let question = sectionData[sectionIndex][rowIndex]
                let response = sectionResponses[sectionIndex][rowIndex]
                
                // Create a dictionary to store the captured data
                let data: [String: Any] = [
                    "question": question,
                    "response": response ?? "", // Provide a default value if response is nil
                    "date": Date()
                ]

                // Append the data to the capturedData array
                capturedData.append(data)
            }
        }

        // You now have all the captured data in the capturedData array
        print(capturedData)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let label = UILabel()

        switch section {
        case 0:
            label.text = "For the following sections insert a value 0-5 based on the ranking below:\n\nPain Scale:\n0 = pain\n1 = moderate pain\n2 = slight pain\n3 = barely pain\n4 = no pain"
            label.font = UIFont.systemFont(ofSize: 14)
            label.textAlignment = .left
            label.numberOfLines = 0
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return sectionData[section].count
        }
}
