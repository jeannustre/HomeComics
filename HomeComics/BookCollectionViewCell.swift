//
//  BookCollectionViewCell.swift
//  HomeComics
//
//  Created by Jean Sarda on 07/05/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit
import Chameleon

class BookCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var authorLabel: UILabel!
    
    var imageURL: String?
    
    func configureWith(book: Book, authors: [Author], background: UIColor) {
        titleLabel.text = book.title
        authorLabel.text = ""
        backgroundColor = background
        for authorID in book.authors! { // for each author id in the book
            if !((authorLabel.text?.isEmpty)!) { // if it's the second author or more,
                authorLabel.text = authorLabel.text! + ", " // we separate them
            }
            let author = authors.filter { $0.id == authorID } // get the Author that matches the current book.author id
            if author.count > 0 {
                authorLabel.text = authorLabel.text! + author[0].name!
            }

        }
    }
    
}
