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

class MainViewController: UIViewController {

    @IBOutlet var readButton: UIButton!
    
    var pagesIndex: [URL] = []
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
    
    @IBAction func downloadCBZFile(_ sender: Any) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
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
            comicPageViewController.pagesIndex = self.pagesIndex
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
