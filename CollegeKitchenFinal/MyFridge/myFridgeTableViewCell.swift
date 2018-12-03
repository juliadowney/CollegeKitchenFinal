//
//  myFridgeTableViewCell.swift
//  CollegeKitchenFinal
//
//  Created by Maya Menon on 11/23/18.
//  Copyright © 2018 Julia Downey. All rights reserved.
//

import UIKit

class myFridgeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ingredientName: UILabel!
    @IBOutlet weak var ingredientQuantity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func displayCell(name:String, amount:Double, unit:String){
        ingredientName.text = name.capitalized
        ingredientQuantity.text = String(format:"%2.f", amount)
            + " " + unit
    }

}
