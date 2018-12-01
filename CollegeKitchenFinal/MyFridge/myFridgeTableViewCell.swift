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
        // Initialization code
    }
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     theFavs.remove(at: indexPath.row)
     tableView.deleteRows(at: [indexPath], with: .fade)
     remove()
     getData()
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func displayCell(name:String, amount:Double, unit:String){
        ingredientName.text = name.capitalized
        ingredientQuantity.text = String(format:"%2.f", amount)
 + " " + unit
    }

}
