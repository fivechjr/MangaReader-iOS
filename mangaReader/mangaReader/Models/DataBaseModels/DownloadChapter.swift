//
//  DownloadChaper.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/29.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import RealmSwift

class DownloadChapter: Object {
    @objc dynamic var chapterId = ""
    @objc dynamic var mangaId = ""
    @objc dynamic var total = 0
    @objc dynamic var downloaded = 0
    
    override static func primaryKey() -> String? {
        return "chapterId"
    }
    
    var isDownloaded: Bool {
        return downloaded >= total
    }
    
    var downloadProgress: Double {
        return total > 0 ? Double(downloaded) / Double(total) : 0
    }
}
