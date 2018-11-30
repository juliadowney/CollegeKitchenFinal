//
//  RecipeDetails.swift
//  CollegeKitchen
//
//  Created by Lindsey Corydon on 11/9/18.
//  Copyright © 2018 Julia Downey. All rights reserved.
//

import Foundation

struct RecipeDetails: Codable {
    let vegetarian: Bool
    let preparationMinutes: Int
    let cookingMinutes: Int
    let extendedIngredients: [Ingredient]
    let id: Int
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let image: String
    let instructions: String
}
