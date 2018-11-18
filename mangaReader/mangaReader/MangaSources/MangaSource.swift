//
//  MangaSource.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/11.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

enum MangaSource: String {
    case mangaEden
    case lama
    
    static var current: MangaSource = .mangaEden
}
