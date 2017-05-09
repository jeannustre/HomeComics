//
//  BookDetailViewController.swift
//  HomeComics
//
//  Created by Jean Sarda on 07/05/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class BookDetailViewController: UIViewController {

    @IBOutlet var background: UIImageView!
    
    //var image: UIImage?
    
    @IBOutlet var popButton: UIButton!
    
    var book: Book?
    var bookLocation: String?
    var urls: [URL] = []
    // TODO: define these with the user settings
    let baseURL = "http://127.0.0.1:1337"
    let cdnURL = "http://127.0.0.1:8080/"
    
    @IBAction func popAction(_ sender: UIButton) {
        if let contents = book?.contents {
            for page in contents {
                print("page: \(page)")
                let pageURL = cdnURL + page
                let finalURL = pageURL.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
                urls.append(URL(string: finalURL!)!)
            }
            performSegue(withIdentifier: "startReading", sender: nil)
        }
//        print("urls: \(urls)")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("detail view book : \(book)")
        print("book id : \(book?.id)")
        self.popButton.layer.cornerRadius = 5
        self.popButton.clipsToBounds = true
        let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.popButton.contentEdgeInsets = insets
        if let id = book?.id {
            self.getBookContents(id: id)
        }
       // background.image = self.image
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startReading" {
            let comicPageViewController = segue.destination as! ReaderViewController
            comicPageViewController.pagesIndex = self.urls
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - Private
    
    private func getBookContents(id: Int) {
        let url = baseURL + "/book/\(id)"
        print("Requesting book contents on url : <\(url)>")
        Alamofire.request(url).responseObject { (response: DataResponse<Book>) in
            let book = response.result.value
            if let book = book {
                self.book = book
            }
            print("Did receive book!")
        }
    }

}
