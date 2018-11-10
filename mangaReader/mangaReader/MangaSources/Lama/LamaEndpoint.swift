//
//  LamaEndpoint.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/10.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

enum LamaEndpoint {
    case daily(tag: Int, offset: Int, limit: Int)
    
    var baseUrl: String {
        return "http://api.lamamanhua.com/"
    }
    
    var path:String {
        switch self {
        case .daily(let tag, let offset, let limit):
            return baseUrl + "v2/daily/\(tag)?offset=\(offset)&limit=\(limit)"
        }
    }
}
