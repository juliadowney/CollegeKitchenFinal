//
//  MyFridgeViewController.swift
//  CollegeKitchenFinal
//
//  Created by Maya Menon on 11/20/18.
//  Copyright © 2018 Julia Downey. All rights reserved.
//

import UIKit

class MyFridgeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
       var myFridgeIngredients:[Ingredient] = []
        
    @IBOutlet weak var myFridgeTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return myFridgeIngredients.count
        }
        
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let myCell = tableView.dequeueReusableCell(withIdentifier: "theCell")! as UITableViewCell
            
            myCell.textLabel!.text = myFridgeIngredients[indexPath.row].name
            
            return myCell
        }
        
        
        
        
        func updateIngredients(){
            let ingredient1:Ingredient = Ingredient(id: 9252, name: "pear", amount: 65.0, unitLong: "servings")
            let ingredient2:Ingredient = Ingredient(id: 16057, name: "chickpea", amount: 132.0, unitLong: "servings")
            let ingredient3:Ingredient = Ingredient(id: 16063, name: "cowpea", amount: 126.0, unitLong: "servings")
            myFridgeIngredients.append(ingredient1)
            myFridgeIngredients.append(ingredient2)
            myFridgeIngredients.append(ingredient3)
            
        }
    
    
        
        override func viewDidLoad() {
            
            super.viewDidLoad()
            
            updateIngredients()
            self.myFridgeTableView.delegate=self
            self.myFridgeTableView.dataSource=self
            self.myFridgeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "theCell")

            // Do any additional setup after loading the view.
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        
    }



