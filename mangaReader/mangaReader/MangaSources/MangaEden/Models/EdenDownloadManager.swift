//
//  EdenDownloadManager.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/28.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class EdenDownloadManager: DownloadManager {
    override func download(manga: MangaProtocol?, chapters: [ChapterProtocol]?) {
        guard let manga = manga, let mangaId = manga.mangaId, let chapters = chapters, !chapters.isEmpty else {
            return
        }
        
        DataManager.shared.addDownloadManga(manga: manga)
        
        chapters.forEach { (chapter) in
            getChapterDetail(mangaId: mangaId, chapter: chapter, completion: { [weak self] (detail, error) in
                guard let detail = detail else {return}
                
                DataManager.shared.addDownloadChapeter(chapterDetail: detail, mangaId: mangaId)
                
                self?.download(manga: manga, chapterDetail: detail)
            })
        }
    }
    
    override func download(manga: MangaProtocol?, chapterDetail: ChapterDetailProtocol?) {
        guard let chapterId = chapterDetail?.chapterId else {return}
        
        chapterDetail?.chapterImages?.forEach({ (imagePath) in
            downloadImage(MangaEdenApi.getImageUrl(withImagePath: imagePath), completion: { [weak self] (success) in
                
                let downloaded = self?.downloadedPageCount(chapterDetail) ?? 0
                DataManager.shared.updateDownloadChapter(chapterId, downloaded: downloaded)
                
                print("update downloaded page of chapter - \(downloaded) / \(chapterDetail?.chapterImages?.count ?? 0)")
                if DataManager.shared.isDownloaded(chapterId) {
                    self?.downloadedChaptersSignal.value.insert(chapterId)
                }
            })
        })
    }
    
    private func getChapterDetail(mangaId: String?, chapter: ChapterProtocol?, completion: @escaping (ChapterDetailProtocol?, Error?) -> Void) {
        guard let mangaId = mangaId, let chapterId = chapter?.chapterId else {
            completion(nil, NSError.generic)
            return
        }

        MangaEdenApi.getChapterDetail(mangaId: mangaId, chapterId: chapterId) { (chapterDetailResponse, error) in
            completion(chapterDetailResponse?.chapter, error)
        }
    }
}
