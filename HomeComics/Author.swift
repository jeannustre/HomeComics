//
//  Author.swift
//  HomeComics
//
//  Created by Jean Sarda on 05/05/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import ObjectMapper

class Author: Mappable {
    var name: String?
    var bio: String?
    var wrote: [Int]?
    var id: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        bio <- map["bio"]
        wrote <- map["wrote"]
        id <- map["id"]
    }
    
}

