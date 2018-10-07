//
//  MangaDetailViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/7.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class MangaDetailViewModel {
    var manga: Manga
    
    init(manga: Manga) {
        self.manga = manga
    }
    
    var currentChapterID: String?
    
    var chaptersContentOffset: CGPoint = CGPoint.zero
}
