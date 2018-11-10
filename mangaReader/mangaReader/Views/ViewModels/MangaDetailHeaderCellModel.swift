//
//  MangaDetailHeaderCellModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/7.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class MangaDetailHeaderCellModel {
    var manga: Manga
    var currentChapterId: String?
    var isFavorite: Bool
    
    init (manga: Manga, currentChapterId: String?, isFavorite: Bool) {
        self.manga = manga
        self.currentChapterId = currentChapterId
        self.isFavorite = isFavorite
    }
    
    var bookTitle: String? {
        return manga.title
    }
    
    var authorName: String? {
        return manga.author
    }
    
    var statusText: String {
        return manga.isCompleted ? LocalizedString("Completed") : LocalizedString("Ongoing")
    }
    
    var imagePath: String? {
        return manga.imagePath
    }
    
    var startButtonText: String {
        guard let _ = currentChapterId else {
            return LocalizedString("Start Reading")
        }
        return LocalizedString("Continue Reading")
    }
    
    var chapterCountText: String {
        guard let chapterCount = manga.chapters?.count, chapterCount > 0 else {return LocalizedString("No Chapters")}
        if chapterCount == 1 {
            return "1 " + LocalizedString("Chapter")
        } else {
            return "\(chapterCount) " + LocalizedString("Chapters")
        }
    }
    
    var placeHolderImage: UIImage? {
        return UIImage(named: ImageConstant.placeHolder.rawValue)
    }
}
