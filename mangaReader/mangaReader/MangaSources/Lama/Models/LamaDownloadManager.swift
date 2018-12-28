//
//  LamaDownloadManager.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/28.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class LamaDownloadManager: DownloadManager {
    
    override func download(mangaId: String?, chapterDetail: ChapterDetailProtocol?) {
        chapterDetail?.chapterImages?.forEach({ (imagePath) in
            downloadImage(imagePath)
        })
    }
    
    override func download(mangaId: String?, chapters: [ChapterProtocol]?) {
        guard let chapters = chapters, !chapters.isEmpty else {
            return
        }
        
        chapters.forEach { (chapter) in
            getChapterDetail(chapter: chapter, completion: { [weak self] (detail, error) in
                guard let detail = detail else {return}
                
                self?.download(mangaId: mangaId, chapterDetail: detail)
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
            completion(chapterResonse?.data, error)
        }
    }
}
