//
//  MangaListResponse.swift
//  mangaReader
//
//  Created by Yiming Dong on 16/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class MangaListResponse: Codable {
    var result: Int?
    var total: Int?
    var mangalist: [Manga]?
}
