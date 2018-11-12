//
//  RecentManga.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/4/28.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import RealmSwift

class RecentManga: Object {
    @objc private dynamic var name = ""
    @objc private dynamic var author = ""
    @objc private dynamic var imagePath = ""
    @objc private dynamic var id = ""
    @objc dynamic var readTime = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension RecentManga: MangaProtocol {
    var topImageUrl: String? {
        return nil
    }
    
    var mangaAuthor: String? {
        get {
            return author
        }
        set {
            author = newValue ?? ""
        }
    }
    
    var mangaId: String? {
        get {
            return id
        }
        set {
            id = newValue ?? ""
        }
    }
    
    var mangaName: String? {
        get {
            return name
        }
        set {
            name = newValue ?? ""
        }
    }
    
    var coverImageUrl: String? {
        get {
            return imagePath
        }
        set {
            imagePath = newValue ?? ""
        }
    }
    
    var placeHolderImage: UIImage? {
        return ImageConstant.placeHolder.image
    }
    
    func canPublish() -> Bool {
        return true
    }
    
    var isCompleted: Bool {
        return true
    }
    
    var chapterObjects: [Chapter]? {
        return []
    }
    
    var mangaDescription: String? {
        return ""
    }
    
    var mangaCreateDate: Double {
        return 0.0
    }
    var mangaUpdateDate: Double {
        return 0.0
    }
    var mangaCategories: [String] {
        return []
    }
}
