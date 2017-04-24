//
//  Page.swift
//  HomeComics
//
//  Created by Jean Sarda on 24/04/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import ObjectMapper

class Page {
    
    var location: String?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        location <- map["location"]
    }
    
}
