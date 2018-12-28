//
//  MangaDownloadViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/28.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class MangaDownloadViewModel {
    var manga: MangaProtocol
    private(set) var selectedChapters = [ChapterProtocol]()
    private let downloadManager = FSInjector.shared.resolve(DownloadManager.self)
    
    init(manga: MangaProtocol) {
        self.manga = manga
    }
    
    func startDownload(completion: (Bool) -> Void) {
        downloadManager?.download(chapters: selectedChapters, completion: { (completed) in
            completion(completed)
        })
    }
    
    func chapter(at index: Int) -> ChapterProtocol? {
        guard let chapterObjects = manga.chapterObjects, index < chapterObjects.count else {return nil}
        
        return chapterObjects[index]
    }
    
    func isSelected(chapter: ChapterProtocol?) -> Bool {
        guard let chapter = chapter else {return false}
        return selectedChapters.contains(where: {$0.chapterId == chapter.chapterId})
    }
    
    func isSelected(at index: Int) -> Bool {
        guard let chapter = chapter(at: index) else {return false}
        return selectedChapters.contains(where: {$0.chapterId == chapter.chapterId})
    }
    
    func didSelect(at index: Int) {
        guard let selectedChapter = chapter(at: index) else {return}
        if let foundIndex = selectedChapters.firstIndex(where: {$0.chapterId == selectedChapter.chapterId}) {
            selectedChapters.remove(at: foundIndex)
        } else {
            selectedChapters.append(selectedChapter)
        }
    }
}
