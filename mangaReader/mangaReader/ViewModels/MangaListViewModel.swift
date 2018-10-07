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
    
    var mangasSignal = Variable<[Manga]>([])
    var mangasShowing: [Manga] {
        return mangasSignal.value
    }
    
    fileprivate var mangas:[Manga] = []
    
    var selectedGenres: [String] = []
    var selectedGenresLocalized: [String] = []
    
    var currentPage: Int = 0
    let pageSize: Int = 21
    
    func manga(atIndex index: Int) -> Manga? {
        if index < mangasShowing.count {
            return mangasShowing[index]
        }
        
        return nil
    }
    
    func loadFirstPage(completion: @escaping MangaListResponseHandler) {
        currentPage = 0
        loadManga(completion: completion)
    }
    
    func loadNextPage(completion: @escaping MangaListResponseHandler) {
        currentPage += 1
        loadManga(completion: completion)
    }
    
    func refreshManga() {
        mangasSignal.value = sortManga(filterManga(mangas))
    }
}

extension MangaListViewModel {
    
    fileprivate func loadManga(completion: @escaping MangaListResponseHandler) {
        if currentPage <= 0 {
            currentPage = 0
            mangas.removeAll()
        }
        
        DataRequester.getMangaList(page: currentPage, size: pageSize) { [weak self] (response, error) in
            guard let `self` = self else {return}
            self.mangas.append(contentsOf: response?.mangalist ?? [])
            self.refreshManga()
            completion(response, error)
        }
    }
    
    fileprivate func filterManga(_ mangas: [Manga]) -> [Manga] {
        return mangas.filter({ (manga) -> Bool in
            
            guard manga.canPublish() else {
                return false
            }
            
            var isOfGenres = true
            
            if selectedGenres.count > 0 {
                isOfGenres = selectedGenres.reduce(true, { (result, genre) -> Bool in
                    if let categories = manga.categories, categories.contains(genre) {
                        return result && true
                    } else {
                        return false
                    }
                })
            }
            
            return isOfGenres
        })
    }
    
    fileprivate func sortManga(_ mangas: [Manga]) -> [Manga] {
        if (sortByRecentUpdate) {
            return mangas.sorted(by: { ($0.last_chapter_date ?? 0) > ($1.last_chapter_date ?? 0) })
        } else {
            return mangas.sorted(by: { ($0.hits ?? 0) > ($1.hits ?? 0) })
        }
    }
}
