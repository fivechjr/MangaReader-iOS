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
    
    private var lastUpdateDate: Date?
    
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
        loadAllManga(completion: completion)
//        loadManga(page: 0, completion: completion)
    }
    
    func loadNextPage(completion: @escaping ([MangaProtocol]?, Error?) -> Void) {
//        loadManga(page: currentPage + 1, completion: completion)
    }
    
//    private func refreshManga() -> [MangaProtocol] {
//        let refreshedManga = filterManga(mangas)
//        mangasSignal.value = refreshedManga
//
//        return refreshedManga
//    }
    
    func clearManga() {
        mangas = []
        mangasSignal.value = []
    }
}

extension RealEdenMangaListViewModel {
    
    private func initMangaFromJson(completion: @escaping ([MangaProtocol]?, Error?) -> Void) {
        if let url = Bundle.main.url(forResource: "all_manga_list_en", withExtension: "json") {
            if let mangaData = try? Data(contentsOf: url) {
                let mangaResponse = try? JSONDecoder().decode(RealMangaEdenListResponse.self, from: mangaData)
                let mangaList = mangaResponse?.manga?.sorted(by: { (manga1, manga2) -> Bool in
                    if mangaSort == .hits {
                        return manga1.hits ?? 0 > manga2.hits ?? 0
                    } else {
                        return manga1.lastChapterDate ?? 0 > manga2.lastChapterDate ?? 0
                    }
                })
                
                processManga(mangaList, completion: completion)
            }
        }
    }
    
    private func saveMangaToDB(_ mangaList: [MangaProtocol], completion: @escaping ([MangaProtocol]?, Error?) -> Void) {
        DataManager.shared.cacheMangaList(mangaList, completion: {
            print("all manga has been cached!")
            self.processManga(self.allMangaFromCache(), completion: completion)
        })
    }
    
    private func processManga(_ mangaList: [MangaProtocol]?, completion: @escaping ([MangaProtocol]?, Error?) -> Void) {
        self.mangas = mangaList ?? []
        DispatchQueue.global(qos: .utility).async {
            let refreshedManga = self.filterManga(self.mangas)
            DispatchQueue.main.async {
                self.mangasSignal.value = refreshedManga
                completion(self.mangasShowing, nil)
            }
        }
    }
    
    
    private func timeToUpdateMangaList() -> Bool {
        // TODO: only trigger once a week
        if let lastUpdateDate = lastUpdateDate {
            return Date().timeIntervalSince(lastUpdateDate) > 604800 // 3600*24*7
        }
        return true
    }
    
    private func loadAllManga(completion: @escaping ([MangaProtocol]?, Error?) -> Void) {
        
        guard !isLoading else {
            completion(nil, nil)
            return
        }
        
        var shouldUpdateCache = false
        
        let cachedManga = allMangaFromCache()
        if cachedManga.isEmpty {
            initMangaFromJson { (mangaList, error) in
                completion(mangaList, error)
            }
            shouldUpdateCache = true
        } else if timeToUpdateMangaList() {
            processManga(cachedManga, completion: completion)
            shouldUpdateCache = true
        } else {
            processManga(cachedManga, completion: completion)
        }
        
        if !shouldUpdateCache {return}
        
        isLoading = true
        RealMangaEdenApi.getAllMangaList() { [weak self] (mangaListResponse, error) in
            guard let `self` = self else {return}
            
            if let mangaList = mangaListResponse?.manga {
                self.saveMangaToDB(mangaList, completion: { (response, error) in
                    self.lastUpdateDate = Date()
                    completion(response, error)
                    self.isLoading = false
                })
            } else {
                completion(self.mangasShowing, error)
                self.isLoading = false
            }
        }
    }
    
    private func allMangaFromCache() -> [MangaProtocol] {
        return Array(DataManager.shared.getAllCachedManga(sort: self.mangaSort))
    }
    
    private func loadManga(page: Int, completion: @escaping ([MangaProtocol]?, Error?) -> Void) {
        
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
            processManga(cachedManaga, completion: completion)
            return
        }
        
        // load from network
        isLoading = true
        RealMangaEdenApi.getMangaList(pageNumber: currentPage) { [weak self] (mangaList, error) in
            guard let `self` = self else {return}
            
            self.processManga(mangaList, completion: { (processedManga, error) in
                // Only cache if no genres are selected
                if let processedManga = processedManga, self.selectedCategories.isEmpty {
                    MangaCache.saveMangaList(mangaList: processedManga, currentPage: self.currentPage, size: self.pageSize, sort: self.mangaSort)
                }
                
                completion(processedManga, error)
                self.isLoading = false
            })
        }
    }
    
    private  func filterManga(_ mangas: [MangaProtocol]) -> [MangaProtocol] {
        let mangaList = mangas.filter {$0.canPublish()}.filter { (manga) -> Bool in
            var match = true
            categoryNames.forEach({ (name) in
                if !manga.mangaCategories.contains(name) {
                    match = false
                }
            })
            return match
        }
        
        return mangaList
    }
}

