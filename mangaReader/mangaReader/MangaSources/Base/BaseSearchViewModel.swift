//
//  SearchViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/7.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchViewModelProtocol {
    func searchManga(withKeyword keyword: String?, completion: @escaping ([MangaProtocol]?, Error?) -> Void)
    func filterManga(_ mangas: [MangaProtocol]) -> [MangaProtocol]
}

class BaseSearchViewModel {
    private(set) var keyword: String?
    
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
    
    func search(_ keyword: String?, completion: @escaping ([MangaProtocol]?, Error?) -> Void) {
        self.keyword = keyword
        currentPage = 0
        searchManga(withKeyword: keyword, completion: completion)
    }
    
    func searchNextPage(completion: @escaping ([MangaProtocol]?, Error?) -> Void) {
        currentPage += 1
        searchManga(withKeyword: keyword, completion: completion)
    }
    
    func refreshManga() {
        mangasSignal.value = filterManga(mangas)
    }
}

extension BaseSearchViewModel: SearchViewModelProtocol {
    
     func searchManga(withKeyword keyword: String?, completion: @escaping ([MangaProtocol]?, Error?) -> Void) {
        guard let keyword = keyword else {return}
        
        if currentPage <= 0 {
            currentPage = 0
            mangas.removeAll()
        }
        
        MangaEdenApi.searchManga(withKeyword: keyword, page: currentPage, size: pageSize, sort: .hits) { [weak self] (response, error) in
            guard let `self` = self else {return}
            self.mangas.append(contentsOf: response?.mangalist ?? [])
            self.refreshManga()
            completion(self.mangas, error)
        }
    }
    
    func filterManga(_ mangas: [MangaProtocol]) -> [MangaProtocol] {
        return mangas.filter {$0.canPublish()}
    }
}
