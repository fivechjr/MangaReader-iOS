//
//  FavoriteManga.swift
//  mangaReader
//
//  Created by Yiming Dong on 23/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteManga: Object {
    @objc dynamic var name = ""
    @objc dynamic var imagePath = ""
    @objc dynamic var id = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
