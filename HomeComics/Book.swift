//
//  Book.swift
//  HomeComics
//
//  Created by Jean Sarda on 24/04/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import ObjectMapper

class Book: Mappable {
    var title: String?
    var author: String?
    var pages: Int?
    var year: Int?
    var contents: [Page]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        author <- map["author"]
        pages <- map["pages"]
        year <- map["year"]
        contents <- map["contents"]
    }
    
}
