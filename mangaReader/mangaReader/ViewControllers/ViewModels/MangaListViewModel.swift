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
    
    var isLoading: Bool = false
    
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
        loadManga(page: 0, completion: completion)
    }
    
    func loadNextPage(completion: @escaping MangaListResponseHandler) {
        loadManga(page: currentPage + 1, completion: completion)
    }
    
    func refreshManga() {
        mangasSignal.value = filterManga(mangas)
    }
}

extension MangaListViewModel {
    
    fileprivate func loadManga(page: Int, completion: @escaping MangaListResponseHandler) {
        guard !isLoading else {
            completion(nil, nil)
            return
        }
        
        currentPage = page
        if currentPage <= 0 {
            currentPage = 0
            mangas.removeAll()
        }
        
        isLoading = true
        DataRequester.getMangaList(page: currentPage, size: pageSize) { [weak self] (response, error) in
            guard let `self` = self else {return}
            self.mangas.append(contentsOf: response?.mangalist ?? [])
            self.refreshManga()
            completion(response, error)
            self.isLoading = false
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
