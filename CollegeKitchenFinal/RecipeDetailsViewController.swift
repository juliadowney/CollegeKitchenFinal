//
//  RecipeDetailsViewController.swift
//  CollegeKitchenFinal
//
//  Created by Maya Menon on 11/26/18.
//  Copyright © 2018 Julia Downey. All rights reserved.
//

import UIKit

class RecipeDetailsViewController: UIViewController {
    
    let pull = PullCalls()
    var currentRecipeDetails:RecipeDetails!
    var recipeIngredientsArray:[Ingredient]!
    var saved: Bool?
    
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var vegetarianLabel: UILabel!
    @IBOutlet weak var cookTimeLabel: UILabel!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var readyInLabel: UILabel!
    
    @IBOutlet weak var recipeInstructions: UILabel!
    @IBOutlet weak var recipeIngredients: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeIngredients.numberOfLines = 0;
        recipeInstructions.numberOfLines = 0; 

        setUpRecipeDetails()
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white

        if(saved)!{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Unsave Recipe", style: .done, target: self, action: #selector(saveRecipeAction))
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save Recipe", style: .done, target: self, action: #selector(saveRecipeAction))
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        }
    }
    
    /// SOPHIE EDIT THIS
    @objc func saveRecipeAction(){
        
        if(saved)!{
            
            let path = Bundle.main.path(forResource: "UserStorage", ofType: "plist")
            let dict = NSMutableDictionary(contentsOfFile: path!)!
            var currentList = dict.object(forKey: "myRecipe") as! Array<Data>
            
            for(index,data) in currentList.enumerated(){
                let input = try! JSONDecoder().decode(RecipeDetails.self, from: data)
                if(input.title == currentRecipeDetails.title){
                    currentList.remove(at:index)
                }
            }
            
            dict.setValue(currentList, forKey: "myRecipe")
            _ = dict.write(toFile: path!, atomically:true)
            
            navigationController?.popViewController(animated: true)
        }else{
            var recipeInList = false
            
            let path = Bundle.main.path(forResource: "UserStorage", ofType: "plist")
            let dict = NSMutableDictionary(contentsOfFile: path!)!
            let jsonnData = try! JSONEncoder().encode(currentRecipeDetails)
            var currentList = dict.object(forKey: "myRecipe") as! Array<Data>
            
            for eachRecipe in currentList{
                let thisRecipe = try! JSONDecoder().decode(RecipeDetails.self, from: eachRecipe)
                if(thisRecipe.title == self.currentRecipeDetails.title){
                    recipeInList = true
                }
            }
            if(recipeInList == false){
                currentList.append(jsonnData)
            }
            dict.setValue(currentList, forKey: "myRecipe")
            _ = dict.write(toFile: path!, atomically:true)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func setUpRecipeDetails(){
        recipeTitle.text = currentRecipeDetails.title
        let imageURL = URL(string:currentRecipeDetails.image)
        let data = NSData(contentsOf: imageURL!)
        recipeImage.image =  UIImage(data: data! as Data)
        setUpIngredients()
        recipeInstructions.text = currentRecipeDetails.instructions
        servingsLabel.text = String(currentRecipeDetails.servings)
        if (currentRecipeDetails.vegetarian){
            vegetarianLabel.text = "Yes"
        }
        else {
            vegetarianLabel.text = "No"
        }
        cookTimeLabel.text = String(currentRecipeDetails.cookingMinutes) + " minutes"
        prepTimeLabel.text = String(currentRecipeDetails.preparationMinutes) + " minutes"
        readyInLabel.text = String(currentRecipeDetails.readyInMinutes) + " minutes"
        
    }
  
    func setUpIngredients(){
        recipeIngredientsArray = currentRecipeDetails.extendedIngredients
        
        for ingredient in recipeIngredientsArray{
            
            var ingredientUnit:String = ""
            let ingredientAmount = String(format:"%.2f", ingredient.amount!) + " "
            
            if ((ingredient.unit) != nil) {
            ingredientUnit = ingredient.unit! + " "
            }
            
            let ingredientName = ingredient.name! + " \n"
            recipeIngredients.text = recipeIngredients.text! + ingredientAmount + ingredientUnit + ingredientName
        }
    }
    
}
