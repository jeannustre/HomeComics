//
//  HCPickerTableViewCell.swift
//  HomeComics
//
//  Created by Jean Sarda on 12/05/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit
import AKPickerView
import Chameleon

class HCPickerTableViewCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var container: UIView!
    var picker: AKPickerView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.layoutIfNeeded()
        let bounds = container.bounds
        let pickerWidth = bounds.width * 0.75
        let xOrigin = (bounds.width - pickerWidth) / 2
        let frame = CGRect(x: xOrigin, y: bounds.origin.y, width: pickerWidth, height: bounds.height)
        picker = AKPickerView(frame: frame)
        picker?.interitemSpacing = 20.0
        picker?.textColor = UIColor.flatGray()
        picker?.highlightedTextColor = UIColor.flatBlue()
        picker?.viewDepth = UIScreen.main.bounds.width
        picker?.pickerViewStyle = .flat
        container.backgroundColor = UIColor.flatYellow()
        picker?.backgroundColor = UIColor.flatGreen()
        picker?.reloadData()
        container.addSubview(picker!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
