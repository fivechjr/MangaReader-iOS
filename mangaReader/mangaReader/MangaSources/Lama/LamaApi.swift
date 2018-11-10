//
//  LamaApi.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/10.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class LamaApi {
    
typealias DailyResponseHandler = (LamaDailyResponse?, Error?) -> Void
    
    static func getDaily(tag: Int, offset: Int, limit: Int, completion:@escaping DailyResponseHandler) {
        let path = LamaEndpoint.daily(tag: tag, offset: offset, limit: limit).path
        NetworkManager.get(urlString: path, responseType: LamaDailyResponse.self, completion: completion)
    }
}
