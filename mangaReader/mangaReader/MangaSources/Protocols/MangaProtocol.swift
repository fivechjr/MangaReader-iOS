//
//  MangaProtocol.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/10.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

protocol MangaProtocol {
    var mangaId: String? {get set}
    var mangaName: String? {get set}
    var mangaAuthor: String? {get set}
    var mangaDescription: String? {get}
    
    var mangaCreateDate: Double {get}
    var mangaUpdateDate: Double {get}
    var mangaCategories: [String] {get}
    
    var coverImageUrl: String? {get set}
    var topImageUrl: String? {get}
    var placeHolderImage: UIImage? {get}
    
    func canPublish() -> Bool
    
    var isCompleted: Bool {get}
    var chapterObjects: [EdenChapter]? {get}
}
