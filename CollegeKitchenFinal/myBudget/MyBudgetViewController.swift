//
//  MyBudgetViewController.swift
//  CollegeKitchenFinal
//
//  Created by Maya Menon on 11/21/18.
//  Copyright © 2018 Julia Downey. All rights reserved.
//

import UIKit

private let reuseIdentifier = "myBudgetView"

class MyBudgetViewController: UIViewController {
    
    var budgetValue:Double = 0
    var spentValue:Double = 0
    var availValue:Double = 0
    
    var firstBudget:Bool!
    @IBOutlet weak var budgetValLabel: UILabel!
    @IBOutlet weak var spentValLabel: UILabel!
    @IBOutlet weak var availValLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var editBudPopUp: UIView!
    @IBOutlet weak var addSubSelector: UISegmentedControl!
    @IBOutlet weak var editBudEntry: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayBudget()
        backgroundView.isHidden = true
        editBudPopUp.isHidden = true
        budgetValLabel.textColor = UIColor(red: 31/255, green: 35/255, blue: 63/255, alpha: 1)
        spentValLabel.textColor = UIColor(red: 31/255, green: 35/255, blue: 63/255, alpha: 1)
        availValLabel.textColor = UIColor(red: 31/255, green: 35/255, blue: 63/255, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
      displayBudget()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    
    @IBAction func editBudget(_ sender: Any) {
        backgroundView.isHidden=false
        editBudPopUp.isHidden=false
    }
    
    @IBAction func doneEditingBudget(_ sender: Any) {
        if (editBudEntry.text == ""){
            backgroundView.isHidden = true
            editBudPopUp.isHidden = true
            view.endEditing(true)
        }
        else {
            if (addSubSelector.selectedSegmentIndex == 0){
                 budgetValue = budgetValue + (NumberFormatter().number(from: editBudEntry.text!)?.doubleValue)!
                let path = Bundle.main.path(forResource: "UserStorage", ofType: "plist")
                let dict = NSMutableDictionary(contentsOfFile: path!)!
                dict.setValue(budgetValue, forKey: "budgetVal")
                dict.setValue(spentValue, forKey: "spentVal")
                availValue = budgetValue - spentValue
                dict.setValue(availValue, forKey: "availVal")
                dict.write(toFile: path!, atomically: true)
                displayBudget()
                backgroundView.isHidden = true
                editBudPopUp.isHidden = true
                view.endEditing(true)

            }
            else {
                if (budgetValue - (NumberFormatter().number(from: editBudEntry.text!)?.doubleValue)! > 0){
                   budgetValue = budgetValue - (NumberFormatter().number(from: editBudEntry.text!)?.doubleValue)!
                    let path = Bundle.main.path(forResource: "UserStorage", ofType: "plist")
                    let dict = NSMutableDictionary(contentsOfFile: path!)!
                    dict.setValue(budgetValue, forKey: "budgetVal")
                    dict.setValue(spentValue, forKey: "spentVal")
                    availValue = budgetValue - spentValue
                    dict.setValue(availValue, forKey: "availVal")
                    dict.write(toFile: path!, atomically: true)
                    displayBudget()
                    backgroundView.isHidden = true
                    editBudPopUp.isHidden = true
                    view.endEditing(true)
                }
            }
        }
    }
    
    func displayBudget(){
        let path = Bundle.main.path(forResource: "UserStorage", ofType: "plist")
        let dict = NSMutableDictionary(contentsOfFile: path!)!
        budgetValue = dict.object(forKey: "budgetVal") as! Double
        spentValue = dict.object(forKey: "spentVal") as! Double
        availValue = dict.object(forKey: "availVal") as! Double
        budgetValLabel.text = "$" + String(format:"%.2f", budgetValue)
        spentValLabel.text = "$" + String(format:"%.2f", spentValue)
        availValLabel.text = "$" + String(format:"%.2f", availValue)
    }
}
