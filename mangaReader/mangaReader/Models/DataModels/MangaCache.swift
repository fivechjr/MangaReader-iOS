//
//  MangaCache.swift
//  mangaReader
//
//  Created by Yiming Dong on 29/10/18.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class MangaCache {
    
    private static let hits = MangaCache(sort: .hits)
    private static let recent = MangaCache(sort: .last_chapter_date)
    
    var sort: MangaSort
    
    init(sort: MangaSort) {
        self.sort = sort
    }
    
    private var cacheKey: String {
        return "manga_list_" + sort.rawValue
    }
    
    private var _mangaListCache: MangaListCacheModel?
    var mangaListCache: MangaListCacheModel? {
        get {
            if let _mangaListCache = _mangaListCache {
                return _mangaListCache
            } else {
                _mangaListCache = SharedPreferences.shared.load(forKey: cacheKey, ofType: MangaListCacheModel.self)
                return _mangaListCache
            }
        }
        
        set(value) {
            _mangaListCache = value
            SharedPreferences.shared.save(object: value, forKey: cacheKey)
        }
    }
    
    func getManga(page: Int, size: Int) -> [Manga] {
        let start = page * size
        let end = start + size - 1
        guard let mangaList = mangaListCache?.mangaList, end < mangaList.count else {
            return []
        }
        
        return Array(mangaList[start...end])
    }
    
    static func getMangaList(page: Int, size:Int, sort: MangaSort) -> [Manga] {
        let cache = (sort == .hits ? hits : recent)
        return cache.getManga(page: page, size: size)
    }
    
    static func saveMangaList(mangaList: [Manga], currentPage: Int, size:Int, sort: MangaSort) {
        let cache = (sort == .hits ? hits : recent)
        let model = MangaListCacheModel(mangaList: mangaList, currentPage: currentPage, pageSize: size)
        cache.mangaListCache = model
    }
}

class MangaListCacheModel: Codable {
    var currentPage: Int
    var pageSize: Int
    var mangaList: [Manga]
    
    init(mangaList: [Manga], currentPage: Int, pageSize: Int) {
        self.mangaList = mangaList
        self.currentPage = currentPage
        self.pageSize = pageSize
    }
}
