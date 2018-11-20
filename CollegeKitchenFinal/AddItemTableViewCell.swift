//
//  AddItemTableViewCell.swift
//  CollegeKitchenFinal
//
//  Created by Maya Menon on 11/20/18.
//  Copyright © 2018 Julia Downey. All rights reserved.
//

import UIKit

class AddItemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayCell(searchName:String){
        label.text = searchName
    }

}
