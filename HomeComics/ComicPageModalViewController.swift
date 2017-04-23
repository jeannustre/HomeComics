//
//  ComicPageModalViewController.swift
//  HomeComics
//
//  Created by Jean Sarda on 22/04/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit

class ComicPageModalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 40/255, green: 44/255, blue: 52/255, alpha: 1.0)
        // Create save button
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.handleSave))
        saveButton.tintColor = UIColor(red: 226/255, green: 20/255, blue: 21/255, alpha: 1.0)
        // Create cancel button
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.handleCancel))
        cancelButton.tintColor = UIColor(red: 226/255, green: 20/255, blue: 21/255, alpha: 1.0)
        // Add the buttons to the navigation bar
        let topViewController = self.navigationController!.topViewController
        topViewController!.navigationItem.rightBarButtonItem = saveButton;
        topViewController!.navigationItem.leftBarButtonItem = cancelButton;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleCancel() {
        print("Aborting changes to device")
        // Ask the view controller that presented us to dismiss us...
        self.dismiss(animated: true, completion: nil)
    }

    func handleSave() {
        print("Aborting changes to device")
        // Ask the view controller that presented us to dismiss us...
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
