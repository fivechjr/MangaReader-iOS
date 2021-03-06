//
//  MangaProtocol.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/10.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

protocol MangaProtocol {
    var mangaSource: String? {get set}
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
    
    var hits: Int? {get set}
    var lastChapterDate: Double? {get set}
    
    func canPublish() -> Bool
    
    var isCompleted: Bool {get}
    var chapterObjects: [ChapterProtocol]? {get}
}
