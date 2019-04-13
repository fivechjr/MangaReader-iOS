//
//  RealEdenDownloadManager.swift
//  mangaReader
//
//  Created by Yiming Dong on 2019/4/13.
//  Copyright © 2019 Yiming Dong. All rights reserved.
//

import Foundation

class RealEdenDownloadManager: DownloadManager {
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
    
    private func getChapterDetail(chapter: ChapterProtocol?, completion: @escaping (ChapterDetailProtocol?, Error?) -> Void) {
        guard let chapterId = chapter?.chapterId else {
            completion(nil, NSError.generic)
            return
        }
        
        RealMangaEdenApi.getChapterDetail(chapterId: chapterId) { (chapterDetailResponse, error) in
            completion(chapterDetailResponse, error)
        }
    }
}
