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
        let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/food/ingredients/autocomplete?query=" + query
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        request.addValue("kX0oe5UPsGmsh4IvUqlXBP1Gr6USp1Oub8SjsnmwjLrnCRGq8x",forHTTPHeaderField: "X-Mashape-Key")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        let session = URLSession(configuration: .default)
        request.httpMethod = "GET"
        print(2)
        let tache = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let jsonData = data {
              
                let json = JSONDecoder()
                let search = try! json.decode([IngredientSearch].self, from: jsonData)
              
                for ingredient in search{
               
                    searchIngredients.append(ingredient)
                   
                    DispatchQueue.main.async {
                       completion(searchIngredients)
                    }
                    
                }
                
            }
            
        }
        session.finishTasksAndInvalidate()
        tache.resume()
        
        
    }
}
