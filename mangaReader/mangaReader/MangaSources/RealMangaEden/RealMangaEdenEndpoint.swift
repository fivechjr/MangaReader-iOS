//
//  RealMangaEdenEndpoint.swift
//  mangaReader
//
//  Created by Yiming Dong on 2019/4/13.
//  Copyright © 2019 Yiming Dong. All rights reserved.
//
import Foundation

enum RealMangaEdenEndpoint {
    case manga(mangaId: String)
    // 25 < pageSize < 1500
    case mangaList(language: MangaEdenLanguage, pageNumber: Int, pageSize: Int)
    case allMangaList(language: MangaEdenLanguage)
    case chapter(chapterId: String)
    
    var baseUrl: String {
        return "https://www.mangaeden.com/api/"
    }
    
    var path:String {
        switch self {
        case .manga(let mangaId):
            return baseUrl + "manga/\(mangaId)"
        case .mangaList(let language, let pageNumber, let pageSize):
            return baseUrl + "list/\(language.rawValue)/?p=\(pageNumber)&l=\(pageSize)"
        case .allMangaList(let language):
            return baseUrl + "list/\(language.rawValue)/"
        case .chapter(let chapterId):
            return baseUrl + "chapter/\(chapterId)"
        }
    }
}
