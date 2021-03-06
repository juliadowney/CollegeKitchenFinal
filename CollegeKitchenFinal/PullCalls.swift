//
//  PullsFromAPI.swift
//  CollegeKitchenFinal
//
//  Created by Maya Menon on 11/19/18.
//  Copyright © 2018 Julia Downey. All rights reserved.
//

import UIKit
import Foundation

class PullCalls {
    
    
    // INGREDIENT SEARCH
    typealias SearchResult = ([IngredientSearch]) -> ()
    
    func ingredientSearch(query: String, completion: @escaping SearchResult){
        var searchIngredients:[IngredientSearch] = []
        let editedQuery = (query).replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)

        let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/food/ingredients/autocomplete?query=" + editedQuery

        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        request.addValue("kX0oe5UPsGmsh4IvUqlXBP1Gr6USp1Oub8SjsnmwjLrnCRGq8x",forHTTPHeaderField: "X-Mashape-Key")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        let session = URLSession(configuration: .default)
        request.httpMethod = "GET"
        let tache = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let jsonData = data {
                let json = JSONDecoder()
                let search = try! json.decode([IngredientSearch].self, from: jsonData)
                for ingredient in search{
                    searchIngredients.append(ingredient)
                }
                DispatchQueue.main.async {
                    completion(searchIngredients)
                }
            }
        }
        session.finishTasksAndInvalidate()
        tache.resume()
    }
  
    typealias convertedAmountResult = (ConvertedAmount) -> ()

    func convertAmounts(ingredientName: String, sourceAmount: Double, sourceUnit: String, targetUnit: String, completion: @escaping convertedAmountResult){
        var convertedAmount:ConvertedAmount!
        let mainUrl = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/convert?"
        let editedIngredientName = (ingredientName).replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        let ingredientNameUrl = "ingredientName=" + editedIngredientName
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
                convertedAmount = search
                DispatchQueue.main.async {
                    completion(convertedAmount)
                }
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
                continue
            }
            guard let scapedValue = value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {

                continue
            }
            paramList.append("\(scapedKey)=\(scapedValue)")
        }
        return paramList.joined(separator: "&")
    }
    
    typealias ingredientObjectResult = (Ingredient) -> ()

    func parseIngredient(ingredientName: String, servings: Int, completion: @escaping ingredientObjectResult){
        var newIngredient:Ingredient!
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
                if (res.statusCode == 200){
                    if let jsonData = data {
                        let json = JSONDecoder()
                        var search = try? json.decode([Ingredient].self, from: jsonData)
                        newIngredient = search?.popLast()
                        DispatchQueue.main.async {
                            completion(newIngredient)
                        }
                    }
                }
            }
        }
        tache.resume()
    }
    typealias estimatedCostResult = (EstimatedCost) -> ()

    func getEstimatedCost(id: Int, amount: Double, unit: String, completion: @escaping estimatedCostResult){
        var estimatedCost:EstimatedCost!
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
                estimatedCost = search?.estimatedCost
                DispatchQueue.main.async {
                    completion(estimatedCost)
                }
            }
        }
        tache.resume()
    }
    
    typealias getRecipesResult = ([Recipe]) -> ()
    func getRecipesByIngredients(fillIngredients: Bool, ingredients: [String], limitLicense: Bool, number: Int, ranking: Int, completion: @escaping getRecipesResult){
        var recipeResults:[Recipe] = []
        let separatedIngredientsForUrl = ingredients.joined(separator: "%2C")
        let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/findByIngredients?fillIngredients=" + fillIngredients.description + "&ingredients=" + separatedIngredientsForUrl + "&limitLicense=" + limitLicense.description + "&number=" + String(number) + "&ranking=" + String(ranking)
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        request.addValue("kX0oe5UPsGmsh4IvUqlXBP1Gr6USp1Oub8SjsnmwjLrnCRGq8x",forHTTPHeaderField: "X-Mashape-Key")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        request.httpMethod = "GET"
        let tache = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let jsonData = data {
                let json = JSONDecoder()
                guard let search = try? json.decode([Recipe].self, from: jsonData) else {
                    return
                }
                for recipe in search{
                    recipeResults.append(recipe)
                }
                DispatchQueue.main.async {
                    completion(recipeResults)
                }
            }
        }
        tache.resume()
    }
    
    typealias getRecipesDetailsResult = (RecipeDetails?) -> ()

    func getRecipeDetails(id: Int, completion: @escaping getRecipesDetailsResult){
        
        var thisRecipeDetails:RecipeDetails!
        
        let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/" + String(id) + "/information?includeNutrition=false"
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        request.addValue("kX0oe5UPsGmsh4IvUqlXBP1Gr6USp1Oub8SjsnmwjLrnCRGq8x",forHTTPHeaderField: "X-Mashape-Key")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        request.httpMethod = "GET"
        let tache = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let jsonData = data {
                let json = JSONDecoder()
                thisRecipeDetails = try? json.decode(RecipeDetails.self, from: jsonData)
                DispatchQueue.main.async {
                    completion(thisRecipeDetails)
                }
            }
        }
        tache.resume()
    }
    
    typealias getJoke = (Joke) -> ()

    func getFoodJoke(completion: @escaping getJoke){
        var returnJoke: Joke!
        let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/food/jokes/random"
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        request.addValue("kX0oe5UPsGmsh4IvUqlXBP1Gr6USp1Oub8SjsnmwjLrnCRGq8x",forHTTPHeaderField: "X-Mashape-Key")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        request.httpMethod = "GET"
        let tache = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let jsonData = data {
                let json = JSONDecoder()
                returnJoke = try? json.decode(Joke.self, from: jsonData)
                DispatchQueue.main.async {
                    completion(returnJoke)
                }
            }
        }
        tache.resume()
    }
}
