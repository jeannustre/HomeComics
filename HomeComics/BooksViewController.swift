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

class BooksViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet var collectionView: UICollectionView!
    
    let bookDataSource = BookDataSource()
    let count = 0
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        //self.collectionView.delegate
        collectionView.dataSource = bookDataSource
        collectionView.delegate = self
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did select item")
        let cell = collectionView.cellForItem(at: indexPath) as! BookCollectionViewCell
        
        
        let bookDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookDetailViewController") as! BookDetailViewController
//        let url = bookDataSource.cdnURL + book.cover!
//        let escapedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
//        troller, animated: true, completion: nil)
        
        print("A \(bookDetailViewController.background)")
        print("B \(cell.imageView)")
        bookDetailViewController.image = cell.imageView.image
        bookDetailViewController.view.backgroundColor = UIColor(hexString: defaults.string(forKey: "primaryColor"))
        self.present(bookDetailViewController, animated: true, completion: nil)

        //return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
