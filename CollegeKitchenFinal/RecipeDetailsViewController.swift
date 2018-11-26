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
    var currentRecipe:Recipe!
    var currentRecipeDetails:RecipeDetails!
    var recipeIngredients:[Ingredient]!

    override func viewDidLoad() {
        super.viewDidLoad()
        getRecipeDetails()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getRecipeDetails() {
        
        pull.getRecipeDetails(id: currentRecipe.id){recipeDetailPull in
            self.currentRecipeDetails = recipeDetailPull
        }
        print ("HEEEEEEEEEEEEEEERE")
        print (currentRecipeDetails)
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
