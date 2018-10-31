//
//  MangaListViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/6.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import RxSwift

class MangaListViewModel {
    var sortByRecentUpdate = false
    var mangaSort: MangaSort {
        return sortByRecentUpdate ? .last_chapter_date : .hits
    }
    
    var isLoading: Bool = false
    
    var selectedGenres: [String] = []
    var selectedGenresLocalized: [String] = []
    
    var mangasSignal = Variable<[Manga]>([])
    var mangasShowing: [Manga] {
        return mangasSignal.value
    }
    
    fileprivate var mangas:[Manga] = []
    
    var currentPage: Int = 0
    let pageSize: Int = 21
    
    func manga(atIndex index: Int) -> Manga? {
        if index < mangasShowing.count {
            return mangasShowing[index]
        }
        
        return nil
    }
    
    func loadFirstPage(completion: @escaping ([Manga]?, Error?) -> Void) {
        loadManga(page: 0, completion: completion)
    }
    
    func loadNextPage(completion: @escaping ([Manga]?, Error?) -> Void) {
        loadManga(page: currentPage + 1, completion: completion)
    }
    
    func refreshManga() -> [Manga] {
        let refreshedManga = filterManga(mangas)
        mangasSignal.value = refreshedManga
        
        return refreshedManga
    }
    
    func clearManga() {
        mangas = []
        mangasSignal.value = []
    }
}

extension MangaListViewModel {
    
    fileprivate func loadManga(page: Int, completion: @escaping ([Manga]?, Error?) -> Void) {
        guard !isLoading else {
            completion(nil, nil)
            return
        }
        
        currentPage = page
        if currentPage <= 0 {
            currentPage = 0
            mangas.removeAll()
        }
        
        // Load from cache
        let cachedManaga = MangaCache.getMangaList(page: currentPage, size: pageSize, sort: mangaSort)
        if !cachedManaga.isEmpty {
            mangas.append(contentsOf: cachedManaga)
            _ = refreshManga()
            completion(cachedManaga, nil)
            return
        }
        
        // load from network
        isLoading = true
        DataRequester.getMangaList(page: currentPage, size: pageSize, sort: mangaSort) { [weak self] (mangalist, error) in
            guard let `self` = self else {return}
            self.mangas.append(contentsOf: mangalist ?? [])
            let refreshedManga = self.refreshManga()
            MangaCache.saveMangaList(mangaList: refreshedManga, currentPage: self.currentPage, size: self.pageSize, sort: self.mangaSort)
            
            completion(mangalist, error)
            self.isLoading = false
        }
    }
    
    fileprivate func filterManga(_ mangas: [Manga]) -> [Manga] {
        return mangas.filter {$0.canPublish()}
    }
    
    fileprivate func sortManga(_ mangas: [Manga]) -> [Manga] {
        if (sortByRecentUpdate) {
            return mangas.sorted(by: { ($0.last_chapter_date ?? 0) > ($1.last_chapter_date ?? 0) })
        } else {
            return mangas.sorted(by: { ($0.hits ?? 0) > ($1.hits ?? 0) })
        }
    }
}
