//
//  RealEdenChapterReadViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2019/4/13.
//  Copyright © 2019 Yiming Dong. All rights reserved.
//

import Foundation
import Kingfisher

class RealEdenChapterReadViewModel: BaseChapterReadViewModel {
    
    override var source: MangaSource {
        return .mangaEdenReal
    }
    
    override func getChapterDetail(completion: @escaping (ChapterDetailProtocol?, Error?) -> Void) {
        guard let chapterId = chapterObject?.chapterId else {
            completion(nil, NSError.generic)
            return
        }
        
        RealMangaEdenApi.getChapterDetail(chapterId: chapterId) { [weak self] (chapterDetailResponse, error) in
            self?.chapterDetail = chapterDetailResponse
            completion(chapterDetailResponse, error)
        }
    }
}
