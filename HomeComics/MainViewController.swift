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

    @IBOutlet var readButton: UIButton!
    @IBOutlet var jsonTextField: UITextField!
    
    var pagesIndex: [URL] = []
    
    @IBAction func fetchJSON(_ sender: UIButton) {
        let destination: DownloadRequest.DownloadFileDestination = {_, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            var fileURL = documentsURL
            fileURL.appendPathComponent("books.json")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        //if let urlString = jsonTextField.text {
            //Alamofire.download(urlString, to: destination).response { response in
        Alamofire.download("http://127.0.0.1:8080/books.json", to: destination).response { response in
            print(response)
            if (response.error == nil) {
                self.readJSON()
            }
            
        }
       // }
    }
    
    func readJSON() {
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
        // TODO: replace hardcoded url with user setting
        let stringArray = json?["books"][0]["contents"].arrayValue.map({"http://127.0.0.1:8080/" + (json?["books"][0]["location"].stringValue)! + "/" + $0.stringValue})
        for page in stringArray! {
            print("url as string : \(page)")
            if let url = URL(string: page.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!) {
                pagesIndex.append(url)
            }
        }
        readButton.isEnabled = true
    }
    
    @IBAction func openReader(_ sender: Any) {
        self.performSegue(withIdentifier: "openComicSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "openComicSegue") {
            let comicPageViewController = segue.destination as! ComicPageViewController
            comicPageViewController.pagesIndex = self.pagesIndex
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.jsonTextField.delegate = self
        readButton.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
