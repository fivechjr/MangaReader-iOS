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
    
    /// get chapter by id
    func getChapter(withID chapterID: String?) ->Chapter? {
        guard let chapterID = chapterID, let chapterObjects = manga.chapterObjects else {
            return nil
        }
        
        var theChapter: Chapter? = nil
        
        for (_, chapter) in chapterObjects.enumerated() {
            if let id = chapter.id, id == chapterID {
                theChapter = chapter
                break
            }
        }
        
        return theChapter
    }
    
    /// get chapter index by id
    func getChapterIndex(withID chapterID: String?) ->Int? {
        guard let chapterID = chapterID, let chapterObjects = manga.chapterObjects else {
            return nil
        }
        
        var theChapterIndex: Int? = nil
        
        for (index, chapter) in chapterObjects.enumerated() {
            if let id = chapter.id, id == chapterID {
                theChapterIndex = index
                break
            }
        }
        
        return theChapterIndex
    }
}

extension MangaDetailViewModel {
    func recordRecentManga() {
        DataManager.shared.recordRecentManga(manga: manga)
    }
    
    func getCurrentChapterID() {
        currentChapterID = DataManager.shared.getCurrentChapter(mangaId: manga.id)?.chapterID
    }
    
    func recordCurrentChapter(chapterId: String?) {
        DataManager.shared.recordCurrentChapter(chapterId: chapterId, mangaId: manga.id)
        currentChapterID = chapterId
    }
    
    var isFavorite: Bool {
        return DataManager.shared.isFavorite(mangaId: manga.id)
    }
    
    func addFavorite() {
        DataManager.shared.addFavorite(manga: manga)
    }
}
