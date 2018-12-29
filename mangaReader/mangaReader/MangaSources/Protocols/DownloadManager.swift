//
//  DownloadManager.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/27.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import Kingfisher

class DownloadManager {
    
    let downloader = ImageDownloader.default
    private var tasks: [RetrieveImageDownloadTask] = []
    
    func cancelDownload() {
        tasks.forEach { $0.cancel() }
        tasks.removeAll()
    }
    
    func removeCachedImage(_ urlString: String?) {
        guard let urlString = urlString else {return}
        ImageCache.default.removeImage(forKey: urlString)
    }
    
    func downloadImage(_ urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {return}
        
//        print("Image has been cached >>> \(ImageCache.default.imageCachedType(forKey: urlString))")
        let task = downloader.downloadImage(with: url) { (image, error, url, data) in
            if let error = error {
                print("Image download error: \(error), for url: \(url?.absoluteString ?? "N/A")")
            } else {
                print("Image download success, for url: \(url?.absoluteString ?? "N/A")")
            }
        }
        
        if let task = task {
            tasks.append(task)
        }
    }

    // MARK: subclass methods 
    func download(manga: MangaProtocol?, chapterDetail: ChapterDetailProtocol?) {
        fatalError("should be implemented by subclass")
    }
    
    func download(manga: MangaProtocol?, chapters: [ChapterProtocol]?) {
        fatalError("should be implemented by subclass")
    }
}
