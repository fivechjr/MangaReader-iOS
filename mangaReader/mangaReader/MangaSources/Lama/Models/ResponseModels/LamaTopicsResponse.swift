//
//  LamaTopicsResponse.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/12.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class LamaTopicsResponse: Codable {
    var code: Int?
    var message: String?
    var data: Data?
    
    class Data: Codable {
        var topics:[LamaTopic]?
    }
}
