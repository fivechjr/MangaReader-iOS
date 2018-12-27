//
//  DownloadManager.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/27.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class DownloadManager {
    static let shared: DownloadManager = {
        return FSInjector.shared.resolve(DownloadManager.self)!
    }()
    func downloadManga(_ mangaId: String, chapterIds: [String], completion: (Bool) -> Void) {
        
    }
}

class EdenDownloadManager: DownloadManager {
    override func downloadManga(_ mangaId: String, chapterIds: [String], completion: (Bool) -> Void) {
        
    }
}

class LamaDownloadManager: DownloadManager {
    override func downloadManga(_ mangaId: String, chapterIds: [String], completion: (Bool) -> Void) {
        
    }
}
