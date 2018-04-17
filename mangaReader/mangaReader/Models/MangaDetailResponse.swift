//
//  MangaDetailResponse.swift
//  mangaReader
//
//  Created by Yiming Dong on 17/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import ObjectMapper

class MangaDetailResponse: Mappable {
    
    var aka:[String]?
    var aka_alias:[String]?
    var alias: String?
    var artist: String?
    var artist_kw:[String]?
    var author: String?
    var author_kw:[String]?
    var autoManga: Bool = false
    var baka: Bool = false
    var categories:[String]?
    var chapters:[Any]?
    var chapters_len: Int?
    var created: Double?
    var description: String?
    var hits: Int?
    var image: String?
    var imageURL: String?
    var language: Int?
    var last_chapter_date: Double?
    var released: Int?
    var startsWith: String?
    var status: Int?
    var title: String?
    var title_kw: [String]?
    var type: Int?
    var updatedKeywords: Bool?
    var url: String?
    
    var chapterObjects: [Chapter]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        aka <- map["aka"]
        aka_alias <- map["aka-alias"]
        
        alias <- map["alias"]
        artist <- map["artist"]
        artist_kw <- map["artist_kw"]
        author <- map["author"]
        author_kw <- map["author_kw"]
        autoManga <- map["autoManga"]
        baka <- map["baka"]
        categories <- map["categories"]
        chapters <- map["chapters"]
        chapters_len <- map["chapters_len"]
        
        created <- map["created"]
        description <- map["description"]
        hits <- map["hits"]
        image <- map["image"]
        imageURL <- map["imageURL"]
        language <- map["language"]
        last_chapter_date <- map["last_chapter_date"]
        released <- map["released"]
        startsWith <- map["startsWith"]
        
        status <- map["status"]
        title <- map["title"]
        title_kw <- map["title_kw"]
        type <- map["type"]
        updatedKeywords <- map["updatedKeywords"]
        url <- map["url"]
    }
    
}
