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
    @IBOutlet var scrollView: UIScrollView!
    
    var book: Book?
    var bookLocation: String?
    var urls: [URL] = []
    // TODO: define these with the user settings
    let baseURL = "http://127.0.0.1:1337"
    let cdnURL = "http://127.0.0.1:8080/"
    let defaults = UserDefaults.standard

    func startReading(sender: UIBarButtonItem?) {
        if let contents = book?.contents {
            for page in contents {
                print("page: \(page)")
                let pageURL = cdnURL + page
                let finalURL = pageURL.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
                urls.append(URL(string: finalURL!)!)
            }
            performSegue(withIdentifier: "startReading", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let readButton = UIBarButtonItem(title: "Read", style: .plain, target: self, action: #selector(startReading(sender:)))
        navigationItem.setRightBarButton(readButton, animated: false)
        if let id = book?.id {
            self.getBookContents(id: id)
        }
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
    }
    
    // MARK: - Private
    private func getBookContents(id: Int) {
        var url = defaults.string(forKey: "serverBaseURL")
        url = url! + "/book/\(id)"
        let finalURL = url?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        print("Requesting book contents on url : <\(String(describing: finalURL))>")
        Alamofire.request(finalURL!).responseObject { (response: DataResponse<Book>) in
            let book = response.result.value
            if let book = book {
                print("Received book contents!")
                self.book = book
            } else {
                // TODO: Couldn't fetch book contents, warn user
            }
            
        }
    }

}
