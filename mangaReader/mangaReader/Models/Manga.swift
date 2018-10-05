//
//  Manga.swift
//  mangaReader
//
//  Created by Yiming Dong on 17/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
//import ObjectMapper

class Manga: Codable {
    var mangaedenid: String?
    var _id: String?
    
    var aka:[String]?
    var aka_alias:[String]?
    var alias: String?
    var artist: String?
    var artist_kw:[String]?
    var author: String?
    var author_kw:[String]?
    var autoManga: Bool?
    var baka: Bool?
    var categories:[String]?
    var categoriesstr: String?
    var chapters:[[CodableValue?]]?
    var chapters_len: Int?
    var created: Double?
    var description: String?
    var hits: Int?
    
    var image: String?
    var imageURL: String?
    var url: String?
    
    var language: Int?
    var last_chapter_date: Double?
    var released: Int?
    var startsWith: String?
    var status: Int?
    var title: String?
    var title_kw: [String]?
    var type: Int?
    var updatedKeywords: Bool?
    
    var random: [Double]?
    
    var chapterObjects: [Chapter]? {
        return chapters?.map {Chapter(datas: $0)}
    }
    
    var imagePath: String? {
        return imageURL ?? DataRequester.getImageUrl(withImagePath: image)
    }
    
    func canPublish() -> Bool {
        var canPublish = true
        if let categories = categories, categories.contains("Adult") {
            canPublish = false
        }
        
        if let title = title {
            if title.lowercased().contains("sex") || title == "High School DxD" {
                canPublish = false
            }
        }
        
        return canPublish
    }
}
