//
//  Book.swift
//  HomeComics
//
//  Created by Jean Sarda on 05/05/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import ObjectMapper

class Book: Mappable {
    var title: String?
    var authors: [Int]? // not sure this will map correctly as is
    var pages: Int?
    var year: Int?
    var id: Int?
    var location: String?
    var cover: String?
    var contents: [String]?
    let defaults = UserDefaults.standard
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        authors <- map["authors"]
        pages <- map["pages"]
        year <- map["year"]
        id <- map["id"]
        location <- map["location"]
        cover <- map["cover"]
        // contents is not always available, check that in init
        contents <- map["contents"]
    }
    
}

