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
        fatalError("should be implemented by subclass")
    }
}
