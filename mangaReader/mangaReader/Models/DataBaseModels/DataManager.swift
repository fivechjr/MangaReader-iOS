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
    
    private var cachedManga: [MangaProtocol] = []
    
    let categoryRefresher: CategoryRefresherProtocol
    
    static let shared = DataManager()
    private init() {
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        categoryRefresher = FSInjector.shared.resolve(CategoryRefresherProtocol.self)!
    }
    
}

// MARK: recent manga
extension DataManager {
    func getRecentManga() -> Results<RecentManga> {
        let realm = try! Realm()
        return realm.objects(RecentManga.self).filter("source = %@", MangaSource.current.rawValue).sorted(byKeyPath: "readTime", ascending: false)
    }
    
    func recordRecentManga(manga: MangaProtocol) {
        
        guard let mangaId = manga.mangaId else {return}
        
        let realm = try! Realm()
        let recentManga = RecentManga()
        recentManga.mangaId = mangaId
        recentManga.mangaName = manga.mangaName
        recentManga.coverImageUrl = manga.coverImageUrl
        recentManga.readTime = Date()
        recentManga.mangaSource = manga.mangaSource
        
        try! realm.write {
            realm.add(recentManga, update:true)
        }
    }
    
    func deleteRecentManga(_ mangaId: String) {
        let realm = try! Realm()
        let favObjects = realm.objects(RecentManga.self).filter("id = %@", mangaId)
        try! realm.write {
            realm.delete(favObjects)
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
        return realm.objects(FavoriteManga.self).filter("source = %@", MangaSource.current.rawValue)
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
            favManga.mangaSource = manga.mangaSource
            
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

// MARK: Cache
extension DataManager {
    
    func getAllCachedManga(sort: MangaSort) -> [MangaProtocol] {
        
        return cachedManga.sorted(by: { (manga1, manga2) -> Bool in
            if sort == MangaSort.hits {
                return manga1.hits ?? 0 > manga2.hits ?? 0
            } else {
                return manga1.lastChapterDate ?? 0 > manga2.lastChapterDate ?? 0
            }
        })
        
//        let realm = try! Realm()
//        return realm.objects(CachedManga.self)
//            .filter("source = %@", MangaSource.current.rawValue)
//        .sorted(byKeyPath: sort.realmKey, ascending: false)
    }
    
    func cacheMangaList(_ mangas: [MangaProtocol], completion: @escaping () -> Void) {
        cachedManga = mangas
        completion()
        
//        DispatchQueue.global(qos: .utility).async {
//
//            self.deleteAllCachedManga()
//
//            mangas.forEach { (manga) in
//                self.cacheManga(manga)
//            }
//
//            DispatchQueue.main.async {
//                completion()
//            }
//        }
    }
    
    private func cacheManga(_ manga: MangaProtocol) {
        guard let mangaId = manga.mangaId else {return}
        
        let realm = try! Realm()
        let favObjects = realm.objects(CachedManga.self).filter("id = %@", mangaId)
        if favObjects.count > 0 {
            try! realm.write {
                realm.delete(favObjects)
            }
        }
        
        let cachedManga = CachedManga()
        cachedManga.mangaId = mangaId
        cachedManga.mangaName = manga.mangaName
        cachedManga.coverImageUrl = manga.coverImageUrl
        cachedManga.mangaSource = manga.mangaSource
        cachedManga.hits = manga.hits ?? 0
        cachedManga.lastChapterDate = manga.lastChapterDate ?? 0
        
        try! realm.write {
            realm.add(cachedManga)
        }
    }
    
    func deleteAllCachedManga() {
        cachedManga = []
//        let realm = try! Realm()
//        let favObjects = realm.objects(CachedManga.self)
//        try! realm.write {
//            realm.delete(favObjects)
//        }
    }
    
    private func deleteCachedManga(mangaId: String) {
        let realm = try! Realm()
        let favObjects = realm.objects(CachedManga.self).filter("id = %@", mangaId)
        try! realm.write {
            realm.delete(favObjects)
        }
    }
}

// MARK: download manga
extension DataManager {
    func getAllDownloadManga() -> Results<DownloadManga> {
        let realm = try! Realm()
        return realm.objects(DownloadManga.self).filter("source = %@", MangaSource.current.rawValue)
    }
    
    func addDownloadManga(manga: MangaProtocol) {
        guard let mangaId = manga.mangaId else {return}
        
        let realm = try! Realm()
        let objects = realm.objects(DownloadManga.self).filter("id = %@", mangaId)
        if objects.count == 0 {
            let downloadManga = DownloadManga()
            downloadManga.mangaId = mangaId
            downloadManga.mangaName = manga.mangaName
            downloadManga.coverImageUrl = manga.coverImageUrl
            downloadManga.mangaSource = manga.mangaSource
            
            try! realm.write {
                realm.add(downloadManga)
            }
        }
    }
    
    func deleteDownloadManga(mangaId: String) {
        let realm = try! Realm()
        let objects = realm.objects(DownloadManga.self).filter("id = %@", mangaId)
        try! realm.write {
            realm.delete(objects)
        }
    }
}

// MARK: download chapter
extension DataManager {
    func getDownloadedChapters(_ mangaId: String) -> Results<DownloadChapter> {
        let realm = try! Realm()
        return realm.objects(DownloadChapter.self).filter("mangaId = %@", mangaId)
    }
    
    func addDownloadChapeter(chapterDetail: ChapterDetailProtocol?, mangaId: String?) {
        guard let chapterDetail = chapterDetail, let chapterId = chapterDetail.chapterId, let mangaId = mangaId else {return}
        
        let realm = try! Realm()
        let objects = realm.objects(DownloadChapter.self).filter("chapterId = %@", chapterId)
        if objects.count == 0 {
            
            let newChapter = DownloadChapter()
            newChapter.chapterId = chapterId
            newChapter.mangaId = mangaId
            newChapter.total = chapterDetail.chapterImages?.count ?? 0
            
            try! realm.write {
                realm.add(newChapter)
            }
        }
    }
    
    func downloadProgress(_ chapterId: String?) -> Double {
        guard let chapterId = chapterId else {return 0}
        
        let realm = try! Realm()
        return realm.objects(DownloadChapter.self).filter("chapterId = %@", chapterId).first?.downloadProgress ?? 0
    }
    
    func isDownloaded(_ chapterId: String?) -> Bool {
        guard let chapterId = chapterId else {return false}
        
        let realm = try! Realm()
        return realm.objects(DownloadChapter.self).filter("chapterId = %@", chapterId).first?.isDownloaded ?? false
    }
    
    func updateDownloadChapter(_ chapterId: String?, downloaded: Int) {
        guard let chapterId = chapterId else {return}
        
        let realm = try! Realm()
        let objects = realm.objects(DownloadChapter.self).filter("chapterId = %@", chapterId)
        if let chapter = objects.first {
            try! realm.write {
                chapter.downloaded = downloaded
                realm.add(chapter, update: true)
            }
        }
    }
    
    func deleteDownloadChapeter(chapterId: String) {
        let realm = try! Realm()
        let objects = realm.objects(DownloadManga.self).filter("chapterId = %@", chapterId)
        try! realm.write {
            realm.delete(objects)
        }
    }
}
