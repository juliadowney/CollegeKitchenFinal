//
//  AddItemViewController.swift
//  CollegeKitchenFinal
//
//  Created by Maya Menon on 11/19/18.
//  Copyright © 2018 Julia Downey. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var theTableView: UITableView! // table view of items when searching ingredients to add
    @IBOutlet weak var searchBar: UISearchBar! // the searchbar
    let pull=PullCalls() // the PullCalls file where API Requests are handled
    @IBOutlet weak var typeToSearchLabel: UILabel!
    var searchIngredients:[IngredientSearch] = [] // the array where the current searchedIngredients are stored


    
    // ITEMS FOR POPUP WINDOW WHEN YOU CLICK AN ITEM TO ADD TO FRIDGE
    @IBOutlet weak var backgroundWindow: UIView! // the view that pops up to darken the background
    @IBOutlet weak var popUpWindow: UIView! // the actual pop up window
    @IBOutlet weak var popUpTitle: UILabel! // the title on the pop up window with the name of the food
    @IBOutlet weak var unitPicker: UIPickerView! // the picker of units when you're adding an item in popup
    @IBOutlet weak var unitText: UITextField! // the unit textbox in popup
    @IBOutlet weak var quantityText: UITextField! // the quanitity textbox in popup
    var currentIngredient:IngredientSearch!
    
    var unitOptions:[String] = ["ounces", "grams","milliliters","pints", "pounds","cups", "liters", "teaspoons", "package", "tablespoons"] // current picker options - can change

    
    //UNIT PICKER
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return unitOptions.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return unitOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        unitText.text = unitOptions[row]
    }
    
    /*
     selectUnit is called when a user tries to select the unit in the popup window
 */
    @IBAction func selectUnit(_ sender: Any) {
        
        popUpWindow.isUserInteractionEnabled = false // prevents user from editing anything else in popup window so they can only interact with picker
        unitPicker.isHidden = false // unhides picker
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(closePicker)) // adds a Done button to the nav bar so we know when user is done selecting
    }
    
    /*
     closePicker is called when a user is done using picker and selects 'Done' in nav bar
     */
    @objc func closePicker(){
        unitPicker.isHidden = true // hides the picker
        popUpWindow.isUserInteractionEnabled = true // re-enables the popup window
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelAddItem)) // hides the Done button on the nav bar
        
    }
    
    //EDITING QUANTITY
    
    @IBAction func editingQuantity(_ sender: Any) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneEditingQuantity))
    }
    
    @objc func doneEditingQuantity(){
        view.endEditing(true) // closes the keyboard
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelAddItem)) // hides the Done button on the nav bar

    }
    
    
    @IBAction func doneAddingItem(_ sender: Any) {
        var convertedServings:ConvertedAmount!
        let quantity = Double(quantityText.text!)
        pull.convertAmounts(ingredientName: currentIngredient.name, sourceAmount: quantity!, sourceUnit: unitText.text!, targetUnit: "servings") {convertedAmount in
            convertedServings = convertedAmount
            print (self.currentIngredient.name)
            print ((convertedServings.targetAmount))
            self.pull.parseIngredient(ingredientName: self.currentIngredient.name, servings: Int(convertedServings.targetAmount)){newObject in
                let newIngredient:Ingredient = newObject
                print (newIngredient)
               //// PLIST - newIngredient needs to be stored in myFridge plist
                
            }
        }
        
        
    }
    
    
    // SEARCH BAR
    func searchBarSearchButtonClicked(_ sender: UISearchBar) {
        
        searchIngredients.removeAll() // clears the current search ingredient array
         view.endEditing(true) // closes the keyboard
        self.theTableView.reloadData() // reloads the data - might not need
        let searchString = searchBar.text! // text from search bar
        
        // pull ingredients from API (pull is an 'object' of PullCalls as declared in beginning of this file)
        pull.ingredientSearch(query: searchString) {searchedIngredients in
            self.searchIngredients = searchedIngredients
            self.theTableView.reloadData()
        }
    }
   
    // TABLE VIEW FUNCTIONALITY
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchIngredients.count == 0){
            typeToSearchLabel.isHidden = false
        }
        else {
            typeToSearchLabel.isHidden = true
        }
        return searchIngredients.count-1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! AddItemTableViewCell
        print (searchIngredients[indexPath.row].name)
        print(searchIngredients[indexPath.row].image)
        
       myCell.displayCell(searchName: searchIngredients[indexPath.row].name, searchImage:searchIngredients[indexPath.row].image )
        
        return myCell
    }
    
    // when user clicks a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelAddItem))
        navigationItem.hidesBackButton = true
        theTableView.cellForRow(at: indexPath)?.isSelected = false // ends selecting of cell
        view.endEditing(true) // closes the keyboard
        backgroundWindow.isHidden=false //causes the dark background to appear
        backgroundWindow.isUserInteractionEnabled = true // enables it so the user can't interact with the table view while they interact with the popup
        
        popUpWindow.isHidden = false // unhides the popup
        currentIngredient = searchIngredients[indexPath.row]
        popUpTitle.text = currentIngredient.name // updates the popup title
        
    }
    
    @objc func cancelAddItem(){
        navigationItem.hidesBackButton = false
        backgroundWindow.isHidden = true
        backgroundWindow.isUserInteractionEnabled = false
        popUpWindow.isHidden=true
        unitPicker.isHidden = true
        self.navigationItem.rightBarButtonItem = nil
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
   
        backgroundWindow.isHidden = true
        backgroundWindow.isUserInteractionEnabled = false
        popUpWindow.isHidden=true
        unitPicker.isHidden = true
        self.navigationItem.rightBarButtonItem = nil

        
        self.unitPicker.delegate = self
        self.unitPicker.dataSource = self
        self.searchBar.delegate = self
        self.theTableView.dataSource = self
        self.theTableView.delegate = self
        theTableView.rowHeight = 68
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
