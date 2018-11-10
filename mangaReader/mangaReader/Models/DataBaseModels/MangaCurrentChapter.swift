//
//  MangaCurrentChapter.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/4/24.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import RealmSwift

class MangaCurrentChapter: Object {
    @objc dynamic var mangaID = ""
    @objc dynamic var chapterID = ""
    @objc dynamic var readTime = Date()
    
    override static func primaryKey() -> String? {
        return "mangaID"
    }
}
