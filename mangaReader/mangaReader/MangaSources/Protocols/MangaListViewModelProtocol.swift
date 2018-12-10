//
//  MangaListViewModelProtocol.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/11.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import RxSwift

protocol MangaListViewModelProtocol {
    var sortByRecentUpdate: Bool {get set}
    var isLoading: Bool {get}
    
    var selectedGenres: [String] {get set}
    var selectedGenresLocalized: [String] {get set}
    
    var mangasSignal: Variable<[MangaProtocol]> {get}
    var mangasShowing: [MangaProtocol] {get}
    
    func manga(atIndex index: Int) -> MangaProtocol?
    func loadFirstPage(completion: @escaping ([MangaProtocol]?, Error?) -> Void)
    func loadNextPage(completion: @escaping ([MangaProtocol]?, Error?) -> Void)
    func clearManga()
}

class BaseMangaDetailViewModel: MangaDetailViewModelProtocol {
    
    var manga: MangaProtocol
    
    var mangaId: String? {
        get {
            return manga.mangaId
        }
        set {
            manga.mangaId = newValue
        }
    }
    
    init(mangaId: String, manga: MangaProtocol) {
        self.manga = manga
        self.manga.mangaId = mangaId
    }
    
    var currentChapterID: String?
    
    var chaptersContentOffset: CGPoint = CGPoint.zero
    
    func getManga(completion: @escaping (MangaProtocol?, Error?) -> Void) {
        fatalError("should be override by subclass")
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

extension BaseMangaDetailViewModel {
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
