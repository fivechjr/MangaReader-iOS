//
//  ChapterReadViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/8.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import Kingfisher

class EdenChapterReadViewModel: BaseChapterReadViewModel {
    
    override var source: MangaSource {
        return .mangaEden
    }
    
    override func getChapterDetail(completion: @escaping (ChapterDetailProtocol?, Error?) -> Void) {
        guard let mangaId = manga?.mangaId, let chapterId = chapterObject?.chapterId else {
            completion(nil, NSError.generic)
            return
        }
        
        MangaEdenApi.getChapterDetail(mangaId: mangaId, chapterId: chapterId) { [weak self] (chapterDetailResponse, error) in
            self?.chapterDetail = chapterDetailResponse?.chapter
            completion(chapterDetailResponse?.chapter, error)
        }
    }
}
