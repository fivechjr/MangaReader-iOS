//
//  LamaChapter.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/9.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class LamaChapter: Codable {
    var banner_info: String?
    var comments_count: Int?
    var cover_image_url: String?
    var created_at: Int?
    private var id: Int?
    var image_infos: String?
    private var images: [String]?
    var is_favourite: Bool?
    var is_liked: Bool?
    var likes_count: Int?
    var next_comic_id: String?
    var previous_comic_id: Int?
    var push_flag: Int?
    var recommend_count: Int?
    var refLink: String?
    var serial_no: Int?
    var status: String?
    var storyboard_cnt: String?
    var title: String?
    var topic: LamaTopic?
    var updated_at: Int?
    var url: String?
}

extension LamaChapter: ChapterDetailProtocol {
    var chapterId: String? {
        get {
            return "\(id ?? 0)"
        }
        set {
            id = Int(newValue ?? "0")
        }
    }
    
    var chapterImages: [String]? {
        return images
    }
    
    
}
