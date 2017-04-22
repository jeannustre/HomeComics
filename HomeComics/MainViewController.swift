//
//  MainViewController.swift
//  HomeComics
//
//  Created by Jean Sarda on 15/03/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit
import FileBrowser
import Zip
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var readButton: UIButton!
    @IBOutlet var jsonTextField: UITextField!
    
    var pagesIndex: [URL] = []
    var pagesIndexJSON: [URL] = []
    //let bookJSON =
    var bookTitle: String = "" {
        didSet {
            readButton.setTitle("Start reading \(bookTitle)", for: .normal)
        }
    }
    
    @IBAction func openFileBrowser(_ sender: UIButton) {
        let fileBrowser = FileBrowser()
        fileBrowser.didSelectFile = { (file: FBFile) -> Void in
            self.unzip(file: file)
        }
        present(fileBrowser, animated: true, completion: nil)
    }
    
    @IBAction func fetchJSON(_ sender: UIButton) {
        let destination: DownloadRequest.DownloadFileDestination = {_, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            var fileURL = documentsURL
            fileURL.appendPathComponent("books.json")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        // http://127.0.0.1:8080/sgt.json
        if let urlString = jsonTextField.text {
            Alamofire.download(urlString, to: destination).response { response in
                print(response)
                self.readJSON()
            }
        }
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
        if (json == nil) {
            print("could not read json")
            return
        }
        // iterate through books
        /*
        for (key, subJson):(String, JSON) in (json?["books"])! {
            print("Book \(key) : \(subJson["title"].stringValue)")
            let arrayPages = subJson["contents"].arrayValue.map({subJson["location"].stringValue + "/" + $0.stringValue})
            for page in arrayPages {
                print("\(page)")
            }
        }
        */
        // open first book
        let stringArray = json?["books"][0]["contents"].arrayValue.map({"http://192.168.0.100:8080/" + (json?["books"][0]["location"].stringValue)! + "/" + $0.stringValue})
        for page in stringArray! {
            print("url as string : \(page)")
            
            
            if let url = URL(string: page.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!) {
                pagesIndexJSON.append(url)
            }
            //            print(url.absoluteString)
        }
        for url in pagesIndexJSON {
            print("url as url : \(url)")
        }
    }
    
    @IBAction func downloadCBZFile(_ sender: Any) {
        let destination: DownloadRequest.DownloadFileDestination = {_, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            var fileURL = documentsURL
            fileURL.appendPathComponent("batman.cbz")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        let urlString = "http://127.0.0.1:8080/%5BComics%20Fr%5D%20Batman.Universe.T02.trunked.cbz"
        Alamofire.download(urlString, to: destination).response { response in
            print(response)
        }
    }
    
    @IBAction func openReader(_ sender: Any) {
        print("performing segue")
        self.performSegue(withIdentifier: "openComicSegue", sender: self)
    }
    
    
    func unzip(file: FBFile) {
        print("Unzipping \(file.filePath)")
        if (file.fileExtension != "cbz") {
            print("Not a cbz file - returning")
            return
        }
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = file.displayName + "_unzipped"
        let unzippingFolderURL = documentsURL.appendingPathComponent(fileName, isDirectory: true)
        print("unzippingFolderURL: \(unzippingFolderURL)")
        do {
            try Zip.unzipFile(file.filePath, destination: unzippingFolderURL, overwrite: true, password: "", progress: { (progress) -> () in
                print(progress)
            })
            let directoryContents = try FileManager.default.contentsOfDirectory(at: unzippingFolderURL, includingPropertiesForKeys: nil, options: [])
            print(directoryContents[0]) // book root ; should contain the .jpg files
            let bookContents = try FileManager.default.contentsOfDirectory(at: directoryContents[0], includingPropertiesForKeys: nil, options: [])
            //print("Book contents : \(bookContents)")
            // bookContents contains the whole pages url list
            // send it to PageViewController
            self.pagesIndex = bookContents
            self.bookTitle = file.displayName
        }
        catch {
            print("Error thrown")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "openComicSegue") {
            let comicPageViewController = segue.destination as! ComicPageViewController
            // comicPageViewController.pagesIndex = self.pagesIndex
            comicPageViewController.pagesIndex = self.pagesIndexJSON
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.jsonTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
