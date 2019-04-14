//
//  LamaMangaDetailViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/10.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class LamaMangaDetailViewModel: BaseMangaDetailViewModel {
    
    override var source: MangaSource {
        return .lama
    }
    
    init(mangaId: String = "") {
        super.init(mangaId: mangaId, manga: LamaTopic())
    }
    
    override func getManga(completion: @escaping (MangaProtocol?, Error?) -> Void) {
        guard let mangaId = manga.mangaId, let idInt = Int(mangaId) else {return}
        LamaApi.getTopic(id: idInt) { [weak self] (response, error) in
            guard let manga = response?.data else {
                completion(nil, error)
                return
            }
            
            self?.manga = manga
            completion(manga, error)
        }
    }
}
