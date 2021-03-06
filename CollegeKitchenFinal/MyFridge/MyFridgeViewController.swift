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
            let myCell:myFridgeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "fridgeCell")! as! myFridgeTableViewCell
            let ingredient = myFridgeIngredients[indexPath.row]
            myCell.displayCell(name: ingredient.name!, amount: ingredient.amount!, unit: ingredient.unit!)
            return myCell
        }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myFridgeIngredients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let path = Bundle.main.path(forResource: "UserStorage", ofType: "plist")
            let dict = NSMutableDictionary(contentsOfFile: path!)!
            var currentList = dict.object(forKey: "myFridge") as! Array<Data>
            currentList.remove(at: indexPath.row)
            dict.setValue(currentList, forKey: "myFridge")
            dict.write(toFile: path!, atomically: true)
            updateIngredients()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
        func updateIngredients(){
           myFridgeIngredients = []
            let path = Bundle.main.path(forResource: "UserStorage", ofType: "plist")
            let dict = NSMutableDictionary(contentsOfFile: path!)!
            let currentList = dict.object(forKey: "myFridge") as! Array<Data>

            for eachIngredient in currentList {
                let jsonDecoder = JSONDecoder()
                let thisIngredient:Ingredient = try! jsonDecoder.decode(Ingredient.self, from: eachIngredient)
                myFridgeIngredients.append(thisIngredient)
        }
    }
        
        override func viewDidLoad() {
            
            super.viewDidLoad()
            updateIngredients()
           
            self.myFridgeTableView.delegate=self
            self.myFridgeTableView.dataSource=self

        }

    override func viewDidAppear(_ animated: Bool) {
         updateIngredients()
        myFridgeTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateIngredients()
        myFridgeTableView.reloadData()
    }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
    }



