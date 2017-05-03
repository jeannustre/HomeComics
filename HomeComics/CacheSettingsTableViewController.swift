//
//  CacheSettingsTableViewController.swift
//  HomeComics
//
//  Created by Jean Sarda on 03/05/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit

class CacheSettingsTableViewController: UITableViewController {

    //MARK: - Class variables & Outlets
    @IBOutlet var useStorageCacheCell: UITableViewCell!
    @IBOutlet var sizeStorageCacheCell: UITableViewCell!
    @IBOutlet var useRamCacheCell: UITableViewCell!
    @IBOutlet var sizeRamCacheCell: UITableViewCell!
    var defaults: UserDefaults?
    
    //MARK: - Lazy variables
    lazy var useStorageSwitch: UISwitch = {
        let storageSwitch = UISwitch()
        storageSwitch.addTarget(self, action: #selector(diskSwitchToggled(sender:)), for: .valueChanged)
        return storageSwitch
    }()
    
    lazy var useRamSwitch: UISwitch = {
        let ramSwitch = UISwitch()
        ramSwitch.addTarget(self, action: #selector(ramSwitchToggled(sender:)), for: .valueChanged)
        return ramSwitch
    }()
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        defaults = UserDefaults.standard
        self.initLayout()
        self.loadDefaults(defaults!)
        self.updateLayout(switchIsOn: useStorageSwitch.isOn, cell: sizeStorageCacheCell)
        self.updateLayout(switchIsOn: useRamSwitch.isOn, cell: sizeRamCacheCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("cache view will appear")
        self.loadDefaults(defaults!)
        self.updateLayout(switchIsOn: useStorageSwitch.isOn, cell: sizeStorageCacheCell)
        self.updateLayout(switchIsOn: useRamSwitch.isOn, cell: sizeRamCacheCell)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sliderViewController = segue.destination as! MemorySliderViewController
        sliderViewController.defaults = defaults
        if (segue.identifier == "showRamSlider") {
            sliderViewController.navigationItem.title = "RAM Cache"
            sliderViewController.key = "ramCache"
            sliderViewController.steps = [8, 16, 32, 64, 128, 256]
        }
        if (segue.identifier == "showDiskSlider") {
            sliderViewController.navigationItem.title = "Disk Cache"
            sliderViewController.key = "diskCache"
            sliderViewController.steps = [32, 64, 128, 256, 512, 1024, 2048]
        }
    }
    
    //MARK: - Class methods
    private func initLayout() {
        // Workaround for the default TableView separator left inset
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        // Lazy switches
        useStorageCacheCell.accessoryView = useStorageSwitch
        useRamCacheCell.accessoryView = useRamSwitch
        // Make background of cell unselectable
        useStorageCacheCell.selectionStyle = .none
        useRamCacheCell.selectionStyle = .none
    }
    
    private func loadDefaults(_ defaults: UserDefaults) {
        useStorageSwitch.isOn = defaults.bool(forKey: "diskCacheEnabled")
        useRamSwitch.isOn = defaults.bool(forKey: "ramCacheEnabled")
        sizeRamCacheCell.detailTextLabel?.text = defaults.integer(forKey: "ramCache").description
        sizeStorageCacheCell.detailTextLabel?.text = defaults.integer(forKey: "diskCache").description
    }
    
    private func updateLayout(switchIsOn: Bool, cell: UITableViewCell) {
        cell.isSelected = false
        cell.isHighlighted = false
        if switchIsOn {
            cell.isUserInteractionEnabled = true
            cell.textLabel?.textColor = UIColor.flatBlackColorDark()
            cell.detailTextLabel?.textColor = UIColor.flatWhiteColorDark()
        } else {
            cell.isUserInteractionEnabled = false
            cell.textLabel?.textColor = UIColor.flatWhite()
            cell.detailTextLabel?.textColor = UIColor.flatWhite()
        }
    }
    
    //MARK: - Callbacks
    func diskSwitchToggled(sender:UISwitch!) {
        defaults?.set(sender.isOn, forKey: "diskCacheEnabled")
        updateLayout(switchIsOn: sender.isOn, cell: sizeStorageCacheCell)
    }
    
    func ramSwitchToggled(sender:UISwitch!) {
        defaults?.set(sender.isOn, forKey: "ramCacheEnabled")
        updateLayout(switchIsOn: sender.isOn, cell: sizeRamCacheCell)
    }

}
