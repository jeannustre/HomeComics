//
//  BooksViewController.swift
//  HomeComics
//
//  Created by Jean Sarda on 07/05/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit
import Chameleon
import Haneke

class BooksViewController: UIViewController, UISearchControllerDelegate {

    @IBOutlet var collectionView: UICollectionView!
    
    // TODO: Define Formats elsewhere
    var searchController: UISearchController!
    let cache = Cache<UIImage>(name: "collection")
    let bookDataSource = BookDataSource()
    let defaults = UserDefaults.standard
    let bgColor = UIColor(hexString: UserDefaults.standard.string(forKey: "primaryColor"))
    var format: Format<UIImage>?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavBar()
        self.setupCache()
        self.setupCollectionView(bgColor)
        self.view.backgroundColor = bgColor
        self.definesPresentationContext = true
        
        bookDataSource.fetchBooks {
            print("Fetched books through BookDataSource!")
            self.collectionView.reloadData()
           // print(books.toJSON())
        }
        bookDataSource.fetchAuthors {
            print("Fetched authors through BookDataSource!")
            self.collectionView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Setup after View loaded
    func setupNavBar() {
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
    
    func setupCollectionView(_ backgroundColor: UIColor?) {
        collectionView.dataSource = bookDataSource
        collectionView.delegate = self
        collectionView.backgroundColor = backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshCollection(sender:)), for: .valueChanged)
        refresh.tintColor = UIColor.white
        collectionView.refreshControl = refresh
        collectionView.addSubview(refresh)
    }
    
    func setupCache() {
        bookDataSource.setupCache()
        //let diskCache = UInt64(defaults.string(forKey: "diskCache")!)! * 1024 * 1024
        //self.format = Format<UIImage>(name: "GlobalDiskCache", diskCapacity: diskCache)
    }
    
    func refreshCollection(sender: UIRefreshControl?) {
        bookDataSource.fetchBooks {
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
            print("Reloaded data")
        }
        // TODO: find a way to wait for the two completion handlers, without nesting them
        /*bookDataSource.fetchAuthors {
            self.collectionView.reloadData()
            print("Reloading data..")
        }*/
    }
    
    //MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let bookDetailViewController = segue.destination as! BookDetailViewController
            let book = sender as! Book
            if let url = URL(string: (book.cover?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed))!) {
                //print("URL: \(url.description)")
                bookDetailViewController.book = book
                bookDetailViewController.view.layoutIfNeeded()
                bookDetailViewController.background.hnk_setImageFromURL(url)
                bookDetailViewController.view.backgroundColor = bgColor
            }
        }
    }
    
}

//MARK: - Collection Delegate
extension BooksViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = bookDataSource.books[indexPath.row]
        book.cover = defaults.string(forKey: "cdnBaseURL")! + "/" + book.cover!
        performSegue(withIdentifier: "showDetail", sender: book)
    }
    
}

//MARK: - Search Delegates
extension BooksViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}

extension BooksViewController: UISearchBarDelegate {
    
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
    
}

//MARK: - Layout Delegate
fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
//fileprivate let itemsPerRow = 3
extension BooksViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow = defaults.integer(forKey: "booksPerRow")
        let paddingSpace = sectionInsets.left * CGFloat((itemsPerRow + 1))
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)
        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}


