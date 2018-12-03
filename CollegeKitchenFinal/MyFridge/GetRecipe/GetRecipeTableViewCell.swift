//
//  GetRecipeTableViewCell.swift
//  CollegeKitchenFinal
//
//  Created by Maya Menon on 11/24/18.
//  Copyright © 2018 Julia Downey. All rights reserved.
//

import UIKit

class GetRecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var recipeTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func displayCell(recipeName:String, recipeImageString:String){
        recipeTitle.text = recipeName.capitalized
        
        let imageName  =  recipeImageString
        
        let imageURL = URL(string:imageName)
        let data = NSData(contentsOf: imageURL!)
        recipeImage.image =  UIImage(data: data! as Data)
       
    }
}
