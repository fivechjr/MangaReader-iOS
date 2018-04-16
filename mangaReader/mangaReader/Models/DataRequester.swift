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
    
    private static var MANGA_LIST_URL:String = "https://www.mangaeden.com/api/list/0/"
    
    static func getFullMangaList(completion:@escaping (MangaListResponse?)->Void) {
        
        Alamofire.request(MangaEdenAPI.mangaList.rawValue).responseObject { (response: DataResponse<MangaListResponse>) in
            
            completion(response.result.value);
            
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
}
