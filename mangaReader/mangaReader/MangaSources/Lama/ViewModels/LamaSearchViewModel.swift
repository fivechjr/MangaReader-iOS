//
//  LamaSearchViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 12/15/18.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class LamaSearchViewModel: BaseSearchViewModel {
    override func searchManga(withKeyword keyword: String?, completion: @escaping ([MangaProtocol]?, Error?) -> Void) {
        guard let keyword = keyword else {return}
        
        if currentPage <= 0 {
            currentPage = 0
            mangas.removeAll()
        }
        
        // XXX: Lama Api does not support offset for now
        LamaApi.search(keyword: keyword, offset: 0, limit: pageSize) { [weak self] (response, error) in
            guard let `self` = self else {return}
            self.mangas.append(contentsOf: response?.data?.topics ?? [])
            self.refreshManga()
            completion(self.mangas, error)
        }
    }
    
    override func filterManga(_ mangas: [MangaProtocol]) -> [MangaProtocol] {
        return mangas
    }
}
