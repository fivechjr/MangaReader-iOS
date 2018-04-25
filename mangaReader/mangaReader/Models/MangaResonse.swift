//
//  MangaResonse.swift
//  mangaReader
//
//  Created by Yiming Dong on 16/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import ObjectMapper

class MangaResponse: Mappable {
    var title: String?
    var updateTime: Float?
    var imagePath: String?
    var id: String?
    var hitCount: Int?
    var categories: [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title <- map["t"]
        updateTime <- map["ld"]
        imagePath <- map["im"]
        id <- map["i"]
        hitCount <- map["h"]
        categories <- map["c"]
    }
}

/*
 "a": "has-the-rain-stopped",
 "c": [
 "Fantasy",
 "Seinen",
 "Supernatural"
 ],
 "h": 26,
 "i": "5aa9b638719a1652eae2652d",
 "im": "e3/e3c0dbd44eecf6f9018ad2aec33391159355b0193d0cb603a3bbff03.png",
 "ld": 1521150781.0,
 "s": 2,
 "t": "Has the rain stopped?"
 */
