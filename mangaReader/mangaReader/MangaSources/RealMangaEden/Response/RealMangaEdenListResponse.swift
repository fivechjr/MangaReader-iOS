//
//  RealMangaEdenListResponse.swift
//  mangaReader
//
//  Created by Yiming Dong on 2019/4/13.
//  Copyright © 2019 Yiming Dong. All rights reserved.
//

import Foundation

class RealMangaEdenListResponse: Codable {
    var page: Int?
    var start: Int?
    var end: Int?
    var manga: [RealMangaEdenManga]?
}

class RealMangaEdenManga: Codable {
    var t: String?  // title
    var a: String?  // alias
    var ld: Int?    // last chapter date
    var i: String?  // id
    var im: String? // image path
    var s: Int?     // status
    var h: Int?     // hits
    var c: [String]? // cagegories
    
    // custom vars
    var imageURL: String?
    var author: String?
}

extension RealMangaEdenManga: MangaProtocol {
    var mangaSource: String? {
        get {
            return MangaSource.mangaEdenReal.rawValue
        }
    }
    
    var mangaId: String? {
        get {
            return i
        }
        set {
            i = newValue
        }
    }
    
    var mangaName: String? {
        get {
            return t
        }
        set {
            t = newValue
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
    
    var mangaDescription: String? {
        return nil
    }
    
    var mangaCreateDate: Double {
        return 0
    }
    
    var mangaUpdateDate: Double {
        return Double(ld ?? 0)
    }
    
    var mangaCategories: [String] {
        return c ?? []
    }
    
    var coverImageUrl: String? {
        get {
            return imageURL ?? RealMangaEdenApi.getImageUrl(withImagePath: im)
        }
        set {
            imageURL = coverImageUrl
        }
    }
    
    var topImageUrl: String? {
        return nil
    }
    
    var placeHolderImage: UIImage? {
        return ImageConstant.placeHolder.image
    }
    
    func canPublish() -> Bool {
        var canPublish = true
        
        if let categories = c, Utility.strings(categories, containsAny: SensitiveData.categories) {
            canPublish = false
        }
        
        if let title = t, Utility.string(title, containsAny: SensitiveData.titles) {
            canPublish = false
        }
        
        return canPublish
    }
    
    var isCompleted: Bool {
        return s == 2
    }
    
    var chapterObjects: [ChapterProtocol]? {
        return nil
    }
}
