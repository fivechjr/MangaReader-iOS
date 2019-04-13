//
//  RealMangaEdenApi.swift
//  mangaReader
//
//  Created by Yiming Dong on 2019/4/13.
//  Copyright © 2019 Yiming Dong. All rights reserved.
//

import Foundation
import Alamofire

class RealMangaEdenApi {
    
    static let DEFAULT_PAGE_SIZE = 30
    
    static func getMangaDetail(mangaIds: [String], completion:@escaping (MangaListResponse?, Error?) -> Void) {
//        let path = MangaEndpoint.manga.path
//        let parameters = ["mangaedenid": mangaIds]
//        NetworkManager.post(urlString: path, parameters: parameters, responseType: MangaListResponse.self, completion: completion)
    }
    
    static func getChapterDetail(mangaId: String, chapterId: String, completion:@escaping (EdenChapterDetailResponse?, Error?) -> Void) {
//        let path = MangaEndpoint.chapter(mangaId: mangaId, chapterId: chapterId).path
//        NetworkManager.get(urlString: path, responseType: EdenChapterDetailResponse.self, completion: completion)
    }
    
    static func getMangaList(pageNumber: Int, pageSize: Int = DEFAULT_PAGE_SIZE, language: MangaEdenLanguage = .english, completion:@escaping ([MangaProtocol]?, Error?) -> Void) {
        
        let path = RealMangaEdenEndpoint.mangaList(language: language
            , pageNumber: pageNumber
            , pageSize: pageSize).path
        
        NetworkManager.get(urlString: path, responseType: RealMangaEdenListResponse.self) {(response, error) in
            completion(response?.manga, error)
        }
    }
    
    static func getAllMangaList(language: MangaEdenLanguage = .english, completion:@escaping (RealMangaEdenListResponse?, Error?) -> Void) {
        let path = RealMangaEdenEndpoint.allMangaList(language: language).path
        NetworkManager.get(urlString: path, responseType: RealMangaEdenListResponse.self, completion: completion)
    }
    
    static func getImageUrl(withImagePath path: String?) -> String? {
        if let path = path {
            return "https://cdn.mangaeden.com/mangasimg/\(path)"
        }
        
        return nil
    }
}

