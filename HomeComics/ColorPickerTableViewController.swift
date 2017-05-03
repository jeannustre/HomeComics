//
//  ColorPickerTableViewController.swift
//  HomeComics
//
//  Created by Jean Sarda on 03/05/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit
import Chameleon

class ColorCell {
    var lightColor: UIColor?
    var darkColor: UIColor?
    var darkHex: String?
    var lightHex: String?
    var name: String?
    
    init(light: UIColor?, dark: UIColor?, name: String) {
        self.lightColor = light
        self.darkColor = dark
        self.lightHex = self.lightColor == self.darkColor ? "none" : light?.hexValue()
        self.darkHex = self.lightColor == self.darkColor ? "none" : dark?.hexValue()
        self.name = name
    }
    
    func getColor(dark: Bool) -> UIColor? {
        return dark ? darkColor : lightColor
    }
    
    func getHex(dark: Bool) -> String? {
        return dark ? darkHex : lightHex
    }
}

class ColorPickerTableViewController: UITableViewController {

    var defaults: UserDefaults?
    var key: String?
    var dark = false
    var colors = [
            ColorCell(light: UIColor.flatPowderBlue(), dark: UIColor.flatPowderBlueColorDark(), name: "Powder Blue"),
            ColorCell(light: UIColor.flatSkyBlue(), dark: UIColor.flatSkyBlueColorDark(), name: "Sky Blue"),
            ColorCell(light: UIColor.flatBlue(), dark: UIColor.flatBlueColorDark(), name: "Blue"),
            ColorCell(light: UIColor.flatPurple(), dark: UIColor.flatPurpleColorDark(), name: "Purple"),
            ColorCell(light: UIColor.flatMagenta(), dark: UIColor.flatMagentaColorDark(), name: "Magenta"),
            ColorCell(light: UIColor.flatPink(), dark: UIColor.flatPinkColorDark(), name: "Pink"),
            ColorCell(light: UIColor.flatWatermelon(), dark: UIColor.flatWatermelonColorDark(), name: "Watermelon"),
            ColorCell(light: UIColor.flatRed(), dark: UIColor.flatRedColorDark(), name: "Red"),
            ColorCell(light: UIColor.flatOrange(), dark: UIColor.flatOrangeColorDark(), name: "Orange"),
            ColorCell(light: UIColor.flatYellow(), dark: UIColor.flatYellowColorDark(), name: "Yellow"),
            ColorCell(light: UIColor.flatLime(), dark: UIColor.flatLimeColorDark(), name: "Lime"),
            ColorCell(light: UIColor.flatGreen(), dark: UIColor.flatGreenColorDark(), name: "Green"),
            ColorCell(light: UIColor.flatMint(), dark: UIColor.flatMintColorDark(), name: "Mint"),
            ColorCell(light: UIColor.flatTeal(), dark: UIColor.flatTealColorDark(), name: "Teal"),
            ColorCell(light: UIColor.flatNavyBlue(), dark: UIColor.flatNavyBlueColorDark(), name: "Navy Blue"),
            ColorCell(light: UIColor.flatBlack(), dark: UIColor.flatBlackColorDark(), name: "Black"),
            ColorCell(light: UIColor.flatBrown(), dark: UIColor.flatBrownColorDark(), name: "Brown"),
            ColorCell(light: UIColor.flatCoffee(), dark: UIColor.flatCoffeeColorDark(), name: "Coffee"),
            ColorCell(light: UIColor.flatSand(), dark: UIColor.flatSandColorDark(), name: "Sand"),
            ColorCell(light: UIColor.flatWhite(), dark: UIColor.flatWhiteColorDark(), name: "White"),
            ColorCell(light: UIColor.flatGray(), dark: UIColor.flatGrayColorDark(), name: "Gray"),
            ColorCell(light: UIColor.flatMaroon(), dark: UIColor.flatMaroonColorDark(), name: "Maroon"),
            ColorCell(light: UIColor.flatForestGreen(), dark: UIColor.flatForestGreenColorDark(), name: "Forest Green"),
            ColorCell(light: UIColor.flatPlum(), dark: UIColor.flatPlumColorDark(), name: "Plum")
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if key! == "secondaryColor" {
            let noColorCell = ColorCell(light: UIColor.white, dark: UIColor.white, name: "None")
            colors.insert(noColorCell, at: 0)
        }
        let rightButton = UIBarButtonItem(title: "Dark", style: .plain, target: self, action: #selector(rightButtonTapped(sender:)))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.initTheme()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rightButtonTapped(sender: UIBarButtonItem) {
        if dark {
            sender.title = "Dark"
            dark = false
        } else {
            sender.title = "Light"
            dark = true
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let color = colors[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "colorCell")
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = color.getColor(dark: self.dark)
        cell.textLabel?.text = color.name
        cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: color.getColor(dark: self.dark), isFlat: true)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        print("Selected color at row \(index)")
        let hex = colors[index].getHex(dark: self.dark)
        defaults?.set(hex, forKey: key!)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
}
