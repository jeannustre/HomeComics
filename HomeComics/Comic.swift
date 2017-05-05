//
//  Comic.swift
//  HomeComics
//
//  Created by Jean Sarda on 05/05/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import ObjectMapper

class Comic: Mappable {
    var title: String?
    var author: String?
    var pages: Int?
    var year: Int?
    var id: Int?
    var location: String?
    var cover: String?
    var contents: [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        author <- map["author"]
        pages <- map["pages"]
        year <- map["year"]
        id <- map["id"]
        location <- map["location"]
        cover <- map["cover"]
        contents <- map["contents"]
    }
    
}

