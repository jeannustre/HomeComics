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
import AlamofireImage
import Chameleon

class BookDataSource: NSObject, UICollectionViewDataSource {
    
    var books = [Book]()
    var authors = [Author]()
    let downloader = ImageDownloader()
    let baseURL = "http://127.0.0.1:1337"
    let cdnURL = "http://127.0.0.1:8080/"
    let defaults = UserDefaults.standard
    
    func fetchBooks(completion: @escaping () -> ()) {
        let url = baseURL + "/book"
        Alamofire.request(url).responseArray { (response: DataResponse<[Book]>) in
            let bookArray = response.result.value
            if let bookArray = bookArray {
                self.books = bookArray
            }
            completion()
        }
    }
    
    func fetchAuthors(completion: @escaping () -> ()) {
        let url = baseURL + "/author"
        Alamofire.request(url).responseArray { (response: DataResponse<[Author]>) in
            let authorArray = response.result.value
            if let authorArray = authorArray {
                self.authors = authorArray
            }
            completion()
        }
    }
    
    //MARK: - CollectionView DataSource delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "bookCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! BookCollectionViewCell
        let book = books[indexPath.row]
        cell.titleLabel.text = book.title
        cell.authorLabel.text = ""
        let primaryColor = UIColor(hexString: defaults.string(forKey: "primaryColor"))
        let secondaryColor = UIColor(hexString: defaults.string(forKey: "secondaryColor"))
        let darkerPrimaryColor = primaryColor?.darken(byPercentage: 80)
        cell.backgroundColor = darkerPrimaryColor
        if let authorsID = book.authors {
            for authorID in authorsID {
                if cell.authorLabel.text != "" {
                    cell.authorLabel.text = cell.authorLabel.text! + ", "
                }
                let author = self.authors.filter {
                    $0.id == authorID
                }
                if author.count > 0 {
                    cell.authorLabel.text = cell.authorLabel.text! + author[0].name!
                }
            }
        }
        
        
        if let coverUrlString = book.cover {
            print("URL : <\(cdnURL + coverUrlString)>")
            let urlString = cdnURL + coverUrlString
            let escapedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
            if let url = URL(string: escapedUrl!) {
                
                cell.imageView.af_setImage(withURL: url)
            } else {
                print("invalid url?")
            }
        }
        
        
        return cell
    }
    
    
}
