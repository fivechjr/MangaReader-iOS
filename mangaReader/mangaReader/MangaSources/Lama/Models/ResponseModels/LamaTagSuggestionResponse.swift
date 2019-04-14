//
//  LamaTagSuggestionResponse.swift
//  mangaReader
//
//  Created by Yiming Dong on 12/18/18.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class LamaTagSuggestionResponse: Codable {
    var code: Int?
    var message: String?
    var data: LamaTagSuggestion?
}

class LamaTagSuggestion: Codable {
    var suggestion: [LamaTag]?
}

class LamaTag: Codable {
    var icon: String?
    var priority: Int?
    var tag_id: Int?
    var title: String?
}
