//
//  ViewController.swift
//  CollegeKitchen
//
//  Created by Julia Downey on 11/6/18.
//  Copyright © 2018 Julia Downey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    func getIngredientSearch(query: String){
        let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/food/ingredients/autocomplete?query=" + query
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        request.addValue("kX0oe5UPsGmsh4IvUqlXBP1Gr6USp1Oub8SjsnmwjLrnCRGq8x",forHTTPHeaderField: "X-Mashape-Key")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        request.httpMethod = "GET"
        let tache = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let jsonData = data {
                let json = JSONDecoder()
                let search = try? json.decode([IngredientSearch].self, from: jsonData)
                for ingredient in search!{
                    print(ingredient)
                }
            }
        }
        print(2)
        tache.resume()
    }
    
    func convertAmounts(ingredientName: String, sourceAmount: Double, sourceUnit: String, targetUnit: String){
        let mainUrl = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/convert?"
        let ingredientNameUrl = "ingredientName=" + ingredientName
        let sourceAmountUrl = "&sourceAmount=" + String(sourceAmount)
        let sourceUnitUrl = "&sourceUnit=" + sourceUnit
        let targetUnitUrl = "&targetUnit=" + targetUnit
        let urlString = mainUrl + ingredientNameUrl + sourceAmountUrl + sourceUnitUrl + targetUnitUrl
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        request.addValue("kX0oe5UPsGmsh4IvUqlXBP1Gr6USp1Oub8SjsnmwjLrnCRGq8x",forHTTPHeaderField: "X-Mashape-Key")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        request.httpMethod = "GET"
        let tache = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let jsonData = data {
                let json = JSONDecoder()
                let search = try? json.decode(ConvertedAmount.self, from: jsonData)
                print(search!)
            }
        }
        tache.resume()
    }
    
    func convertToParameters(_ params: [String: String?]) -> String {
        var paramList: [String] = []
        for (key, value) in params {
            guard let value = value else {
                continue
            }
            guard let scapedKey = key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                print("Failed to convert key \(key)")
                continue
            }
            guard let scapedValue = value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                print("Failed to convert value \(value)")
                continue
            }
            paramList.append("\(scapedKey)=\(scapedValue)")
        }
        return paramList.joined(separator: "&")
    }
    
    func parseIngredient(ingredientName: String, servings: Int){
        let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/parseIngredients?includeNutrition=false"
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        request.addValue("kX0oe5UPsGmsh4IvUqlXBP1Gr6USp1Oub8SjsnmwjLrnCRGq8x",forHTTPHeaderField: "X-Mashape-Key")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        request.httpMethod = "POST"
        let params: [String: String?] = ["ingredientList": ingredientName,
                                   "servings": String(servings)]
        request.httpBody = convertToParameters(params).data(using: .utf8)
        let tache = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let res = response as? HTTPURLResponse{
                print("*******************HERE*******************")
                print(res.statusCode)
                if (res.statusCode == 200){
                    if let jsonData = data {
                        let json = JSONDecoder()
                        let search = try? json.decode([Ingredient].self, from: jsonData)
                        print(search!)
                    }
                }
                else{
                    print(error)
                }
            }
            
        }
        tache.resume()
    }
    
    func getEstimatedCost(id: Int, amount: Double, unit: String){
        let mainUrl = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/food/ingredients/"
        let idUrl = String(id) + "/information?"
        let amountUrl = "amount=" + String(amount)
        let unitUrl = "&unit=" + unit
        let urlString = mainUrl + idUrl + amountUrl + unitUrl
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        request.addValue("kX0oe5UPsGmsh4IvUqlXBP1Gr6USp1Oub8SjsnmwjLrnCRGq8x",forHTTPHeaderField: "X-Mashape-Key")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        request.httpMethod = "GET"
        let tache = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let jsonData = data {
                let json = JSONDecoder()
                let search = try? json.decode(EstimatedCostAPI.self, from: jsonData)
                print(search!)
            }
        }
        tache.resume()
    }
    
    func getRecipesByIngredients(fillIngredients: Bool, ingredients: [String], limitLicense: Bool, number: Int, ranking: Int){
        let separatedIngredientsForUrl = ingredients.joined(separator: "%2C")
        let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/findByIngredients?fillIngredients=" + fillIngredients.description + "&ingredients=" + separatedIngredientsForUrl + "&limitLicense=" + limitLicense.description + "&number=" + String(number) + "&ranking=" + String(ranking)
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        request.addValue("kX0oe5UPsGmsh4IvUqlXBP1Gr6USp1Oub8SjsnmwjLrnCRGq8x",forHTTPHeaderField: "X-Mashape-Key")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        request.httpMethod = "GET"
        let tache = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let jsonData = data {
                print(jsonData)
                let json = JSONDecoder()
                guard let search = try? json.decode([Recipe].self, from: jsonData) else {
                    print("nil search value")
                    return
                }
                for recipe in search{
                    print(recipe)
                }
            }
        }
        tache.resume()
    }
    
    func getRecipeDetails(id: Int){
        let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/" + String(id) + "/information?includeNutrition=false"
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        request.addValue("kX0oe5UPsGmsh4IvUqlXBP1Gr6USp1Oub8SjsnmwjLrnCRGq8x",forHTTPHeaderField: "X-Mashape-Key")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        request.httpMethod = "GET"
        let tache = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let jsonData = data {
                print(jsonData)
                let json = JSONDecoder()
                guard let search = try? json.decode(RecipeDetails.self, from: jsonData) else {
                    print("nil search value")
                    return
                }
                print(search)
            }
        }
        tache.resume()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getIngredientSearch(query: "appl")
//        convertAmounts(ingredientName: "flour", sourceAmount: 2.5, sourceUnit: "cups", targetUnit: "grams")
//        getEstimatedCost(id: 9266, amount: 100, unit: "gram")
//        parseIngredient(ingredientName: "apple", servings: 2)
//        getRecipesByIngredients(fillIngredients: false, ingredients: ["apples", "flour", "sugar"], limitLicense: false, number: 5, ranking: 1)
        getRecipeDetails(id: 479101)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

