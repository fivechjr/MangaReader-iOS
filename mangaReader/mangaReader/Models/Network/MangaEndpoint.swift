//
//  MangaEndpoint.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/5.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

/*
 api/ mangaList/pageIndex/<int:pageIndex>/pageSize/<int:pageSize>
 api/ searchMangaList/keyword/<str:keyword>/pageIndex/<int:pageIndex>/pageSize/<int:pageSize>
 api/ mangaid/<str:mangaid>/chapterid/<str:chapterid>
 api/ manga/categoryName/<str:categoryName>/pageIndex/<int:pageIndex>/pageSize/<int:pageSize>
 api/ manga/categoryNames
 */

enum MangaEndpoint {
    case manga
    case mangaList
    case searchManga(keyword: String, pageIndex: Int, pageSize: Int)
    case chapter(mangaId: String, chapterId: String)
    case categoryManga(categoryName: String, pageIndex: Int, pageSize: Int)
    case categories
    
    var baseUrl: String {
        return "http://dym1.com:8000/api/"
    }
    
    var path:String {
        switch self {
        case .manga:
            return baseUrl + "mangaList/mangaedenid"
        case .mangaList:
            return baseUrl + "mangaList"
        case .searchManga(let keyword, let pageIndex, let pageSize):
            return baseUrl + "searchMangaList/keyword/\(keyword)/pageIndex/\(pageIndex)/pageSize/\(pageSize)"
        case .chapter(let mangaId, let chapterId):
            return baseUrl + "mangaid/\(mangaId)/chapterid/\(chapterId)"
        case .categoryManga(let categoryName, let pageIndex, let pageSize):
            return baseUrl + "manga/categoryName/\(categoryName)/pageIndex/\(pageIndex)/pageSize/\(pageSize)"
        case .categories:
            return baseUrl + "manga/categoryNames"
        }
    }
}

enum MangaSort: String {
    case hits
    case last_chapter_date
}

/*
 http://dym1.com:8000/api/manga/categoryNames
 */
