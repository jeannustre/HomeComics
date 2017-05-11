//
//  HCFormats.swift
//  HomeComics
//
//  Created by Jean Sarda on 11/05/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit
import Haneke

final class HCFormats {
    
    private init() { }
    
    static let shared = HCFormats()
    
    let reader = Format<UIImage>(name: "ReaderCache", diskCapacity: UInt64(UserDefaults.standard.integer(forKey: "diskCache")) * 1024 * 1024)
    
}
