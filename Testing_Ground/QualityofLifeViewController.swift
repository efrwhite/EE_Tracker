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
    
    let questions = ["SYMPTOMS I", "I have chest pain, ache, or hurt", "I have burning in my chest, mouth, or throat (heartburn)", "I have stomach aches or belly aches", "I throw up (vomit)", "I feel like I'm going to throw up, but I don't (nausea)", "When I am eating, food comes back up my throat", "SYMPTOMS II", "I have trouble swallowing", "I feel like food gets stuck in my throat or chest", "I need to drink to help me swallow my food", "I need more time to eat than other kids my age", "TREATMENT", "It is hard for me to take my medicine", "I do not want to take my medicines", "I do not like going to the doctor", "I do not like getting an endoscopy (scope, EGD)", "I do not like getting allergy testing", "WORRY", "I worry about having EOE", "I worry about getting sick in front of other people", "I worry about what other people think about me because of EOE","I worry about getting allergy testing", "COMMUNICATION", "I have trouble telling other people about EOE", "I have trouble talking to my parents about how I feel", "I have trouble talking to other adults about how I feel", "I have trouble talking to my friends about how I feel", "I have trouble talking to doctors or nurses about how I feel", "FOOD AND EATING","It is hard not being allowed to eat some foods","It is hard for me not to sneak foods I'm allergic to", "It is hard for me to not eat the same things as my family", "It is hard not to eat the same things as my friends", "FOOD FEELINGS", "I worry about eating foods I'm allergic to or not supposed to eat","I feel mad (get upset) about not eating foods I am allergic to or not supposed to eat","I feel sad about not eating foods I am allergic to or not supposed to eat"]
    
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



