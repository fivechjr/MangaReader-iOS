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
typealias CategoryNamesResponseHandler = (CategoryNamesResponse?, Error?) -> Void
typealias ChapterDetailResponseHandler = (ChapterDetailResponse?, Error?) -> Void

class DataRequester {
    static func getMangaDetail(mangaIds: [String], completion:@escaping MangaListResponseHandler) {
        let path = MangaEndpoint.manga.path
        let parameters = ["mangaedenid": mangaIds]
        post(urlString: path, parameters: parameters, responseType: MangaListResponse.self, completion: completion)
    }
    
    static func getChapterDetail(mangaId: String, chapterId: String, completion:@escaping ChapterDetailResponseHandler) {
        let path = MangaEndpoint.chapter(mangaId: mangaId, chapterId: chapterId).path
        get(urlString: path, responseType: ChapterDetailResponse.self, completion: completion)
    }
    
    static func getMangaList(page:Int, size:Int, sort: MangaSort, completion:@escaping ([Manga]?, Error?) -> Void) {
        let path = MangaEndpoint.mangaList.path
        let parameters: [String: Any] = ["pageIndex": page,
                          "pageSize": size,
                          "sortField": sort.rawValue]
        
        post(urlString: path, parameters: parameters, responseType: MangaListResponse.self) {(response, error) in
            completion(response?.mangalist, error)
        }
    }
    
    static func getCategories(completion:@escaping CategoryNamesResponseHandler) {
        let path = MangaEndpoint.categories.path
        get(urlString: path, responseType: CategoryNamesResponse.self, completion: completion)
    }
    
    static func searchManga(withKeyword keyword: String, page:Int, size:Int, sort: MangaSort? = nil, categoryNames: [String]? = nil, completion:@escaping MangaListResponseHandler) {
        let path = MangaEndpoint.search.path
        var parameters: [String: Any] = ["pageIndex": page,
                                         "pageSize": size,
                                         "keyword": keyword]
        if let sortField = sort?.rawValue, !sortField.isEmpty {
            parameters["sortField"] = sortField
        }
        
        if let categoryNames = categoryNames, !categoryNames.isEmpty {
            parameters["categoryNames"] = categoryNames
        }
        
        post(urlString: path, parameters: parameters, responseType: MangaListResponse.self, completion:completion)
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
    
    fileprivate static func post<T>(urlString: String?, parameters: Parameters? = nil, responseType: T.Type, completion: @escaping (T?, Error?) -> Void) where T: Codable {
        guard let urlString = urlString, let url = URL(string: urlString) else {return}
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { (response) in
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
    
    static func getImageUrl(withImagePath path: String?) -> String? {
        if let path = path {
            return "https://cdn.mangaeden.com/mangasimg/\(path)"
        }
        
        return nil
    }
}
