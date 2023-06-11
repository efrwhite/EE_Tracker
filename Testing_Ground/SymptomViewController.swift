import UIKit

class SymptomScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
 
    let count = 3
    let questions = ["Visit date", "How often does your child have trouble swallowing?", "How bad is your child's trouble swallowing?","How often does your child feel like food gets stuck in their throat or chest?","How bad is it when your child gets food stuck in their throat or chest?","How often does your child need to drink a lot to help them swallow food?","How bad is it when your child needs to drink a lot to help them swallow food?","How often does your child eat less than others?","How often does your child need more time to eat than other?","Visit date", "How often does your child have trouble swallowing?", "How bad is your child's trouble swallowing?","How often does your child feel like food gets stuck in their throat or chest?","How bad is it when your child gets food stuck in their throat or chest?","How often does your child need to drink a lot to help them swallow food?","How bad is it when your child needs to drink a lot to help them swallow food?","How often does your child eat less than others?","How often does your child need more time to eat than other?"]
//    let ratings = ["1", "2", "3", "4", "5"]
    let text = ["","","","","","","","","","","","","","","","","",""]
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //heightConstraint.constant = CGFloat(count * 44)
        // Set the delegate and dataSource for the tableView
        let nib = UINib(nibName: "SymptomTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SymptomTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SymptomTableViewCell", for: indexPath) as! SymTableViewCell
        cell.questionlabel.text = questions[indexPath.row]
        cell.ratingtext.text = text[indexPath.row]
        return cell
    }
  
    
}

