//
//  RealMangaEdenManga.swift
//  mangaReader
//
//  Created by Yiming Dong on 2019/4/14.
//  Copyright © 2019 Yiming Dong. All rights reserved.
//

import Foundation

class RealMangaEdenManga: Codable {
    var t: String?  // title
    var a: String?  // alias
    var ld: Double?    // last chapter date
    var i: String?  // id
    var im: String? // image path
    var s: Int?     // status
    var h: Int?     // hits
    var c: [String]? // cagegories
    
    // custom vars
    var imageURL: String?
    var author: String?
    var source: String? = MangaSource.mangaEdenReal.rawValue
}

extension RealMangaEdenManga: MangaProtocol {
    
    var hits: Int? {
        get {
            return h
        }
        set {
            h = newValue
        }
    }
    
    var lastChapterDate: Double? {
        get {
            return ld
        }
        set {
            ld = newValue
        }
    }
    
    var mangaSource: String? {
        get {
            return source
        }
        set {
            source = newValue
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
