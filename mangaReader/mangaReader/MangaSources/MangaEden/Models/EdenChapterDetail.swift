//
//  EdenChapterDetail.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/9.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class EdenChapterDetail: Codable {
    var _id: String?
    var chapterid: String?
    var mangaedenid: String?
    var url: String?
    
    var images:[[CodableValue?]]?
    var imageObjets:[ChapterImage]? {
        return images?.map {ChapterImage(datas: $0)}
    }
    
    func isEqual(to chapter: EdenChapterDetail?) -> Bool {
        guard let chapter = chapter, let id = chapter._id, let thisId = _id else {return false}
        return thisId == id
    }
}
