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
    case mangaList(pageIndex: Int, pageSize: Int)
    
    var baseUrl: String {
        return "http://dym1.com:8000/api/"
    }
    
    var path:String {
        switch self {
        case .mangaList(let pageIndex, let pageSize):
            return baseUrl + "mangaList/pageIndex/\(pageIndex)/pageSize/\(pageSize)"
        }
    }
}
