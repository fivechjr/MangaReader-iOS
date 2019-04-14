//
//  LamaSearchResponse.swift
//  mangaReader
//
//  Created by Yiming Dong on 12/15/18.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class LamaSearchResponse: Codable {
    var code: Int?
    var message: String?
    var data: LamaSearchData?
}

class LamaSearchData: Codable {
    var limit: String?
    var offset: String?
    var total: String?
    var topics: [LamaTopic]?
}
