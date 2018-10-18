//
//  RecentViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/18.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import RealmSwift

class RecentViewModel {
    var recentManga: Results<RecentManga>?
    
    func deleteAll() {
        let realm = try! Realm()
        let object = realm.objects(RecentManga.self)
        try! realm.write {
            realm.delete(object)
        }
    }
    
    func deleteRecent(mangaId: String) {
        let realm = try! Realm()
        let favObjects = realm.objects(RecentManga.self).filter("id = %@", mangaId)
        try! realm.write {
            realm.delete(favObjects)
        }
    }
    
    func loadData() {
        let realm = try! Realm()
        recentManga = realm.objects(RecentManga.self).sorted(byKeyPath: "readTime", ascending: false)
    }
    
    var count: Int {
        return recentManga?.count ?? 0
    }
    
    subscript(index: Int) -> RecentManga? {
        guard let recentManga = recentManga, index < recentManga.count, index >= 0 else {
            return nil
        }
        
        return recentManga[index]
    }
}
