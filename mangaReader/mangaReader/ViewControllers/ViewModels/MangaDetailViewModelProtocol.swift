//
//  MangaDetailViewModelProtocol.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/8.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

protocol MangaDetailViewModelProtocol: MangaDetailDataProtocol {
    var manga: MangaProtocol {get set}
    
    var mangaId: String? {get set}
    
    var currentChapterID: String? {get set}
    
    var chaptersContentOffset: CGPoint {get set}
    
    func getManga(completion: @escaping (MangaProtocol?, Error?) -> Void)
    
    func getChapter(withID chapterID: String?, completion: (ChapterProtocol?, Error?) -> Void)
    
    func getChapterIndex(withID chapterID: String?) ->Int?
}

protocol MangaDetailDataProtocol {
    func recordRecentManga()
    func getCurrentChapterID()
    func recordCurrentChapter(chapterId: String?)
    var isFavorite: Bool {get}
    func addFavorite()
}
