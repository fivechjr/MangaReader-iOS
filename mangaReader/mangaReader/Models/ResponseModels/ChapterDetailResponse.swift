//
//  ChapterDetailResponse.swift
//  mangaReader
//
//  Created by Yiming Dong on 19/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class ChapterDetailResponse: Codable {
    var result: Int?
    var chapter: ChapterDetail?
}

class ChapterDetail: Codable {
    var _id: String?
    var chapterid: String?
    var mangaedenid: String?
    var url: String?
    
    var images:[[CodableValue?]]?
    var imageObjets:[ChapterImage]? {
        return images?.map {ChapterImage(datas: $0)}
    }
}
