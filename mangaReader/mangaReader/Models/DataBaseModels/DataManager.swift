//
//  DataManager.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/6.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import RealmSwift

class DataManager {
    
    let categoryRefresher: CategoryRefresherProtocol
    
    static let shared = DataManager()
    private init() {
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        categoryRefresher = FSInjector.shared.resolve(CategoryRefresherProtocol.self)!
    }
    
}

// MARK: recent manga
extension DataManager {
    func recordRecentManga(manga: MangaProtocol) {
        
        guard let mangaId = manga.mangaId else {return}
        
        let realm = try! Realm()
        let recentManga = RecentManga()
        recentManga.mangaId = mangaId
        recentManga.mangaName = manga.mangaName
        recentManga.coverImageUrl = manga.coverImageUrl
        recentManga.readTime = Date()
        try! realm.write {
            realm.add(recentManga, update:true)
        }
    }
}

// MARK: Current chapter
extension DataManager {
    func getCurrentChapter(mangaId: String?) -> MangaCurrentChapter? {
        let realm = try! Realm()
        
        guard let mangaId = mangaId, let currentChapter = realm.objects(MangaCurrentChapter.self).filter("mangaID = %@", mangaId).first else {
            return nil
        }
        
        return currentChapter
    }
    
    func recordCurrentChapter(chapterId: String?, mangaId: String?) {
        guard let mangaId = mangaId else {return}
        
        let realm = try! Realm()
        // delete the record first
        if let object = getCurrentChapter(mangaId: mangaId) {
            try! realm.write {
                realm.delete(object)
            }
        }

        guard let chapterId = chapterId else {
            return
        }
        
        // add record
        let manChapter = MangaCurrentChapter()
        manChapter.mangaID = mangaId
        manChapter.chapterID = chapterId
        manChapter.readTime = Date()
        try! realm.write {
            realm.add(manChapter, update:true)
        }
    }
}

// MARK: Favorite
extension DataManager {
    func isFavorite(mangaId: String?) -> Bool {
        guard let mangaId = mangaId else {return false}
        return getFavorite(mangaId: mangaId).count > 0
    }
    
    func getFavorite(mangaId: String) -> Results<FavoriteManga> {
        let realm = try! Realm()
        return realm.objects(FavoriteManga.self).filter("id = %@", mangaId)
    }
    
    func getAllFavorites() -> Results<FavoriteManga> {
        let realm = try! Realm()
        return realm.objects(FavoriteManga.self)
    }
    
    func addFavorite(manga: MangaProtocol) {
        guard let mangaId = manga.mangaId else {return}
        
        let realm = try! Realm()
        let favObjects = realm.objects(FavoriteManga.self).filter("id = %@", mangaId)
        if favObjects.count > 0 {
            try! realm.write {
                realm.delete(favObjects)
            }
        } else {
            
            let favManga = FavoriteManga()
            favManga.mangaId = mangaId
            favManga.mangaName = manga.mangaName
            favManga.coverImageUrl = manga.coverImageUrl
            
            try! realm.write {
                realm.add(favManga)
            }
        }
    }
    
    func deleteFavorite(mangaId: String) {
        let realm = try! Realm()
        let favObjects = realm.objects(FavoriteManga.self).filter("id = %@", mangaId)
        try! realm.write {
            realm.delete(favObjects)
        }
    }
}
