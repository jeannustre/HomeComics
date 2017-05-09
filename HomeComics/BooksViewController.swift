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
    //let cache = DiskCache(path: "collection")
//    let cache = Cache<UIImage>(name: <#T##String#>)
    let bookDataSource = BookDataSource()
    let count = 0
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        //self.collectionView.delegate
        //collectionView.bounds.origin = collectionView.bounds.origin  - collectionView.bounds.origin
//        cache.
        self.setupNavBar()
        self.bookDataSource.setupCache()
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
        let cell = collectionView.cellForItem(at: indexPath) as! BookCollectionViewCell
        let bookDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookDetailViewController") as! BookDetailViewController
        let capacity = UInt64(defaults.integer(forKey: "diskCache"))
        let format = Format<UIImage>(name: "original", diskCapacity: capacity * 1024 * 1024)
        print("Disk capacity : \(format.diskCapacity / (1024*1024))")
        bookDetailViewController.book = bookDataSource.books[indexPath.row]
        if let url = URL(string: cell.imageURL!) {
            bookDetailViewController.view.layoutIfNeeded()
            bookDetailViewController.background.hnk_setImageFromURL(url, format: format)
        }
        
        bookDetailViewController.view.backgroundColor = UIColor(hexString: defaults.string(forKey: "primaryColor"))
        navigationController?.pushViewController(bookDetailViewController, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
