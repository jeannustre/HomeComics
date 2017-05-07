//
//  BooksViewController.swift
//  HomeComics
//
//  Created by Jean Sarda on 07/05/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import Chameleon

class BooksViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    let bookDataSource = BookDataSource()
    let count = 0
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = bookDataSource
        bookDataSource.fetchBooks {
            print("Fetched books through BookDataSource!")
            self.collectionView.reloadData()
           // print(books.toJSON())
        }
        bookDataSource.fetchAuthors {
            print("Fetched authors through BookDataSource!")
            self.collectionView.reloadData()
        }
        //let defaults = UserDefaults.standard
        let bgColor = UIColor(hexString: defaults.string(forKey: "primaryColor"))
        view.backgroundColor = bgColor
        collectionView.backgroundColor = bgColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
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
