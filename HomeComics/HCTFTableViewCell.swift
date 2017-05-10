//
//  HCTFTableViewCell.swift
//  HomeComics
//
//  Created by Jean Sarda on 09/05/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit

class HCTFTableViewCell: UITableViewCell {

    
    @IBOutlet var label: UILabel!
    @IBOutlet var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
