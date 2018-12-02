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
    
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    
    @IBOutlet weak var recipeInstructions: UILabel!
    @IBOutlet weak var recipeIngredients: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeIngredients.numberOfLines = 0;
        recipeInstructions.numberOfLines = 0; 

        setUpRecipeDetails()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save Recipe", style: .done, target: self, action: #selector(saveRecipeAction))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white

        // Do any additional setup after loading the view.
    }
    
    /// Saving recipe to plist
    @objc func saveRecipeAction(){
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
        
        let newArray = dict.object(forKey: "myRecipe") as! Array<Data>
        print(newArray)
        
        print("saved")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpRecipeDetails(){
        recipeTitle.text = currentRecipeDetails.title
        let imageURL = URL(string:currentRecipeDetails.image)
        let data = NSData(contentsOf: imageURL!)
        recipeImage.image =  UIImage(data: data! as Data)
        setUpIngredients()
        recipeInstructions.text = currentRecipeDetails.instructions
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
