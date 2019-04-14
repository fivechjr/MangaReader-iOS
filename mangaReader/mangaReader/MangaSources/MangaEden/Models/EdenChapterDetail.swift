//
//  EdenChapterDetail.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/9.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class EdenChapterDetail: Codable, Equatable {
    
    var _id: String?
    private var chapterid: String?
    var mangaedenid: String?
    var url: String?
    
    var images:[[CodableValue?]]?
    
    private var _imageObjets:[ChapterImage]?
    private var imageObjets:[ChapterImage]? {
        if _imageObjets == nil {
            _imageObjets = images?.map {ChapterImage(datas: $0)}
        }
        return _imageObjets
    }
    
    
    // MARK: Equation
    func isEqual(to other: EdenChapterDetail?) -> Bool {
        guard let other = other else {return false}
        
        return self == other
    }
    
    static func == (lhs: EdenChapterDetail, rhs: EdenChapterDetail) -> Bool {
        guard let id1 = lhs._id, let id2 = lhs._id else {
            return lhs === rhs
        }
        
        return id1 == id2
    }
}

extension EdenChapterDetail: ChapterDetailProtocol {
    var chapterId: String? {
        get {
            return chapterid
        }
        set {
            chapterid = newValue
        }
    }
    
    var chapterImages: [String]? {
        get {
            let images = imageObjets?.compactMap({MangaEdenApi.getImageUrl(withImagePath: $0.imagePath)})
            // this is because the api returns in the reversed order, so we reverse it back
            return images?.reversed()
        }
    }
}
