//
//  BookDataSource.swift
//  HomeComics
//
//  Created by Jean Sarda on 07/05/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import Chameleon

fileprivate let cellIdentifier = "bookCell"

class BookDataSource: NSObject {
    
    var books = [Book]()
    var filteredBooks = [Book]()
    var authors = [Author]()
    let defaults = UserDefaults.standard
    var searching = false
    
    func fetchBooks(completion: @escaping () -> ()) {
        let url = defaults.string(forKey: "serverBaseURL")! + "/book"
        Alamofire.request(url).responseArray { (response: DataResponse<[Book]>) in
            let bookArray = response.result.value
            if let bookArray = bookArray {
                self.books = bookArray
            }
            completion()
        }
    }
    
    func fetchAuthors(completion: @escaping () -> ()) {
        let url = defaults.string(forKey: "serverBaseURL")! + "/author"
        Alamofire.request(url).responseArray { (response: DataResponse<[Author]>) in
            let authorArray = response.result.value
            if let authorArray = authorArray {
                self.authors = authorArray
            }
            completion()
        }
    }
    
    func searchWith(_ string: String, completion: @escaping () ->()) {
        if string.isEmpty {
            searching = false
            completion()
        } else {
            searching = true
            let filtered = self.books.filter { ($0.title?.lowercased().contains(string.lowercased()))! }
            if filtered.count != filteredBooks.count {
                filteredBooks = filtered
              completion()
            }
        }
    }
    
    func setupCache() {
    
    }
    
}

//MARK: - CollectionView DataSource extension
extension BookDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.searching {
            return filteredBooks.count
        } else {
            return books.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! BookCollectionViewCell
        let book = self.searching ? filteredBooks[indexPath.row] : books[indexPath.row]
        let cellBackground = UIColor(hexString: defaults.string(forKey: "primaryColor"))
        cell.configureWith(book: book, authors: self.authors, background: cellBackground!)
        if let coverUrlString = book.cover {
            let cdnURL = defaults.string(forKey: "cdnBaseURL")
            let urlString = cdnURL! + "/" + coverUrlString
            let escapedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
            cell.imageURL = escapedUrl
            if let url = URL(string: escapedUrl!) {
                cell.imageView.hnk_setImageFromURL(url)
            } else {
                print("invalid url?")
            }
        }
        return cell
    }

}
