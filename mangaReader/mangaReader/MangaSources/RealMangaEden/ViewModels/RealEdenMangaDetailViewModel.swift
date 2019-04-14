//
//  RealEdenMangaDetailViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2019/4/13.
//  Copyright © 2019 Yiming Dong. All rights reserved.
//

import Foundation

class RealEdenMangaDetailViewModel: BaseMangaDetailViewModel {
    
    override var source: MangaSource {
        return .mangaEdenReal
    }
    
    init(mangaId: String = "") {
        super.init(mangaId: mangaId, manga: Manga())
    }
    
    override func getManga(completion: @escaping (MangaProtocol?, Error?) -> Void) {
        guard let mangaId = manga.mangaId else {return}
        RealMangaEdenApi.getMangaDetail(mangaId: mangaId, completion: { [weak self] (response, error) in
            guard let manga = response else {
                completion(nil, error)
                return
            }
            
            self?.manga = manga
            completion(manga, error)
        })
    }
}
