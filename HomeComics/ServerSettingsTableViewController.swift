//
//  ServerSettingsTableViewController.swift
//  HomeComics
//
//  Created by Jean Sarda on 03/05/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit

class ServerSettingsTableViewController: UITableViewController {

    @IBOutlet var serverAddressCell: HCTFTableViewCell!
    @IBOutlet var cdnAddressCell: HCTFTableViewCell!
    
    let defaults = UserDefaults.standard
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        self.setupCell(cell: serverAddressCell,
                       text: defaults.string(forKey: "serverBaseURL"),
                       delegate: self,
                       tag: 0)
        self.setupCell(cell: cdnAddressCell,
                       text: defaults.string(forKey: "cdnBaseURL"),
                       delegate: self,
                       tag: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Class methods
    func setupCell(cell: HCTFTableViewCell, text: String?, delegate: UITextFieldDelegate?, tag: Int) {
        cell.textField.text = text
        cell.textField.tag = tag
        cell.textField.delegate = delegate
        cell.selectionStyle = .none
    }
    
}

//MARK: - UITextField Delegate
extension ServerSettingsTableViewController: UITextFieldDelegate {
    
    //MARK: Managing Editing
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Make the TextField editable
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Called when edition began, and posts a UITextFieldTextDidBeginEditing notification
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // Make the TextField edition endable
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Called when edition ended, and posts a UITextFieldTextDidEndEditing notification
    }
    
    //MARK: Editing Text
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Asks the Delegate whether the specified text should be changed.
        // This typically is called once for each character typed, or when text is pasted.
        // Useful for blocking certain characters, but not needed here.
        // The third param only contains new input.
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // Asks the Delegate whether the text should be erased when the Clear button is pressed.
        // See: textfield.clearButtonMode 
        // See also: textfield.clearsOnBeginEditing
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Asks the Delegate whether the TextField should apply its default logic for a Return button press.
        // This is a one-line TextField, so we don't accept a newline char. Dissmissing the keyboard instead.
        textField.resignFirstResponder()
        // TODO: textFieldDidEndEditing delegate method should be called here, but isn't.
        // Until this is fixed, saving address here.
        let key = textField.tag == 0 ? "serverBaseURL" : "cdnBaseURL"
        print("Saving value for <\(key)>")
        defaults.set(textField.text, forKey: key)
        return false
    }
    
    //MARK: Instance Methods
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
    }
    
}
