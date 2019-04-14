//
//  EdenMangaDetailViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/7.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class EdenMangaDetailViewModel: BaseMangaDetailViewModel {

    override var source: MangaSource {
        return .mangaEden
    }
    
    init(mangaId: String = "") {
        super.init(mangaId: mangaId, manga: Manga())
    }

    override func getManga(completion: @escaping (MangaProtocol?, Error?) -> Void) {
        guard let mangaId = manga.mangaId else {return}
        MangaEdenApi.getMangaDetail(mangaIds: [mangaId], completion: { [weak self] (response, error) in
            guard let manga = response?.mangalist?.first else {
                completion(nil, error)
                return
            }
            
            self?.manga = manga
            completion(manga, error)
        })
    }
}
