//
//  MangaListResponse.swift
//  mangaReader
//
//  Created by Yiming Dong on 16/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import ObjectMapper

class MangaListResponse: Mappable {
    var result: Int?
    var mangas: [MangaResponse]?
    var start: Int?
    var end: Int?
    var page: Int?
    var total: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        result <- map["result"]
        mangas <- map["manga"]
        start <- map["start"]
        end <- map["end"]
        page <- map["page"]
        total <- map["total"]
    }
}
