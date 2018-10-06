//
//  DataRequester.swift
//  mangaReader
//
//  Created by Yiming Dong on 16/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import Alamofire

typealias MangaListResponseHandler = (MangaListResponse?, Error?) -> Void

class DataRequester {
    
    static func getImageUrl(withImagePath path: String?) -> String? {
        if let path = path {
            return "https://cdn.mangaeden.com/mangasimg/\(path)"
        }
        
        return nil
    }
    
    static func getChapterDetail(mangaId: String, chapterId: String, completion:@escaping (ChapterDetailResponse?, Error?)->Void) {
        
        let path = MangaEndpoint.chapter(mangaId: mangaId, chapterId: chapterId).path
        get(urlString: path, responseType: ChapterDetailResponse.self, completion: completion)
    }
    
    static func getMangaList(page:Int, size:Int, completion:@escaping MangaListResponseHandler) {
        let path = MangaEndpoint.mangaList(pageIndex: page, pageSize: size).path
        get(urlString: path, responseType: MangaListResponse.self, completion: completion)
    }
}

extension DataRequester {
    fileprivate static func get<T>(urlString: String?, responseType: T.Type, completion: @escaping (T?, Error?) -> Void) where T: Codable {
        guard let urlString = urlString, let url = URL(string: urlString) else {return}
        Alamofire.request(url).responseData { (response) in
            guard let data = response.result.value else {
                completion(nil, response.result.error)
                return
            }
            
            do {
                let object = try JSONDecoder().decode(responseType, from: data)
                completion(object, nil)
            } catch let error {
                completion(nil, error)
            }
        }
    }
}
