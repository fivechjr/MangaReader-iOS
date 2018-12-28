//
//  EdenDownloadManager.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/28.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class EdenDownloadManager: DownloadManager {
    override func download(mangaId: String?, chapters: [ChapterProtocol]?) {
        guard let mangaId = mangaId, let chapters = chapters, !chapters.isEmpty else {
            return
        }
        
        chapters.forEach { (chapter) in
            getChapterDetail(mangaId: mangaId, chapter: chapter, completion: { [weak self] (detail, error) in
                guard let detail = detail else {return}
                
                self?.download(mangaId: mangaId, chapterDetail: detail)
            })
        }
    }
    
    override func download(mangaId: String?, chapterDetail: ChapterDetailProtocol?) {
        chapterDetail?.chapterImages?.forEach({ (imagePath) in
            downloadImage(MangaEdenApi.getImageUrl(withImagePath: imagePath))
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
