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

class BaseSearchViewModel: SearchViewModelProtocol {
    private(set) var keyword: String?
    
    var mangasSignal = Variable<[MangaProtocol]>([])
    var mangasShowing: [MangaProtocol] {
        return mangasSignal.value
    }
    
    var mangas:[MangaProtocol] = []
    
    var currentPage: Int = 0
    let pageSize: Int = Constants.pageSize
    
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
    
    func searchManga(withKeyword keyword: String?, completion: @escaping ([MangaProtocol]?, Error?) -> Void) {
        fatalError("should be override")
    }
    
    func filterManga(_ mangas: [MangaProtocol]) -> [MangaProtocol] {
        fatalError("should be ovveride")
    }
}
