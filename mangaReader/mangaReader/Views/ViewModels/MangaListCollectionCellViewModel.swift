//
//  MangaListCollectionCellViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/7.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class MangaListCollectionCellViewModel {
    private var manga: Manga
    
    init(manga: Manga) {
        self.manga = manga
    }
    
    init (recentManga: RecentManga) {
        manga = Manga()
        manga.title = recentManga.name
        manga.imageURL = recentManga.imagePath
    }
    
    init(favoriteManga: FavoriteManga) {
        manga = Manga()
        manga.title = favoriteManga.name
        manga.imageURL = favoriteManga.imagePath
    }
    
    var title: String? {
        return manga.title
    }
    
    var placeHolderImage: UIImage? {
        return UIImage(named: ImageConstant.placeHolder.rawValue)
    }
    
    var imageURL: URL? {
        guard let imageURL = manga.imagePath else { return nil }
        return URL(string: imageURL)
    }
}
