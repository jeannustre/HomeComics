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
import Haneke

class BooksViewController: UIViewController, UICollectionViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    @IBOutlet var collectionView: UICollectionView!
    
    var searchController: UISearchController!
    let cache = Cache<UIImage>(name: "collection")
    let bookDataSource = BookDataSource()
    let count = 0
    let defaults = UserDefaults.standard
    var format: Format<UIImage>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavBar()
        self.setupCache()
        self.definesPresentationContext = true
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
    
    func setupNavBar(){
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.returnKeyType = .done
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.navigationItem.titleView = searchController.searchBar
        let navBarColor = self.navigationController?.navigationBar.backgroundColor
        self.navigationItem.titleView?.backgroundColor = navBarColor
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange : <\(searchText)>")
        self.bookDataSource.searchWith(searchText) {
            self.collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.bookDataSource.searchWith("") {
            self.collectionView.reloadData()
        }
    }
    
    func setupCache() {
        bookDataSource.setupCache()
        let diskCache = UInt64(defaults.string(forKey: "diskCache")!)! * 1024 * 1024
        self.format = Format<UIImage>(name: "GlobalDiskCache", diskCapacity: diskCache)
    }
    
   /* func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }*/
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = bookDataSource.books[indexPath.row]
        book.cover = "http://127.0.0.1:8080/" + book.cover!
        performSegue(withIdentifier: "showDetail", sender: book)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let bookDetailViewController = segue.destination as! BookDetailViewController
            let book = sender as! Book
            if let url = URL(string: (book.cover?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed))!) {
                print("URL: \(url.description)")
                bookDetailViewController.book = book
                bookDetailViewController.view.layoutIfNeeded()
                bookDetailViewController.background.hnk_setImageFromURL(url, format: self.format)
                bookDetailViewController.view.backgroundColor = UIColor(hexString: defaults.string(forKey: "primaryColor"))
            }
        }
    }
    

}
