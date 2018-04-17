//
//  DataRequester.swift
//  mangaReader
//
//  Created by Yiming Dong on 16/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

enum MangaEdenAPI: String {
    case mangaList = "https://www.mangaeden.com/api/list/0/"
}

class DataRequester {
    
    private static var mangaListCacheFileName:String = "mangaList"
    private static var cacheDateKey = "cacheDate"
    private static var updateInterval:Double = 86400
    
    static func getMangaListFromCache(completion:@escaping (MangaListResponse?)->Void) {
        guard  let url = mangaListCachePath(), let mangaListString = try? String(contentsOf: url, encoding: String.Encoding.utf8) else {
            getFullMangaList(completion: completion)
            return
        }
        
        let now = Date()
        if let cacheDate = UserDefaults.standard.object(forKey: cacheDateKey) as? Date
            , now.timeIntervalSince(cacheDate) > updateInterval {
            getFullMangaList(completion: completion)
            return
        }
        
        let mangaListResponse = MangaListResponse(JSONString: mangaListString)
        completion(mangaListResponse)
    }
    
    static func getFullMangaList(completion:@escaping (MangaListResponse?)->Void) {
        
        Alamofire.request(MangaEdenAPI.mangaList.rawValue).responseObject { (response: DataResponse<MangaListResponse>) in
            
            completion(response.result.value);
            
            }.responseData { (responseData) in
                if responseData.result.isSuccess, let data = responseData.result.value {
                    cacheMangaListData(data)
                }
        }
    }
    
    static func getMangaList(page:Int, size:Int, completion:@escaping (MangaListResponse?)->Void) {
        let manager = Alamofire.SessionManager.default;
        manager.session.configuration.timeoutIntervalForRequest = 120
        let params: Parameters = ["p":page, "l":size]
        Alamofire.request(MangaEdenAPI.mangaList.rawValue, parameters: params, encoding: URLEncoding.queryString)
            
            .responseObject { (response: DataResponse<MangaListResponse>) in
            
            completion(response.result.value);
            
            }.responseString { (responseString) in
                
        }
    }
    
    static func mangaListCachePath() -> URL? {
        guard let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return nil
        }
        
        var url = URL(fileURLWithPath: documentsPath, isDirectory: true)
        url.appendPathComponent(mangaListCacheFileName)
        
        return url
    }
    
    static func cacheMangaListData(_ data: Data) {
        if let cacheUrl = mangaListCachePath() {
            try? data.write(to: cacheUrl)
            
            let cacheDate = Date();
            UserDefaults.standard.set(cacheDate, forKey: cacheDateKey)
            UserDefaults.standard.synchronize()
        }
    }
}
