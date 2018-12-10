//
//  LamaMangaDetailViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/10.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class LamaMangaDetailViewModel: MangaDetailViewModelProtocol {
    
    var manga: MangaProtocol
    
    init(mangaId: String) {
        manga = LamaTopic()
        manga.mangaId = mangaId
    }
    
    var currentChapterID: String?
    
    var chaptersContentOffset: CGPoint = CGPoint.zero
    
    func getManga(completion: @escaping (MangaProtocol?, Error?) -> Void) {
        guard let mangaId = manga.mangaId, let idInt = Int(mangaId) else {return}
        LamaApi.getTopic(id: idInt) { [weak self] (response, error) in
            guard let manga = response?.data else {
                completion(nil, error)
                return
            }
            
            self?.manga = manga
            completion(manga, error)
        }
    }
    
    func getChapter(withID chapterID: String?, completion: (ChapterProtocol?, Error?) -> Void) {
        guard let chapterID = chapterID, let chapterObjects = manga.chapterObjects else {
            completion(nil, nil)
            return
        }
        
        var theChapter: ChapterProtocol? = nil
        
        for (_, chapter) in chapterObjects.enumerated() {
            if let id = chapter.chapterId, id == chapterID {
                theChapter = chapter
                break
            }
        }
        
        completion(theChapter, nil)
    }
    
    func getChapterIndex(withID chapterID: String?) -> Int? {
        guard let chapterID = chapterID, let chapterObjects = manga.chapterObjects else {
            return nil
        }
        
        var theChapterIndex: Int? = nil
        
        for (index, chapter) in chapterObjects.enumerated() {
            if let id = chapter.chapterId, id == chapterID {
                theChapterIndex = index
                break
            }
        }
        
        return theChapterIndex
    }
    
}

extension LamaMangaDetailViewModel {
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
