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
    @objc dynamic var name = ""
    @objc dynamic var imagePath = ""
    @objc dynamic var id = ""
    @objc dynamic var readTime = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
