//
//  ChapterReadViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/8.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import AlamofireImage

class EdenChapterReadViewModel: BaseChapterReadViewModel {
    
    override func getChapterDetail(completion: @escaping (ChapterDetailProtocol?, Error?) -> Void) {
        guard let mangaId = manga?.mangaId, let chapterId = chapterObject?.chapterId else {return}
        
        MangaEdenApi.getChapterDetail(mangaId: mangaId, chapterId: chapterId) { [weak self] (chapterDetailResponse, error) in
            self?.chapterDetail = chapterDetailResponse?.chapter
            completion(chapterDetailResponse?.chapter, error)
        }
    }
    
    override func downloadImages() {
        
        cancelDownload()
        chapterDetail?.chapterImages?.forEach({ (imagePath) in
            downloadImage(MangaEdenApi.getImageUrl(withImagePath: imagePath))
        })
    }
}
