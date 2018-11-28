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
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeIngredients: UILabel!
    
    //Save Recipe Button 
    @IBAction func saveRecipe(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeIngredients.numberOfLines = 0;
        

        setUpRecipeDetails()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpRecipeDetails(){
      
        let imageURL = URL(string:currentRecipeDetails.image)
        let data = NSData(contentsOf: imageURL!)
        recipeImage.image =  UIImage(data: data! as Data)
        setUpIngredients()
    }
  
    func setUpIngredients(){
        recipeIngredientsArray = currentRecipeDetails.extendedIngredients
        
        for ingredient in recipeIngredientsArray{
            
            var ingredientUnit:String = ""
            let ingredientAmount = String(format:"%2.f", ingredient.amount!) + " "
            
            if ((ingredient.unitLong) != nil) {
            ingredientUnit = ingredient.unitLong! + " "
            }
            
            let ingredientName = ingredient.name! + " \n"
            recipeIngredients.text = recipeIngredients.text! + ingredientAmount + ingredientUnit + ingredientName
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
