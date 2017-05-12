//
//  InterfaceSettingsTableViewController.swift
//  HomeComics
//
//  Created by Jean Sarda on 03/05/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit
import AKPickerView

class InterfaceSettingsTableViewController: UITableViewController {

    @IBOutlet var secondaryColorCell: UITableViewCell!
    @IBOutlet var primaryColorCell: UITableViewCell!
    @IBOutlet var booksPerRowCell: HCPickerTableViewCell!
    
    let pickerOptions = ["1", "2", "3", "4", "5", "6"] // Number of books per row
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.primaryColorCell.imageView?.image = colorImage
        //self.primaryColorCell.imageView?.tintColor = UIColor.flatPink()
        self.secondaryColorCell.imageView?.image = colorImage
        booksPerRowCell.picker?.delegate = self
        booksPerRowCell.picker?.dataSource = self
        let booksPerRowValue = defaults.integer(forKey: "booksPerRow")
        print("booksPerRowValue : \(booksPerRowValue)")
        
        booksPerRowCell.picker?.selectItem(booksPerRowValue - 1)
//        booksPerRowCell.
        //print("cell bounds : \(self.booksPerRowCell.bounds.debugDescription)")
//print("cell label bounds : \(self.booksPerRowCell.textLabel?.bounds.debugDescription)")
        //self.booksPerRowCell.addSubview(picker)
        
       // self.booksPerRowCell.accessoryView = picker
        
        //self.secondaryColorCell.imageView?.tintColor = UIColor.flatTealColorDark()
        //tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        self.setColors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setColors()
    }
    
    private func setColors() {
        let primaryColorHex = defaults.string(forKey: "primaryColor")
        let secondaryColorHex = defaults.string(forKey: "secondaryColor")
        
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

extension InterfaceSettingsTableViewController: AKPickerViewDataSource {
    
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return pickerOptions.count
    }
    
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        return pickerOptions[item]
    }
    
}

extension InterfaceSettingsTableViewController: AKPickerViewDelegate {
    
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        print("Selected item at \(item)")
        let numberOfRows = Int(pickerOptions[item])
        defaults.set(numberOfRows, forKey: "booksPerRow")
    }
    
}
