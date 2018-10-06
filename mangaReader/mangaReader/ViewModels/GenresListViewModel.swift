//
//  GenresListViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/7.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class GenresListViewModel {
    var genres: [String] {
        return DataManager.shared.categories
    }
    
    func title(atIndex index: Int) -> String? {
        guard index < genres.count else {return nil}
        return LocalizedString(genres[index])
    }
    
    func genre(atIndex index: Int) -> String? {
        guard index < genres.count else {return nil}
        return genres[index]
    }
}
