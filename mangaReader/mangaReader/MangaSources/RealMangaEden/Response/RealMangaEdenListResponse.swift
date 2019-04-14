//
//  RealMangaEdenListResponse.swift
//  mangaReader
//
//  Created by Yiming Dong on 2019/4/13.
//  Copyright © 2019 Yiming Dong. All rights reserved.
//

import Foundation

class RealMangaEdenListResponse: Codable {
    var page: Int?
    var start: Int?
    var end: Int?
    var manga: [RealMangaEdenManga]?
}
