//
//  LamaApi.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/10.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class LamaApi {
    
    static func getTopic(id: Int, ascending: Bool = false, completion:@escaping (LamaTopicResponse?, Error?) -> Void) {
        let path = LamaEndpoint.topic(id: id, sort: ascending ? 1 : 0).path
        NetworkManager.get(urlString: path, responseType: LamaTopicResponse.self, completion: completion)
    }
    
    static func getDaily(tag: Int, offset: Int, limit: Int, completion:@escaping (LamaDailyResponse?, Error?) -> Void) {
        let path = LamaEndpoint.daily(tag: tag, offset: offset, limit: limit).path
        NetworkManager.get(urlString: path, responseType: LamaDailyResponse.self, completion: completion)
    }
    
    static func getTopics(tag: Int, offset: Int, limit: Int, completion:@escaping (LamaTopicsResponse?, Error?) -> Void) {
        let path = LamaEndpoint.topics(tag: tag, offset: offset, limit: limit).path
        NetworkManager.get(urlString: path, responseType: LamaTopicsResponse.self, completion: completion)
    }
}
