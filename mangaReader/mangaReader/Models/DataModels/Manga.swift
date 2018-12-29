//
//  Manga.swift
//  mangaReader
//
//  Created by Yiming Dong on 17/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class Manga: Codable {
    /// manga id
    var mangaedenid: String?
    private var _id: String?
    
    /// other names in different languages
    var aka:[String]?
    var aka_alias:[String]?
    var alias: String?
    var artist: String?
    var artist_kw:[String]?
    var author: String?
    var author_kw:[String]?
    var autoManga: Bool?
    var baka: Bool?
    private var categories:[String]?
    var categoriesstr: String?
    var chapters:[[CodableValue?]]?
    var chapters_len: Int?
    /// create time
    private var created: Double?
    private var description: String?
    var hits: Int?
    
    private var image: String?
    private var imageURL: String?
    var url: String?
    
    var language: Int?
    private var last_chapter_date: Double?
    /// released year
    var released: Int?
    /// the first letter of the title
    var startsWith: String?
    /// status 0-uncomplete, 1-complete
    var status: Int?
    private var title: String?
    var title_kw: [String]?
    var type: Int?
    var updatedKeywords: Bool?
    
    var random: [Double]?
    
    var topImageUrl: String?
}

// MangaProtocol
extension Manga: MangaProtocol {
    var mangaSource: String? {
        get {
            return MangaSource.mangaEden.rawValue
        }
        set {
            
        }
    }
    
    var mangaName: String? {
        get {
            return title
        }
        set {
            title = newValue
        }
    }
    
    var mangaAuthor: String? {
        get {
            return author
        }
        set {
            author = newValue
        }
    }
    
    var coverImageUrl: String? {
        get {
            return imageURL ?? MangaEdenApi.getImageUrl(withImagePath: image)
        }
        set {
            imageURL = coverImageUrl
        }
    }
    
    var mangaId: String? {
        get {
            return mangaedenid
        }
        set {
            mangaedenid = newValue
        }
    }
    
    var placeHolderImage: UIImage? {
        return ImageConstant.placeHolder.image
    }
    
    func canPublish() -> Bool {
        var canPublish = true
        
        if let categories = categories, Utility.strings(categories, containsAny: SensitiveData.categories) {
            canPublish = false
        }
        
        if let title = title, Utility.string(title, containsAny: SensitiveData.titles) {
            canPublish = false
        }
        
        return canPublish
    }
    
    var isCompleted: Bool {
        guard let status = status else {return false}
        return status == 1
    }
    
    var chapterObjects: [ChapterProtocol]? {
        return chapters?.map {EdenChapter(datas: $0)}
    }
    
    var mangaDescription: String? {
        return description
    }
    
    var mangaCreateDate: Double {
        return last_chapter_date ?? 0.0
    }
    var mangaUpdateDate: Double {
        return created ?? 0.0
    }
    
    var mangaCategories: [String] {
        return categories ?? []
    }
}
