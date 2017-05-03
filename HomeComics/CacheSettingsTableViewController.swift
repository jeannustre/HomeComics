//
//  CacheSettingsTableViewController.swift
//  HomeComics
//
//  Created by Jean Sarda on 03/05/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit

class CacheSettingsTableViewController: UITableViewController {

    
    @IBOutlet var useStorageCacheCell: UITableViewCell!
    @IBOutlet var sizeStorageCacheCell: UITableViewCell!
    
    @IBOutlet var useRamCacheCell: UITableViewCell!
    @IBOutlet var sizeRamCacheCell: UITableViewCell!
    
    var defaults: UserDefaults?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defaults = UserDefaults.standard
        self.initLayout()
        self.loadDefaults(defaults!)
        self.updateLayout(switchIsOn: useStorageSwitch.isOn, cell: sizeStorageCacheCell)
        self.updateLayout(switchIsOn: useRamSwitch.isOn, cell: sizeRamCacheCell)
    }
    
    private func loadDefaults(_ defaults: UserDefaults) {
        useStorageSwitch.isOn = defaults.bool(forKey: "diskCacheEnabled")
        useRamSwitch.isOn = defaults.bool(forKey: "ramCacheEnabled")
        sizeRamCacheCell.detailTextLabel?.text = defaults.integer(forKey: "ramCache").description
        sizeStorageCacheCell.detailTextLabel?.text = defaults.integer(forKey: "diskCache").description
    }
    
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
    
    private func updateLayout(switchIsOn: Bool, cell: UITableViewCell) {
        if switchIsOn {
            cell.isUserInteractionEnabled = true
            cell.textLabel?.textColor = UIColor.flatBlackColorDark()
            cell.detailTextLabel?.textColor = UIColor.flatWhiteColorDark()
        } else {
            cell.isUserInteractionEnabled = false
            cell.isSelected = false
            cell.isHighlighted = false
            cell.textLabel?.textColor = UIColor.flatWhite()
            cell.detailTextLabel?.textColor = UIColor.flatWhite()
        }
    }
    
    func diskSwitchToggled(sender:UISwitch!) {
        defaults?.set(sender.isOn, forKey: "diskCacheEnabled")
        updateLayout(switchIsOn: sender.isOn, cell: sizeStorageCacheCell)
    }
    
    func ramSwitchToggled(sender:UISwitch!) {
        defaults?.set(sender.isOn, forKey: "ramCacheEnabled")
        updateLayout(switchIsOn: sender.isOn, cell: sizeRamCacheCell)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
