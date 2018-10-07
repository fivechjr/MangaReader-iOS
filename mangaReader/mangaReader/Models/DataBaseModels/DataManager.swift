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
    
    enum CacheKey: String {
        case key_manga_categories
    }
    
    static let shared = DataManager()
    private init() {
        categories = UserDefaults.standard.array(forKey: CacheKey.key_manga_categories.rawValue) as? [String] ?? []
        print("Got cached categories: \(categories)")
    }
    
    private(set) var categories: [String] = []
    private(set) var legalCategories: [String] = []
    
    func loadData() {
        DataRequester.getCategories { [weak self] (response, error) in
            guard let `self` = self else {return}
            self.categories.removeAll()
            self.categories.append(contentsOf: response?.categoryNames ?? [])
            self.legalCategories = self.categories.compactMap { Utility.string($0, containsAny: SensitiveData.categories) ? nil : $0}
            
            UserDefaults.standard.set(self.categories, forKey: CacheKey.key_manga_categories.rawValue)
        }
    }
}

// MARK: recent manga
extension DataManager {
    func recordRecentManga(manga: Manga) {
        
        guard let mangaId = manga.id else {return}
        
        let realm = try! Realm()
        let recentManga = RecentManga()
        recentManga.id = mangaId
        recentManga.name = manga.title ?? ""
        recentManga.imagePath = manga.imagePath ?? ""
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
    
    func addFavorite(manga: Manga) {
        guard let mangaId = manga.id else {return}
        
        let realm = try! Realm()
        let favObjects = realm.objects(FavoriteManga.self).filter("id = %@", mangaId)
        if favObjects.count > 0 {
            try! realm.write {
                realm.delete(favObjects)
            }
        } else {
            
            let favManga = FavoriteManga()
            favManga.id = mangaId
            favManga.name = manga.title ?? ""
            favManga.imagePath = manga.imagePath ?? ""
            
            try! realm.write {
                realm.add(favManga)
            }
        }
    }
}
