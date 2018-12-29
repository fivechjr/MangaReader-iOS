//
//  BaseChapterReadViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/12.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import Kingfisher

class BaseChapterReadViewModel {
    
    // MARK: download
    private var downloadManager: DownloadManager {
        return DownloadManager.shared
    }
    
    func cancelDownload() {
       downloadManager.cancelDownload()
    }
    
    func downloadImages() {
        downloadManager.cancelDownload()
        downloadManager.download(manga: manga, chapterDetail: chapterDetail)
    }
    
    //
    var chapterObject: ChapterProtocol?
    var manga: MangaProtocol?
    
    var currentPageIndex: Int = 0
    
    var chapterDetail: ChapterDetailProtocol?
    
    var chapterName: String {
        let name = chapterObject?.chapterTitle ?? chapterObject?.chapterId ?? ""
        return "\(LocalizedString("Chapter")) - '\(name)'"
    }
    
    var pageInfoText: String? {
        return "\(currentPageIndex + 1)/\(chapterDetail?.chapterImages?.count ?? 0)"
    }
    
    var nextChapterButtonHidden: Bool {
        guard let chapterIndex = getCurrentChapterIndex(), chapterIndex > 0 else {
            return true
        }
        
        return false
    }
    
    var prevChapterButtonHidden: Bool {
        guard let chapterCount = manga?.chapterObjects?.count,
            let chapterIndex = getCurrentChapterIndex(),
            chapterIndex < chapterCount - 1 else {
                return true
        }
        
        return false
    }
    
    func getChapterDetail(completion: @escaping (ChapterDetailProtocol?, Error?) -> Void) {
        fatalError("should be overrided by subclass")
    }
    
    func recordCurrentChapter() {
        guard let chapterId = chapterObject?.chapterId, let mangaId = manga?.mangaId else {return}
        DataManager.shared.recordCurrentChapter(chapterId: chapterId, mangaId: mangaId)
    }
    
    func getCurrentChapterIndex() -> Int? {
        
        guard let chapterObjects = manga?.chapterObjects, let currentId = chapterObject?.chapterId else {
            return nil
        }
        
        for (index, chapter) in chapterObjects.enumerated() {
            if let id = chapter.chapterId, id == currentId {
                return index
            }
        }
        
        return nil;
    }
    
    func chapter(next: Bool) -> ChapterProtocol? {
        guard var index = getCurrentChapterIndex()
            , let chapterObjects = manga?.chapterObjects else {
                return nil
        }
        
        // next is the earlier chapter, so -1
        index = next ? index - 1 : index + 1
        if (index >= 0 && index < chapterObjects.count) {
            return chapterObjects[index]
        }
        
        return nil
    }
    
    var isTheLastChapter: Bool {
        return chapter(next: true) == nil
    }
    
    var isTheFirstChapter: Bool {
        return chapter(next: false) == nil
    }
    
    func goToChapter(next: Bool, completion: @escaping () -> Void) {
        guard let chapter = chapter(next: next) else {return}
        chapterObject = chapter
        completion()
    }
}

