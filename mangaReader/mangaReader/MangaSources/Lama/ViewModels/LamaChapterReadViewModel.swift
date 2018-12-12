//
//  LamaChapterReadViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/12.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import AlamofireImage

class LamaChapterReadViewModel: BaseChapterReadViewModel {
    
    override func getChapterDetail(completion: @escaping (ChapterDetailProtocol?, Error?) -> Void) {
        guard let chapterIdString = chapterObject?.chapterId
            , let chapterId = Int(chapterIdString) else {
                return
        }
        
        LamaApi.getChapter(id: chapterId) { [weak self] (chapterResonse, error) in
            self?.chapterDetail = chapterResonse?.data
            completion(chapterResonse?.data, error)
        }
    }
    
    override func downloadImages() {
        
        cancelDownload()
        chapterDetail?.chapterImages?.forEach({ (imagePath) in
            downloadImage(imagePath)
        })
    }
}