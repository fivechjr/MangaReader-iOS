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
    
    static func getMangaDetail(mangaId: String, completion:@escaping (MangaProtocol?, Error?) -> Void) {
        let path = RealMangaEdenEndpoint.manga(mangaId: mangaId).path
        
        NetworkManager.get(urlString: path, responseType: Manga.self) { (manga, error) in
            manga?.mangaId = mangaId
            completion(manga, error)
        }
    }
    
    static func getChapterDetail(chapterId: String, completion:@escaping (ChapterDetailProtocol?, Error?) -> Void) {
        let path = RealMangaEdenEndpoint.chapter(chapterId: chapterId).path
        NetworkManager.get(urlString: path, responseType: EdenChapterDetail.self) { (chapter, error) in
            chapter?.chapterId = chapterId
            completion(chapter, error)
        }
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

