//
//  LamaTopicResponse.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/8.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class LamaTopicResponse: Codable {
    var code: Int?
    var message: String?
    var data: LamaTopic?
}
