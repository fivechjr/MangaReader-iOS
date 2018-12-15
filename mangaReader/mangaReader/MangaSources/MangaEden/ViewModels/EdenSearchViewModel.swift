//
//  EdenSearchViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 12/15/18.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class EdenSearchViewModel: BaseSearchViewModel {
    override func searchManga(withKeyword keyword: String?, completion: @escaping ([MangaProtocol]?, Error?) -> Void) {
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
    
    override func filterManga(_ mangas: [MangaProtocol]) -> [MangaProtocol] {
        return mangas.filter {$0.canPublish()}
    }
}
