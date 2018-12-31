//
//  EdenMangaListViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/6.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import RxSwift

class EdenMangaListViewModel: MangaListViewModelProtocol {
    var source: MangaSource {
        return .mangaEden
    }
    
    var sortByRecentUpdate = false
    private var mangaSort: MangaSort {
        return sortByRecentUpdate ? .last_chapter_date : .hits
    }
    
    var isLoading: Bool = false
    
    var selectedCategories: [CategoryProtocol]  = []
    
    private var categoryNames: [String] {
        return selectedCategories.map({$0.title})
    }
    
    func didSelectCategory(_ category: CategoryProtocol) -> Bool {
        if selectedCategories.firstIndex(where: {$0.id == category.id}) == nil {
            selectedCategories.append(category)
            return true
        }
        return false
    }
    
    var mangasSignal = Variable<[MangaProtocol]>([])
    var mangasShowing: [MangaProtocol] {
        return mangasSignal.value
    }
    
    private var mangas:[MangaProtocol] = []
    
    private var currentPage: Int = 0
    private let pageSize: Int = 21
    
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
    
    private func refreshManga() -> [MangaProtocol] {
        let refreshedManga = filterManga(mangas)
        mangasSignal.value = refreshedManga
        
        return refreshedManga
    }
    
    func clearManga() {
        mangas = []
        mangasSignal.value = []
    }
}

extension EdenMangaListViewModel {
    
    private  func loadManga(page: Int, completion: @escaping ([MangaProtocol]?, Error?) -> Void) {
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
        // Only use cached data if no genres selected
        if !cachedManaga.isEmpty && selectedCategories.isEmpty {
            mangas.append(contentsOf: cachedManaga)
            _ = refreshManga()
            completion(cachedManaga, nil)
            return
        }
        
        // load from network
        isLoading = true
        MangaEdenApi.getMangaList(page: currentPage, size: pageSize, sort: mangaSort, categoryNames: categoryNames) { [weak self] (mangalist, error) in
            guard let `self` = self else {return}
            self.mangas.append(contentsOf: mangalist ?? [])
            let refreshedManga = self.refreshManga()
            
            // Only cache if no genres are selected
            if self.selectedCategories.isEmpty {
                MangaCache.saveMangaList(mangaList: refreshedManga, currentPage: self.currentPage, size: self.pageSize, sort: self.mangaSort)
            }
            
            completion(mangalist, error)
            self.isLoading = false
        }
    }
    
    private  func filterManga(_ mangas: [MangaProtocol]) -> [MangaProtocol] {
        return mangas.filter {$0.canPublish()}
    }
}
