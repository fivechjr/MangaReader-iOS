//
//  FavoritesViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/16.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import RealmSwift

class FavoritesViewModel {
    var favoriteManga: Results<FavoriteManga>?
    
    func loadFavorites() {
        favoriteManga = DataManager.shared.getAllFavorites()
    }
    
    func deleteFavorite(mangaId: String?) {
        guard let mangaId = mangaId else {return}
        DataManager.shared.deleteFavorite(mangaId: mangaId)
    }
    
    var count: Int {
        return favoriteManga?.count ?? 0
    }
    
    subscript(index: Int) -> FavoriteManga? {
        guard let favorites = favoriteManga, index >= 0, index < favorites.count else {
            return nil
        }
        
        return favorites[index]
    }
}
