//
//  LamaChapterResponse.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/9.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class LamaChapterResponse: Codable {
    var code: Int?
    var message: String?
    var data: LamaChapter?
}
