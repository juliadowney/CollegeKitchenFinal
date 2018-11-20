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
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //// HI LINDSEY just add in the image name to the command and set image to it - you have to edit the view controller too 
    func displayCell(searchName:String){
        label.text = searchName
        
    }

}
