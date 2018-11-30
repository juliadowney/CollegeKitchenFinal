//
//  myRecipeViewController.swift
//  CollegeKitchenFinal
//
//  Created by Sophie Bishopp on 11/27/18.
//  Copyright © 2018 Julia Downey. All rights reserved.
//

import UIKit

private let reuseIdentifier = "myRecipeCell"

class myRecipeViewController: UICollectionViewController {
    
    var recipeDetails:RecipeDetails?
    var recipeImageCache:[UIImage] = []
    
    //Collection View
    @IBOutlet var myRecipeCollectionView: UICollectionView!
    
    //Array of Recipe Details - Ones that will be saved
    var savedRecipesArray: [RecipeDetails] = []
    
    //Set up collection view
    func setUpCollectionView(){
        myRecipeCollectionView.dataSource = self
        myRecipeCollectionView.delegate = self
        myRecipeCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "myRecipeCell")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Get Recipe Images
    //func getRecipeImage(){
     //
    //}


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedRecipesArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Creates Cell
        let recipeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "myRecipeCell", for: indexPath)
        
        //Add Image to Cell
        let url = URL(string: recipeDetails!.image)
        let data = try? Data(contentsOf: url!)
        let recipeImage = UIImage(data: data!)
        let imageView = UIImageView(image: recipeImage)
        imageView.frame = recipeCell.bounds
        recipeCell.contentView.addSubview(imageView)
        
        //Add title to each cell
        let text = UILabel(frame: CGRect(x: 0, y: recipeCell.frame.height-recipeCell.frame.height/3.5 , width: recipeCell.frame.width, height: recipeCell.frame.height/3))
        text.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        text.textAlignment = .center
        text.textColor = UIColor.white
        text.numberOfLines = 0
        text.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
        text.text = recipeDetails!.title
        recipeCell.contentView.addSubview(text)
    
        return recipeCell
    }
    
    //Collection View Delegate Functions
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
