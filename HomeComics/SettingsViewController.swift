//
//  ModalViewController.swift
//  HomeComics
//
//  Created by Jean Sarda on 23/04/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    //MARK: - Class variables & Outlets
    @IBOutlet var ramValueLabel: UILabel!
    @IBOutlet var diskValueLabel: UILabel!
    @IBOutlet var downloadPriorityLabel: UILabel!
    @IBOutlet var ramSlider: UISlider!
    @IBOutlet var diskSlider: UISlider!
    @IBOutlet var downloadPrioritySwitch: UISwitch!
    var defaults: UserDefaults?
    
    //MARK: - Actions
    @IBAction func saveAction(_ sender: Any) {
        defaults = UserDefaults.standard
        defaults?.set(ramSlider.value, forKey: "ramCache")
        defaults?.set(diskSlider.value, forKey: "diskCache")
        defaults?.set(downloadPrioritySwitch.isOn, forKey: "downloadPriority")

        //self.dismiss(animated: true, completion: { })
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        defaults = UserDefaults.standard
        setupInterface(defaults: defaults!)
        self.updateRamLabel(value: ramSlider.value)
        self.updateDiskLabel(value: diskSlider.value)
        self.updateDownloadLabel(switchIsOn: downloadPrioritySwitch.isOn)
    }
    
    @IBAction func ramValueChanged(_ sender: UISlider) {
        ramValueLabel.text = Int(sender.value).description + "MB"
    }
    
    @IBAction func diskValueChanged(_ sender: UISlider) {
        diskValueLabel.text = Int(sender.value).description + "MB"
    }
    
    @IBAction func downloadSwitchChanged(_ sender: UISwitch) {
        self.updateDownloadLabel(switchIsOn: sender.isOn)
    }
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaults = UserDefaults.standard
        self.setupInterface(defaults: defaults!)
        self.updateRamLabel(value: ramSlider.value)
        self.updateDiskLabel(value: diskSlider.value)
        self.updateDownloadLabel(switchIsOn: downloadPrioritySwitch.isOn)
    }

    //MARK: - Class methods
    private func setupInterface(defaults: UserDefaults) {
        ramSlider.value = Float(defaults.integer(forKey: "ramCache"))
        diskSlider.value = Float(defaults.integer(forKey: "diskCache"))
        downloadPrioritySwitch.isOn = defaults.bool(forKey: "downloadPriority")
    }
    
    private func updateRamLabel(value: Float) {
        ramValueLabel.text = Int(value).description + "MB"
    }
    
    private func updateDiskLabel(value: Float) {
        diskValueLabel.text = Int(value).description + "MB"
    }
    
    private func updateDownloadLabel(switchIsOn: Bool) {
        if switchIsOn {
            downloadPriorityLabel.text = "FIFO"
        } else {
            downloadPriorityLabel.text = "LIFO"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
