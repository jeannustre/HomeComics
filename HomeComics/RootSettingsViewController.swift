//
//  RootSettingsViewController.swift
//  HomeComics
//
//  Created by Jean Sarda on 03/05/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit
import Alertift

class RootSettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
