//
//  ChapterProtocol.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/9.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

protocol ChapterProtocol {
    var chapterId: String? {get set}
    var chapterTitle: String? {get set}
    var chapterUpdateTime: Double? {get set}
}
