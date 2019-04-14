//
//  RealEdenSearchViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2019/4/14.
//  Copyright © 2019 Yiming Dong. All rights reserved.
//

import Foundation

class RealEdenSearchViewModel: BaseSearchViewModel {
    override func searchManga(withKeyword keyword: String?, completion: @escaping ([MangaProtocol]?, Error?) -> Void) {
        guard let keyword = keyword else {return}
        
        self.mangas = DataManager.shared
            .getAllCachedManga(sort: .hits)
            .filter {$0.canPublish()}
            .filter { (manga) -> Bool in
                if manga.mangaName?.contains(keyword) ?? false {
                    return true
                }
                // Author is not available in manga list
//                else if manga.mangaAuthor?.contains(keyword) ?? false {
//                    return true
//                }
                
                return false
            }
        
        if MemoryCache.shared.limitedFunction {
            if self.mangas.count > 3 {
                let slice = mangas[0..<3]
                self.mangas = []
                self.mangas.append(contentsOf: Array(slice))
            }
        }
        
        mangasSignal.value = self.mangas
        completion(self.mangasShowing, nil)
    }
}
