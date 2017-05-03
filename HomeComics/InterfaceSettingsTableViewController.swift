//
//  InterfaceSettingsTableViewController.swift
//  HomeComics
//
//  Created by Jean Sarda on 03/05/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit

class InterfaceSettingsTableViewController: UITableViewController {

    @IBOutlet var secondaryColorCell: UITableViewCell!
    @IBOutlet var primaryColorCell: UITableViewCell!
    var defaults: UserDefaults?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defaults = UserDefaults.standard
        self.primaryColorCell.imageView?.image = colorImage
        //self.primaryColorCell.imageView?.tintColor = UIColor.flatPink()
        self.secondaryColorCell.imageView?.image = colorImage
        //self.secondaryColorCell.imageView?.tintColor = UIColor.flatTealColorDark()
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        self.setColors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setColors()
    }
    
    private func setColors() {
        let primaryColorHex = defaults?.string(forKey: "primaryColor")
        let secondaryColorHex = defaults?.string(forKey: "secondaryColor")
        
        self.primaryColorCell.imageView?.tintColor = UIColor(hexString: primaryColorHex)
        if secondaryColorHex != "none" {
            self.secondaryColorCell.imageView?.tintColor = UIColor(hexString: secondaryColorHex)
        }
        self.secondaryColorCell.imageView?.tintColor = secondaryColorHex != "none" ? UIColor(hexString: secondaryColorHex) : UIColor.clear
        
    }
    
    lazy var colorImage: UIImage? = {
        let image = UIImage(named: "Circle-full")
        let rendered = image?.withRenderingMode(.alwaysTemplate)
        return rendered
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let colorViewController = segue.destination as! ColorPickerTableViewController
        colorViewController.defaults = defaults
        if (segue.identifier == "primaryColorPicker") {
            colorViewController.navigationItem.title = "Primary Color"
            colorViewController.key = "primaryColor"
        }
        if (segue.identifier == "secondaryColorPicker") {
            colorViewController.navigationItem.title = "Secondary Color"
            colorViewController.key = "secondaryColor"
        }
    }

}
