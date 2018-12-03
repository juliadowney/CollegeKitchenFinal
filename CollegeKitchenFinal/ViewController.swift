//
//  ViewController.swift
//  CollegeKitchen
//
//  Created by Julia Downey on 11/6/18.
//  Copyright © 2018 Julia Downey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var fridgeNum: UILabel!
    @IBOutlet weak var budgetCurr: UILabel!
    @IBOutlet weak var receipieNum: UILabel!
    @IBOutlet weak var joke: UILabel!
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    let pull=PullCalls()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.frame = joke.frame
        view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
        joke.numberOfLines = 0
        let path = Bundle.main.path(forResource: "UserStorage", ofType: "plist")
        let dict = NSMutableDictionary(contentsOfFile: path!)!
        let currentList = dict.object(forKey: "myFridge") as! Array<Data>
        let recipeList = dict.object(forKey: "myRecipe") as! Array<Data>
        receipieNum.text = String(recipeList.count)
        fridgeNum.text = String(currentList.count)
        budgetCurr.text = "$" + String(dict.object(forKey: "budgetVal") as! Double)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let path = Bundle.main.path(forResource: "UserStorage", ofType: "plist")
        let dict = NSMutableDictionary(contentsOfFile: path!)!
        let currentList = dict.object(forKey: "myFridge") as! Array<Data>
        let recipeList = dict.object(forKey: "myRecipe") as! Array<Data>
        receipieNum.text = String(recipeList.count)
        fridgeNum.text = String(currentList.count)
        budgetCurr.text = "$"+String(dict.object(forKey: "budgetVal") as! Double)
        //once recipe works do that one too
        activityIndicator.startAnimating()
        joke.isHidden = true
        DispatchQueue.global(qos: .userInitiated).async {
            self.pull.getFoodJoke(){ returnJoke in
                DispatchQueue.main.async {
                    self.joke.text = returnJoke.text
                    self.activityIndicator.stopAnimating()
                    self.joke.isHidden = false
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

