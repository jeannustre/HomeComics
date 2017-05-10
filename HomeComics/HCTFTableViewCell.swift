//
//  HCTFTableViewCell.swift
//  HomeComics
//
//  Created by Jean Sarda on 09/05/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit

class HCTFTableViewCell: UITableViewCell {

    
    @IBOutlet var serverAddressLabel: UILabel!
    @IBOutlet var serverAddressTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("tf width \(serverAddressTextField.bounds.width)")
        //serverAddressTextField.bounds.width = 200
        print("tf width \(serverAddressTextField.bounds.width)")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
