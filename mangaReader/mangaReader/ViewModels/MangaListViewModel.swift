//
//  MangaListViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/6.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation


class MangaListViewModel {
    var sortByRecentUpdate = false
    
    var mangas:[Manga]?
    
    var mangasFiltered:[Manga]?
    
    var selectedGenres: [String] = []
    var selectedGenresLocalized: [String] = []
    
    func loadMangaData() {
        DataRequester.getMangaList(page: 0, size: 20) { [weak self] (response, error) in
            self?.mangas = response?.mangalist
        }
    }
}
