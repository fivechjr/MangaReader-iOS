//
//  EdenDownloadManager.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/28.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class EdenDownloadManager: DownloadManager {
    override func download(chapters: [ChapterProtocol], completion: (Bool) -> Void) {
        
    }
    
    override func download(chapterDetail: ChapterDetailProtocol?) {
        chapterDetail?.chapterImages?.forEach({ (imagePath) in
            downloadImage(MangaEdenApi.getImageUrl(withImagePath: imagePath))
        })
    }
}
