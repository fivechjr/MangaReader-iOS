//
//  MangaDetailViewModelProtocol.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/8.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

protocol MangaDetailViewModelProtocol {
    var manga: MangaProtocol {get set}
    
    var currentChapterID: String? {get set}
    
    var chaptersContentOffset: CGPoint {get set}
    
    func getManga(completion: @escaping (MangaProtocol?, Error?) -> Void)
}
