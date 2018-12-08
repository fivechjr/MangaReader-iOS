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
 
 api/ manga/reportBad [name='reportBad']
 api/ manga/getCategoryRecommend [name='getCategoryRecommend']
 api/ manga/getTopMangaList [name='getTopMangaList']
 */

enum MangaEndpoint {
    case manga
    case mangaList
    case search
    case chapter(mangaId: String, chapterId: String)
    case categoryManga(categoryName: String, pageIndex: Int, pageSize: Int)
    case categories
    case reportBad
    case getCategoryRecommend
    case getTopMangaList
    
    var baseUrl: String {
        return "http://111.231.224.94:8000/api/"
    }
    
    var path:String {
        switch self {
        case .manga:
            return baseUrl + "mangaList/mangaedenid"
        case .mangaList:
            return baseUrl + "mangaList"
        case .search:
            return baseUrl + "search"
        case .chapter(let mangaId, let chapterId):
            return baseUrl + "mangaid/\(mangaId)/chapterid/\(chapterId)"
        case .categoryManga(let categoryName, let pageIndex, let pageSize):
            return baseUrl + "manga/categoryName/\(categoryName)/pageIndex/\(pageIndex)/pageSize/\(pageSize)"
        case .categories:
            return baseUrl + "manga/categoryNames"
        case .reportBad:
            return baseUrl + "manga/reportBad"
        case .getCategoryRecommend:
            return baseUrl + "manga/getCategoryRecommend"
        case .getTopMangaList:
            return baseUrl + "manga/getTopMangaList"
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
