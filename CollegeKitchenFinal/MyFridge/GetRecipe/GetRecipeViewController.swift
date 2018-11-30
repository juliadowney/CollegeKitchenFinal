//
//  GetRecipeTableViewController.swift
//  CollegeKitchenFinal
//
//  Created by Maya Menon on 11/24/18.
//  Copyright © 2018 Julia Downey. All rights reserved.
//

import UIKit

class GetRecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var getRecipeArray:[Recipe] = []
    var thisRecipe:Recipe!
    var fridgeIngredients:[Ingredient] = []
    var fridgeIngredientNames:[String]=[]
    let pull = PullCalls()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var theTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theTableView.dataSource = self
        theTableView.delegate = self
        activityIndicator.backgroundColor = UIColor.white
        activityIndicator.frame = CGRect(x: view.frame.minX, y: theTableView.frame.minY, width: view.frame.width, height: view.frame.height)
        view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black

        getRecipe()
        theTableView.rowHeight = 70

    }
    
    func getRecipe(){
        
        getFridgeIngredients()
        
        activityIndicator.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            self.getRecipeArray.removeAll() // clears the current search ingredient array
            
            // pull ingredients from API (pull is an 'object' of PullCalls as declared in beginning of this file)
            self.pull.getRecipesByIngredients(fillIngredients: false, ingredients: self.fridgeIngredientNames, limitLicense: false, number: 10, ranking: 5 ) {searchedRecipes in
                
                self.getRecipeArray = searchedRecipes
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.theTableView.reloadData()
                }
            }
        }
    }
    
    // gets fridge Ingredients from plist and converts them to strings for getRecipe method()
    func getFridgeIngredients(){
        fridgeIngredients = []
        fridgeIngredientNames = []
        let path = Bundle.main.path(forResource: "UserStorage", ofType: "plist")
        let dict = NSMutableDictionary(contentsOfFile: path!)!
        let currentList = dict.object(forKey: "myFridge") as! Array<Data>
        for eachIngredient in currentList {
            let jsonDecoder = JSONDecoder()
            let thisIngredient:Ingredient = try! jsonDecoder.decode(Ingredient.self, from: eachIngredient)
            fridgeIngredients.append(thisIngredient)
        }
        
        for eachIngredient in fridgeIngredients{
            let editedName = (eachIngredient.name)?.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            fridgeIngredientNames.append(editedName!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return getRecipeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "getRecipeCell")! as! GetRecipeTableViewCell
        
       myCell.displayCell(recipeName: getRecipeArray[indexPath.row].title, recipeImageString: getRecipeArray[indexPath.row].image)
        return myCell
    }
    
    var thisRecipeDetails:RecipeDetails!

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("above dispatch")
        activityIndicator.startAnimating()

            DispatchQueue.global(qos: .userInitiated).async {
                print("in dispatch")
                self.pull.getRecipeDetails(id: self.getRecipeArray[indexPath.row].id){pullRecipeDetails in
                    self.thisRecipeDetails = pullRecipeDetails
                    print("got pull")
                
                DispatchQueue.main.async {
                    
                    self.theTableView.reloadData()

                    print ("in main")
                    print (self.thisRecipeDetails)
                    print("^^^^^^^^^^^^^^^^^^^^")
                    let vc = RecipeDetailsViewController()
                    vc.currentRecipeDetails = self.thisRecipeDetails
                    self.activityIndicator.stopAnimating()
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                }
            }
        
     
        }
  
    
    
    
}
