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
    case topics(tag: Int, offset: Int, limit: Int)
    case topic(id: Int, sort: Int)
    case chapter(id: Int)
    case search(keyword: String, offset: Int, limit: Int)
    
    var baseUrl: String {
        return "http://api.lamamanhua.com/"
    }
    
    var path:String {
        switch self {
        case .daily(let tag, let offset, let limit):
            return baseUrl + "v2/daily/\(tag)?offset=\(offset)&limit=\(limit)"
        case .topics(let tag, let offset, let limit):
            return baseUrl + "v2/topics?offset=\(offset)&limit=\(limit)&tagid=\(tag)"
        case .topic(let id, let sort):
            return baseUrl + "v2/topics/\(id)?sort=\(sort)"
        case .chapter(let id):
            return baseUrl + "v2/comics/\(id)"
        case .search(let keyword, let offset, let limit):
            return baseUrl + "v2/topics/search?keyword=\(keyword)&offset=\(offset)&limit=\(limit)"
        }
    }
}
