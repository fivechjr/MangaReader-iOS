//
//  LamaComic.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/10.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class LamaComic: Codable {
    var topic: LamaComicTopic?
    var can_view: Bool?
    var comments_count: Int?
    var cover_image_url: String?
    var created_at: Int?
    var id: Int?
    var info_type: Int?
    var is_free: Bool?
    var is_liked: Bool?
    var label_color: String?
    var label_text: String?
    var label_text_color: String?
    var likes_count: Int?
    var push_flag: Int?
    var selling_kk_currency: Int?
    var serial_no: Int?
    var shared_count: Int?
    var status: String?
    var storyboard_cnt: Int?
    var title: String?
    var updated_at: Int?
    var updated_count: Int?
    var url: String?
    var zoomable: Int?
}

// MangaProtocol
extension LamaComic: MangaProtocol {
    var mangaName: String? {
        get {
            return topic?.title
        }
        set {
            topic?.title = newValue
        }
    }
    
    var mangaAuthor: String? {
        get {
            return topic?.user
        }
        set {
            topic?.user = newValue
        }
    }
    
    var coverImageUrl: String? {
        get {
            return topic?.cover_image_url
        }
        set {
            topic?.cover_image_url = newValue
        }
    }
    
    var mangaId: String? {
        get {
            guard let id = topic?.id else {return nil}
            return String(id)
        }
        
        set(value) {
            topic?.id = Int(value ?? "0")
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
    var chapterObjects: [Chapter]? {
        return []
    }
    
    var mangaDescription: String? {
        return topic?.description
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
