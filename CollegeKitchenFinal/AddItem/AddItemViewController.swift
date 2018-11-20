//
//  AddItemViewController.swift
//  CollegeKitchenFinal
//
//  Created by Maya Menon on 11/19/18.
//  Copyright © 2018 Julia Downey. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var theTableView: UITableView!
    var myArray = ["Mary", "Billy", "Jane"]
    let pull=Functions()
    var searchIngredients:[IngredientSearch] = []

    @IBOutlet weak var searchBar: UISearchBar!
    
    func searchBarSearchButtonClicked(_ sender: UISearchBar) {
        
        searchIngredients.removeAll()
        
        self.theTableView.reloadData()
        
        let searchString = searchBar.text!
        pull.ingredientSearch(query: searchString) {searchedIngredients in
            self.searchIngredients = searchedIngredients
            self.theTableView.reloadData()
        }
        
        
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchIngredients.count-1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! AddItemTableViewCell
       // print(searchIngredients[indexPath.row].name)
        print (searchIngredients[indexPath.row].name)
        print(searchIngredients[indexPath.row].image)
      //  myCell.displayCell()
        
        // LINDSEY edit this - image name is stored in seachIngredients[indexPath.row].image
       myCell.displayCell(searchName: searchIngredients[indexPath.row].name)
        
        return myCell
    }
    
  
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      //self.theTableView.register(AddItemTableViewCell.self, forCellReuseIdentifier: "theCell")
        self.searchBar.delegate = self
        self.theTableView.dataSource = self
        self.theTableView.delegate = self
        theTableView.rowHeight = 68
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
