//
//  MangaListCollectionCellViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/7.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class MangaListCollectionCellViewModel {
    private var manga: MangaProtocol
    
    init(manga: MangaProtocol) {
        self.manga = manga
    }
    
    var title: String? {
        return manga.mangaName
    }
    
    var placeHolderImage: UIImage? {
        return ImageConstant.placeHolder.image
    }
    
    var imageURL: URL? {
        guard let imageURL = manga.coverImageUrl else { return nil }
        return URL(string: imageURL)
    }
}
