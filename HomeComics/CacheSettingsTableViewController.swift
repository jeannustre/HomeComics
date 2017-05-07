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
    @IBOutlet var useDiskCacheCell: UITableViewCell!
    @IBOutlet var sizeDiskCacheCell: UITableViewCell!
    @IBOutlet var useRamCacheCell: UITableViewCell!
    @IBOutlet var sizeRamCacheCell: UITableViewCell!
    @IBOutlet var useCoverCacheCell: UITableViewCell!
    @IBOutlet var sizeCoverCacheCell: UITableViewCell!
    
    var defaults: UserDefaults?
    
    //MARK: - Lazy variables
    lazy var useDiskSwitch: UISwitch = {
        let diskSwitch = UISwitch()
        diskSwitch.addTarget(self, action: #selector(diskSwitchToggled(sender:)), for: .valueChanged)
        return diskSwitch
    }()
    
    lazy var useRamSwitch: UISwitch = {
        let ramSwitch = UISwitch()
        ramSwitch.addTarget(self, action: #selector(ramSwitchToggled(sender:)), for: .valueChanged)
        return ramSwitch
    }()
    
    lazy var useCoverSwitch: UISwitch = {
        let coverSwitch = UISwitch()
        coverSwitch.addTarget(self, action: #selector(coverSwitchToggled(sender:)), for: .valueChanged)
        return coverSwitch
    }()
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaults = UserDefaults.standard
        self.initLayout()
        self.loadDefaults(defaults!)
        self.updateLayout(switchIsOn: useDiskSwitch.isOn, cell: sizeDiskCacheCell)
        self.updateLayout(switchIsOn: useRamSwitch.isOn, cell: sizeRamCacheCell)
        self.updateLayout(switchIsOn: useCoverSwitch.isOn, cell: sizeCoverCacheCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadDefaults(defaults!)
        self.updateLayout(switchIsOn: useDiskSwitch.isOn, cell: sizeDiskCacheCell)
        self.updateLayout(switchIsOn: useRamSwitch.isOn, cell: sizeRamCacheCell)
        self.updateLayout(switchIsOn: useCoverSwitch.isOn, cell: sizeCoverCacheCell)
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
        if (segue.identifier == "showCoverSlider") {
            sliderViewController.navigationItem.title = "Cover Cache"
            sliderViewController.key = "coverCache"
            sliderViewController.steps = [64, 128, 256, 512, 1024]
        }
    }
    
    //MARK: - Class methods
    private func initLayout() {
        // Workaround for the default TableView separator left inset
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        // Lazy switches
        useDiskCacheCell.accessoryView = useDiskSwitch
        useRamCacheCell.accessoryView = useRamSwitch
        useCoverCacheCell.accessoryView = useCoverSwitch
        // Make background of cell unselectable
        useDiskCacheCell.selectionStyle = .none
        useRamCacheCell.selectionStyle = .none
        useCoverCacheCell.selectionStyle = .none
    }
    
    private func loadDefaults(_ defaults: UserDefaults) {
        useDiskSwitch.isOn = defaults.bool(forKey: "diskCacheEnabled")
        useRamSwitch.isOn = defaults.bool(forKey: "ramCacheEnabled")
        useCoverSwitch.isOn = defaults.bool(forKey: "coverCacheEnabled")
        sizeRamCacheCell.detailTextLabel?.text = defaults.integer(forKey: "ramCache").description
        sizeDiskCacheCell.detailTextLabel?.text = defaults.integer(forKey: "diskCache").description
        sizeCoverCacheCell.detailTextLabel?.text = defaults.integer(forKey: "coverCache").description
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
        updateLayout(switchIsOn: sender.isOn, cell: sizeDiskCacheCell)
    }
    
    func ramSwitchToggled(sender:UISwitch!) {
        defaults?.set(sender.isOn, forKey: "ramCacheEnabled")
        updateLayout(switchIsOn: sender.isOn, cell: sizeRamCacheCell)
    }
    
    func coverSwitchToggled(sender:UISwitch!) {
        defaults?.set(sender.isOn, forKey: "coverCacheEnabled")
        updateLayout(switchIsOn: sender.isOn, cell: sizeCoverCacheCell)
    }
    
}
