//
//  RecipeInfoViewController.swift
//  CollegeKitchenFinal
//
//  Created by Maya Menon on 11/24/18.
//  Copyright © 2018 Julia Downey. All rights reserved.
//

import UIKit

class RecipeInfoViewController: UIViewController {
    
    var currentRecipe:Recipe!
    let pull = PullCalls()
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeTitle.text = currentRecipe.title
        
        let imageName  = "https://spoonacular.com/cdn/recipes_100x100/" + currentRecipe.image
        
        let imageURL = URL(string:imageName)
        let data = NSData(contentsOf: imageURL!)
        recipeImage.image =  UIImage(data: data! as Data)
        getRecipeDetails()
        
        // Do any additional setup after loading the view.
    }

    func getRecipeDetails(){
        pull.getRecipeDetails(id: currentRecipe.id){ pulledRecipeDetails in
            let recipeDetails:RecipeDetails = pulledRecipeDetails
            let recipeIngredients:[Ingredient] = recipeDetails.extendedIngredients
            for ingredient in recipeIngredients {
                ingredientLabel.text = ingredientLabel.text! + String(format:"%2.f", ingredient.amount!) + " " + ingredient.unitLong + " " + ingredient.name + " \n"
            }
            }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
