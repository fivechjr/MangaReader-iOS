//
//  LamaApi.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/10.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class LamaApi {
    
    private static func getDaily(tag: Int, offset: Int, limit: Int, completion:@escaping (LamaDailyResponse?, Error?) -> Void) {
        let path = LamaEndpoint.daily(tag: tag, offset: offset, limit: limit).path
        NetworkManager.get(urlString: path, responseType: LamaDailyResponse.self, completion: completion)
    }
    
    static func getTopics(tag: Int, offset: Int, limit: Int, sort: Int, completion:@escaping (LamaTopicsResponse?, Error?) -> Void) {
        let path = LamaEndpoint.topicsIndex(tag: tag, offset: offset, limit: limit, sort: sort).path
        NetworkManager.get(urlString: path, responseType: LamaTopicsResponse.self, completion: completion)
    }
    
    static func getTopic(id: Int, ascending: Bool = false, completion:@escaping (LamaTopicResponse?, Error?) -> Void) {
        let path = LamaEndpoint.topic(id: id, sort: ascending ? 0 : 1).path
        NetworkManager.get(urlString: path, responseType: LamaTopicResponse.self, completion: completion)
    }
    
    static func getChapter(id: Int, completion:@escaping (LamaChapterResponse?, Error?) -> Void) {
        let path = LamaEndpoint.chapter(id: id).path
        NetworkManager.get(urlString: path, responseType: LamaChapterResponse.self, completion: completion)
    }
    
    static func search(keyword: String, offset: Int, limit: Int, completion:@escaping (LamaSearchResponse?, Error?) -> Void) {
        let path = LamaEndpoint.search(keyword: keyword, offset: offset, limit: limit).path
        NetworkManager.get(urlString: path, responseType: LamaSearchResponse.self, completion: completion)
    }
}
