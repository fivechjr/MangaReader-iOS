//
//  LamaMangaListViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/10.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import RxSwift

class LamaMangaListViewModel: MangaListViewModelProtocol {
    
    var sortByRecentUpdate: Bool = false
    
    var isLoading: Bool = false
    
    var selectedGenres: [String] = []
    var selectedGenresLocalized: [String] = []
    
    var mangasSignal = Variable<[MangaProtocol]>([])
    var mangasShowing: [MangaProtocol] {
        return mangasSignal.value
    }
    
    fileprivate var mangas:[MangaProtocol] = []
    
    var currentPage: Int = 0
    let pageSize: Int = 21
    
    func manga(atIndex index: Int) -> MangaProtocol? {
        if index < mangasShowing.count {
            return mangasShowing[index]
        }
        
        return nil
    }
    
    func loadFirstPage(completion: @escaping ([MangaProtocol]?, Error?) -> Void) {
        loadManga(page: 0, completion: completion)
    }
    
    func loadNextPage(completion: @escaping ([MangaProtocol]?, Error?) -> Void) {
        loadManga(page: currentPage + 1, completion: completion)
    }
    
    func refreshManga() -> [MangaProtocol] {
        let refreshedManga = filterManga(mangas)
        mangasSignal.value = refreshedManga
        
        return refreshedManga
    }
    
    func clearManga() {
        mangas = []
        mangasSignal.value = []
    }
}

extension LamaMangaListViewModel {
    
    fileprivate func loadManga(page: Int, completion: @escaping ([MangaProtocol]?, Error?) -> Void) {
        guard !isLoading else {
            completion(nil, nil)
            return
        }
        
        currentPage = page
        if currentPage <= 0 {
            currentPage = 0
            mangas.removeAll()
        }
        
        // load from network
        isLoading = true
        
        LamaApi.getTopics(tag: 200, offset: currentPage, limit: pageSize) { [weak self] (response, error) in
            guard let `self` = self, let comics = response?.data?.topics else {return}
            self.mangas.append(contentsOf: comics)
            self.mangasSignal.value = self.mangas
            completion(comics, error)
            self.isLoading = false
        }
    }
    
    fileprivate func filterManga(_ mangas: [MangaProtocol]) -> [MangaProtocol] {
        return mangas
    }
}