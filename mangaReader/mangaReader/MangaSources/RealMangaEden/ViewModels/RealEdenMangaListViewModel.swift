//
//  RealEdenMangaListViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2019/4/13.
//  Copyright © 2019 Yiming Dong. All rights reserved.
//

import Foundation
import RxSwift

class RealEdenMangaListViewModel: MangaListViewModelProtocol {
    var source: MangaSource {
        return .mangaEdenReal
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
    private let pageSize: Int = Constants.pageSize
    
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

extension RealEdenMangaListViewModel {
    
    private func loadAllManga() {
        // TODO: only trigger once a week
        RealMangaEdenApi.getAllMangaList(onProgress: { progress in
            print("progress: \(progress)")
        }) { (mangaListResponse, error) in
            // TODO
            print("got all manga, saving to database...")
            if let mangaList = mangaListResponse?.manga {
                DataManager.shared.cacheMangaList(mangaList, completion: {
                    print("cache done")
                    
                    print("\(Date())")
                    let mangaList = DataManager.shared.getAllCachedManga(sort: .last_chapter_date)
                    print("\(Date())")
                    print("read from realm")
                })
            }
        }
    }
    
    private func loadManga(page: Int, completion: @escaping ([MangaProtocol]?, Error?) -> Void) {
        
        loadAllManga()
        
        guard !isLoading else {
            completion(nil, nil)
            return
        }
        
        currentPage = page
        
        if MemoryCache.shared.limitedFunction && currentPage > 2 {
            currentPage = 2
        }
        
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
        RealMangaEdenApi.getMangaList(pageNumber: currentPage) { [weak self] (mangaList, error) in
            guard let `self` = self else {return}
            
            self.mangas.append(contentsOf: mangaList ?? [])
            
            let refreshedManga = self.refreshManga()
            
            // Only cache if no genres are selected
            if self.selectedCategories.isEmpty {
                MangaCache.saveMangaList(mangaList: refreshedManga, currentPage: self.currentPage, size: self.pageSize, sort: self.mangaSort)
            }
            
            completion(mangaList, error)
            self.isLoading = false
        }
    }
    
    private  func filterManga(_ mangas: [MangaProtocol]) -> [MangaProtocol] {
        return mangas.filter {$0.canPublish()}
    }
}

