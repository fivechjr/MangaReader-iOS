//
//  LamaDownloadManager.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/28.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class LamaDownloadManager: DownloadManager {
    
    override func download(manga: MangaProtocol?, chapterDetail: ChapterDetailProtocol?) {
        guard let chapterId = chapterDetail?.chapterId else {return}
        
        DataManager.shared.addDownloadChapeter(chapterDetail: chapterDetail, mangaId: manga?.mangaId)
        
        chapterDetail?.chapterImages?.forEach({ (imagePath) in
            downloadImage(imagePath, completion: { [weak self] (success) in
                
                let downloaded = self?.downloadedPageCount(chapterDetail) ?? 0
                DataManager.shared.updateDownloadChapter(chapterId, downloaded: downloaded)
                
                print("update downloaded page of chapter - \(downloaded) / \(chapterDetail?.chapterImages?.count ?? 0)")
                if DataManager.shared.isDownloaded(chapterId) {
                    self?.downloadedChaptersSignal.value.insert(chapterId)
                }
            })
        })
    }
    
    override func download(manga: MangaProtocol?, chapters: [ChapterProtocol]?) {
        guard let manga = manga, let chapters = chapters, !chapters.isEmpty else {
            return
        }
        
        DataManager.shared.addDownloadManga(manga: manga)
        
        chapters.forEach { (chapter) in
            getChapterDetail(chapter: chapter, completion: { [weak self] (detail, error) in
                guard let detail = detail else {return}
                
                self?.download(manga: manga, chapterDetail: detail)
            })
        }
    }
    
    private func getChapterDetail(chapter: ChapterProtocol?, completion: @escaping (ChapterDetailProtocol?, Error?) -> Void) {
        guard let chapterIdString = chapter?.chapterId
            , let chapterId = Int(chapterIdString) else {
                completion(nil, NSError.generic)
                return
        }
        
        LamaApi.getChapter(id: chapterId) { (chapterResonse, error) in
            chapterResonse?.data?.chapterId = chapter?.chapterId
            completion(chapterResonse?.data, error)
        }
    }
}
