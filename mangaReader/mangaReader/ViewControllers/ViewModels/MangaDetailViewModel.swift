//
//  MangaDetailViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/7.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class MangaDetailViewModel: MangaDetailViewModelProtocol {
    
    var manga: MangaProtocol
    
    init(mangaId: String) {
        manga = Manga()
        manga.mangaId = mangaId
    }
    
    var currentChapterID: String?
    
    var chaptersContentOffset: CGPoint = CGPoint.zero
    
    func getManga(completion: @escaping (MangaProtocol?, Error?) -> Void) {
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
    
    /// get chapter by id
    func getChapter(withID chapterID: String?) -> ChapterProtocol? {
        guard let chapterID = chapterID, let chapterObjects = manga.chapterObjects else {
            return nil
        }
        
        var theChapter: ChapterProtocol? = nil
        
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
        currentChapterID = DataManager.shared.getCurrentChapter(mangaId: manga.mangaId)?.chapterID
    }
    
    func recordCurrentChapter(chapterId: String?) {
        DataManager.shared.recordCurrentChapter(chapterId: chapterId, mangaId: manga.mangaId)
        currentChapterID = chapterId
    }
    
    var isFavorite: Bool {
        return DataManager.shared.isFavorite(mangaId: manga.mangaId)
    }
    
    func addFavorite() {
        DataManager.shared.addFavorite(manga: manga)
    }
}
