//
//  LamaComic.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/10.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class LamaComic: Codable {
    var topic: LamaTopic?
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

extension LamaComic: ChapterProtocol {
    var chapterId: String? {
        get {
            return "\(id ?? 0)"
        }
        set {
            id = Int(newValue ?? "0")
        }
    }
    
    var chapterTitle: String? {
        get {
            return title
        }
        set {
            title = newValue
        }
    }
    
    var chapterUpdateTime: Double? {
        get {
            return Double(updated_at ?? 0)
        }
        set {
            updated_at = Int(newValue ?? 0)
        }
    }
    
}
