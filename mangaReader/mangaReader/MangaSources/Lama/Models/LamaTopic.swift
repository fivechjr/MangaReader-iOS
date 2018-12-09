//
//  LamaTopic.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/10.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class LamaTopic: Codable {
    var comics:[LamaComic]?
    var comics_count: Int?
    var cover_image_url: String?
    var created_at: Int?
    var description: String?
    var discover_image_url: String?
    var id: Int?
    var is_favourite: Bool?
    var label_id: Int?
    var order: Int?
    var related_authors: String?
    var title: String?
    var update_day: String?
    var update_status: String?
    var updated_at: Int?
    var user: String?
    var vertical_image_url: String?
}

// MangaProtocol
extension LamaTopic: MangaProtocol {
    var topImageUrl: String? {
        return cover_image_url
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
            return user
        }
        set {
            user = newValue
        }
    }
    
    var coverImageUrl: String? {
        get {
            return cover_image_url
        }
        set {
            cover_image_url = newValue
        }
    }
    
    var mangaId: String? {
        get {
            guard let id = id else {return nil}
            return String(id)
        }
        
        set(value) {
            id = Int(value ?? "0")
        }
    }
    
    var placeHolderImage: UIImage? {
        return ImageConstant.placeHolder.image
    }
    
    func canPublish() -> Bool {
        return true
    }
    
    var isCompleted: Bool {
        return false
    }
    var chapterObjects: [EdenChapter]? {
        return []
    }
    
    var mangaDescription: String? {
        return description
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
