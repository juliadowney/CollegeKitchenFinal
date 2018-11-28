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
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

    
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
        activityIndicator.startAnimating()
        let quantity = Double(self.quantityText.text!)


        var convertedServings:ConvertedAmount!
        
            self.pull.convertAmounts(ingredientName: self.currentIngredient.name, sourceAmount: quantity!, sourceUnit: self.unitText.text!, targetUnit: "servings") {convertedAmount in
                convertedServings = convertedAmount
                print (self.currentIngredient.name)
                print ((convertedServings.targetAmount))
                self.pull.parseIngredient(ingredientName: self.currentIngredient.name, servings: Int(convertedServings.targetAmount)){newObject in
                    let newIngredient:Ingredient = Ingredient(id: newObject.id!, name: newObject.name!, amount: quantity, unit: self.unitText.text!)
                    
                        print (newIngredient)
                    //// PLIST - newIngredient needs to be stored in myFridge plist
                        let path = Bundle.main.path(forResource: "UserStorage", ofType: "plist")
                        let dict = NSMutableDictionary(contentsOfFile: path!)!
                        var currentList = dict.object(forKey: "myFridge") as! Array<Data>
                        let data = try! JSONEncoder().encode(newIngredient)
                        currentList.append(data)
                    
                        dict.setValue(currentList, forKey: "myFridge")
                        dict.write(toFile: path!, atomically: true)

                    self.pull.getEstimatedCost(id: newIngredient.id!, amount: newIngredient.amount!, unit: newIngredient.unit!){estimatedCostResult in
                            let estimatedCost:EstimatedCost = estimatedCostResult
                            print (estimatedCost)
                        //// PLIST - estimatedCost needs to be subtracted from budget plist (keep mind of US Cents vs US Dollars)
                        self.backgroundWindow.isHidden = true
                        self.setView(view: self.popUpWindow, hidden: true)

                        DispatchQueue.global(qos: .userInitiated).async {

                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                        self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
            }
            }
        }
        
        
    }
    
    
    // SEARCH BAR
    func searchBarSearchButtonClicked(_ sender: UISearchBar) {
        activityIndicator.startAnimating()
        view.endEditing(true) // closes the keyboard
        let searchString = self.searchBar.text! // text from search bar
        print("above dispatch")
        DispatchQueue.global(qos: .userInitiated).async {
            
            self.searchIngredients.removeAll() // clears the current search ingredient array
            print("in dispatch")
            // pull ingredients from API (pull is an 'object' of PullCalls as declared in beginning of this file)
            self.pull.ingredientSearch(query: searchString) {searchedIngredients in
                print("got pull")
            self.searchIngredients = searchedIngredients
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    print("in main")
                    self.theTableView.reloadData()
                }
        }
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
        
        setView(view: popUpWindow, hidden: false)// unhides the popup
        currentIngredient = searchIngredients[indexPath.row]
        popUpTitle.text = currentIngredient.name.capitalized // updates the popup title
        
    }
    
    @objc func cancelAddItem(){
        navigationItem.hidesBackButton = false
        backgroundWindow.isHidden = true
        backgroundWindow.isUserInteractionEnabled = false
        setView(view: popUpWindow, hidden: true)
        unitPicker.isHidden = true
        self.navigationItem.rightBarButtonItem = nil
        
    }
 //   https://stackoverflow.com/questions/9115854/uiview-hide-show-with-animation
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        backgroundWindow.isHidden = true
        backgroundWindow.isUserInteractionEnabled = false
        popUpWindow.isHidden=true
        unitPicker.isHidden = true
        self.navigationItem.rightBarButtonItem = nil

        activityIndicator.backgroundColor = UIColor.white
        activityIndicator.frame = CGRect(x: view.frame.minX, y: theTableView.frame.minY, width: view.frame.width, height: view.frame.height - searchBar.frame.height*2)
        view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
        
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
