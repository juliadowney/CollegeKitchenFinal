//
//  AddItemTableViewCell.swift
//  CollegeKitchenFinal
//
//  Created by Maya Menon on 11/20/18.
//  Copyright © 2018 Julia Downey. All rights reserved.
//

import UIKit

class AddItemTableViewCell: UITableViewCell {

    @IBOutlet weak var addItemImage: UIImageView!
    @IBOutlet weak var addItemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func displayCell(searchName:String, searchImage:String){
        addItemLabel.text = searchName.capitalized
        
        let imageName  = "https://spoonacular.com/cdn/ingredients_100x100/" + searchImage
        let imageURL = URL(string:imageName)
        if let data = NSData(contentsOf: imageURL!) {
            addItemImage.image =  UIImage(data: data as Data)
        }
        else {
            addItemImage.image = UIImage(named: "budget")
        }
    }
}
