//import UIKit
//
//class QualityofLifeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource{
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return questions.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return text.count
//    }
//
//
//
////    let count = 3
//    let questions = ["Visit date", "How often does your child have trouble swallowing?", "How bad is your child's trouble swallowing?","How often does your child feel like food gets stuck in their throat or chest?","How bad is it when your child gets food stuck in their throat or chest?","How often does your child need to drink a lot to help them swallow food?","How bad is it when your child needs to drink a lot to help them swallow food?","How often does your child eat less than others?","How often does your child need more time to eat than other?","Visit date", "How often does your child have trouble swallowing?", "How bad is your child's trouble swallowing?","How often does your child feel like food gets stuck in their throat or chest?","How bad is it when your child gets food stuck in their throat or chest?","How often does your child need to drink a lot to help them swallow food?","How bad is it when your child needs to drink a lot to help them swallow food?","How often does your child eat less than others?","How often does your child need more time to eat than other?"]
////    let ratings = ["1", "2", "3", "4", "5"]
//    let text = ["0","1","2","3","4","5"]
//    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var tableView: UITableView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //heightConstraint.constant = CGFloat(count * 44)
//        // Set the delegate and dataSource for the tableView
//        let nib = UINib(nibName: "QualityofLifeTableViewCell", bundle: nil)
//        tableView.register(nib, forCellReuseIdentifier: "QualityofLifeTableViewCell")
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
//
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return questions.count
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "QualityofLifeTableViewCell", for: indexPath) as! QualityofLifeTableViewCell
//        cell.questionlabel.text = questions[indexPath.row]
//        cell.pickers.delegate = self
//        cell.pickers.dataSource = self
//        return cell
//    }
//
//
//}

import UIKit

class QualityofLifeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let questions = ["Visit date", "How often does your child have trouble swallowing?", "How bad is your child's trouble swallowing?", "How often does your child feel like food gets stuck in their throat or chest?", "How bad is it when your child gets food stuck in their throat or chest?", "How often does your child need to drink a lot to help them swallow food?", "How bad is it when your child needs to drink a lot to help them swallow food?", "How often does your child eat less than others?", "How often does your child need more time to eat than others?", "Visit date", "How often does your child have trouble swallowing?", "How bad is your child's trouble swallowing?", "How often does your child feel like food gets stuck in their throat or chest?", "How bad is it when your child gets food stuck in their throat or chest?", "How often does your child need to drink a lot to help them swallow food?", "How bad is it when your child needs to drink a lot to help them swallow food?", "How often does your child eat less than others?", "How often does your child need more time to eat than others?"]
    
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
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QualityofLifeTableViewCell", for: indexPath) as! QualityofLifeTableViewCell
        cell.questionlabel.text = questions[indexPath.row]
        cell.pickers.delegate = self
        cell.pickers.dataSource = self
        return cell
    }
}

extension QualityofLifeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Or the number of components you want in the picker
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return text.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return text[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Handle picker selection if needed
    }
}
