//
//  myRecipeVC.swift
//  CollegeKitchenFinal
//
//  Created by Sophie Bishopp on 12/2/18.
//  Copyright © 2018 Julia Downey. All rights reserved.
//

import UIKit

class myRecipeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var myRecipeCollectionView: UICollectionView!
    
    var recipeDetails:RecipeDetails?
    var currentRecipeDetails:RecipeDetails?
    var recipeImageCache:[UIImage] = []
    var savedRecipesArray: [RecipeDetails] = []  //Array of Recipe Details - Ones that will be saved
    
    
    
    //Set up collection view
    func setUpCollectionView(){
        myRecipeCollectionView.dataSource = self
        myRecipeCollectionView.delegate = self
        myRecipeCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "myRecipeCell")
    }
    
    
    //Putting saved movies into an array
    func getSavedRecipes(){
        savedRecipesArray.removeAll()
        let path = Bundle.main.path(forResource: "UserStorage", ofType: "plist")
        let dict:AnyObject = NSMutableDictionary(contentsOfFile: path!)!
        
        let savedArray = dict.object(forKey: "myRecipe") as! Array<Data>
        
        for data in savedArray{
            let input = try! JSONDecoder().decode(RecipeDetails.self, from: data)
            savedRecipesArray.append(input)
            print(input.title)
            getRecipeImages(imageArray: savedRecipesArray)
        }
    }
    
    func getRecipeImages(imageArray: [RecipeDetails]){
        recipeImageCache = []
        for item in imageArray{
            if item.image != ""{
                let url = URL(string: item.image)
                let data = try? Data(contentsOf: url!)
                let recipeImage = UIImage(data: data!)
                recipeImageCache.append(recipeImage!)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return savedRecipesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let recipeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "myRecipeCell", for: indexPath)
        
        //Add Image to Cell
        let theImage = recipeImageCache[indexPath.row]
        let imageView = UIImageView(image: theImage)
        imageView.frame = recipeCell.bounds
        recipeCell.contentView.addSubview(imageView)
        
        //Add title to each cell
        let text = UILabel(frame: CGRect(x: 0, y: recipeCell.frame.height-recipeCell.frame.height/3.5 , width: recipeCell.frame.width, height: recipeCell.frame.height/3))
        text.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        text.textAlignment = .center
        text.textColor = UIColor.white
        text.numberOfLines = 0
        text.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
        text.text = savedRecipesArray[indexPath.row].title
        recipeCell.contentView.addSubview(text)
        
        return recipeCell
    }
    
//    //When you click on a recipe cell
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let descriptionVC = RecipeDetailsViewController()
        descriptionVC.saved = true
        descriptionVC.currentRecipeDetails = savedRecipesArray[indexPath.row]
        navigationController?.pushViewController(descriptionVC, animated: true)
    }

     override func viewWillAppear(_ animated: Bool) {
        getSavedRecipes()
        myRecipeCollectionView.reloadData()
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
