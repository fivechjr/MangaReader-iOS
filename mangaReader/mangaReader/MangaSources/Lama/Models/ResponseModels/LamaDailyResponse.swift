//
//  LamaDailyResponse.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/10.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class LamaDailyResponse: Codable {
    var code: Int?
    var message: String?
    var data: Data?
    
    class Data: Codable {
        var comics:[LamaComic]?
        var offset: Int?
        var timestamp: Int?
    }
}
