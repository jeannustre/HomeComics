//
//  MainViewController.swift
//  HomeComics
//
//  Created by Jean Sarda on 15/03/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class MainViewController: UIViewController, UITextFieldDelegate {

    //MARK: - Class variables & Outlets
    @IBOutlet var readButton: UIButton!
    @IBOutlet var jsonTextField: UITextField!
    var pagesIndex: [URL] = []
    var defaults: UserDefaults?
    
    //MARK: - Actions
    @IBAction func fetchJSON(_ sender: UIButton) {
        let destination: DownloadRequest.DownloadFileDestination = {_, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            var fileURL = documentsURL
            fileURL.appendPathComponent("books.json")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        Alamofire.download((defaults?.string(forKey: "serverBaseURL"))! + "books.json", to: destination).response { response in
            print(response)
            if (response.error == nil) {
                self.readJSON()
            }
        }
    }
    
    @IBAction func openReader(_ sender: Any) {
        self.performSegue(withIdentifier: "startReading", sender: self)
    }
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaults = UserDefaults.standard
        self.setupUserDefaults(defaults: defaults!)
        self.jsonTextField.delegate = self
        readButton.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "startReading") {
            let comicPageViewController = segue.destination as! ReaderViewController
            comicPageViewController.pagesIndex = self.pagesIndex
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Class methods
    private func readJSON() {
        var fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL.appendPathComponent("books.json")
        var json: JSON?
        do {
            json = try JSON(data: Data(contentsOf: fileURL))
        } catch {
            print("reading books.json thrown an error")
        }
        guard json != nil else {
            print("could not read json")
            return
        }
        let stringArray = json?["books"][0]["contents"].arrayValue.map({(defaults?.string(forKey: "serverBaseURL"))! + (json?["books"][0]["location"].stringValue)! + "/" + $0.stringValue})
        for page in stringArray! {
            print("url as string : \(page)")
            if let url = URL(string: page.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!) {
                pagesIndex.append(url)
            }
        }
        readButton.isEnabled = true
    }
    
    private func setupUserDefaults(defaults: UserDefaults) {
        if defaults.object(forKey: "ramCache") == nil {
            print("Creating ramCache defaults key with value: 128")
            defaults.set(128, forKey: "ramCache")
        }
        if defaults.object(forKey: "diskCache") == nil {
            print("Creating diskCache defaults key with value: 512")
            defaults.set(512, forKey: "diskCache")
        }
        if defaults.object(forKey: "downloadPriority") == nil {
            print("Creating downloadPriority defaults key with value: true")
            defaults.set(true, forKey: "downloadPriority") // true:fifo, false:lifo
        }
        if defaults.object(forKey: "serverBaseURL") == nil {
            print("Creating serverBaseURL defaults key with value: http://127.0.0.1:8080/")
            defaults.set("http://127.0.0.1:8080/", forKey: "serverBaseURL")
        }
    }
 
    //MARK: - Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
