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
    var currentRecipeDetails:RecipeDetails?
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
    
    //Putting saved movies into an array
    func getSavedRecipes(){
        savedRecipesArray.removeAll()
        let path = Bundle.main.path(forResource: "myRecipe", ofType: "plist")
        let dict:AnyObject = NSMutableDictionary(contentsOfFile: path!)!
        
        let savedArray = dict.object(forKey: "savedRecipesArray") as! Array<Data>
        
        for data in savedArray{
            let input = try! JSONDecoder().decode(RecipeDetails.self, from: data)
            savedRecipesArray.append(input)
            print(input.title)
        }
    }
    
    
    //Recipe Images:
//    recipeTitle.text = currentRecipeDetails.title
//    let imageURL = URL(string:currentRecipeDetails.image)
//    let data = NSData(contentsOf: imageURL!)
//    recipeImage.image =  UIImage(data: data! as Data)


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedRecipesArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Creates Cell
        let recipeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "myRecipeCell", for: indexPath)
        
        //Add Image to Cell
        let url = URL(string: currentRecipeDetails!.image)
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
        text.text = currentRecipeDetails!.title
        recipeCell.contentView.addSubview(text)
    
        return recipeCell
    }
    
    //When you click on a recipe cell 
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let descriptionVC = RecipeDetailsViewController()
        descriptionVC.currentRecipeDetails = savedRecipesArray[indexPath.row]
        navigationController?.pushViewController(descriptionVC, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionView()
        getSavedRecipes()
        myRecipeCollectionView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
