//
//  MyBudgetViewController.swift
//  CollegeKitchenFinal
//
//  Created by Maya Menon on 11/21/18.
//  Copyright © 2018 Julia Downey. All rights reserved.
//

import UIKit

class MyBudgetViewController: UIViewController {
    
    var budgetValue:Double = 0
    var spentValue:Double = 0
    var availValue:Double = 0

    @IBOutlet weak var budgetValLabel: UILabel!
    @IBOutlet weak var spentValLabel: UILabel!
    @IBOutlet weak var availValLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var editBudPopUp: UIView!
    @IBOutlet weak var addSubSelector: UISegmentedControl!
    @IBOutlet weak var editBudEntry: UITextField!
    
    @IBOutlet weak var resetBudPopUp: UIView!
    @IBOutlet weak var resetBudEntry: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayBudget()
        backgroundView.isHidden = true
        resetBudPopUp.isHidden = true
        editBudPopUp.isHidden = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func resetBudget(_ sender: Any) {
        backgroundView.isHidden = false
        resetBudPopUp.isHidden = false
        
    }
    
    @IBAction func editBudget(_ sender: Any) {
        backgroundView.isHidden=false
        editBudPopUp.isHidden=false
    }
    
    @IBAction func doneEditingBudget(_ sender: Any) {
        if (editBudEntry.text == ""){
            backgroundView.isHidden = true
            editBudPopUp.isHidden = true
        }
        else {
            if (addSubSelector.selectedSegmentIndex == 0){
                 budgetValue = budgetValue + (NumberFormatter().number(from: editBudEntry.text!)?.doubleValue)!
                displayBudget()
                backgroundView.isHidden = true
                editBudPopUp.isHidden = true
            }
            else {
                if (budgetValue - (NumberFormatter().number(from: editBudEntry.text!)?.doubleValue)! > 0){
                   budgetValue = budgetValue - (NumberFormatter().number(from: editBudEntry.text!)?.doubleValue)!
                displayBudget()
                backgroundView.isHidden = true
               editBudPopUp.isHidden = true
                }
                
            }
           
      
            
        }
        
    }
    
    func displayBudget(){
        availValue = budgetValue - spentValue
        budgetValLabel.text = "$" + String(format:"%2.f", budgetValue)
        spentValLabel.text = "$" + String(format:"%2.f", spentValue)
        availValLabel.text = "$" + String(format:"%2.f", availValue)
    }
    
    @IBAction func doneResetBudget(_ sender: Any) {
        
        if (resetBudEntry.text == ""){
            backgroundView.isHidden = true
            resetBudPopUp.isHidden = true
        }
        else{
            budgetValue = (NumberFormatter().number(from: resetBudEntry.text!)?.doubleValue)!
            spentValue = 0.0
            displayBudget()
            backgroundView.isHidden = true
            resetBudPopUp.isHidden = true
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
