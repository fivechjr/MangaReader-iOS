//
//  DownloadManager.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/27.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import Kingfisher
import RxSwift

class DownloadManager {
    private static let edenManager: DownloadManager = {
        return FSInjector.shared.resolve(DownloadManager.self, source: MangaSource.mangaEden)!
    } ()
    
    private static let lamaManager: DownloadManager = {
        return FSInjector.shared.resolve(DownloadManager.self, source: MangaSource.lama)!
    } ()
    
    private static let edenRealManager: DownloadManager = {
        return FSInjector.shared.resolve(DownloadManager.self, source: MangaSource.mangaEdenReal)!
    } ()
    
    static var shared: DownloadManager {
        switch MangaSource.current {
        case .mangaEden:
            return edenManager
        case .mangaEdenReal:
            return edenRealManager
        case .lama:
            return lamaManager
        }
    }
    
    private let downloader = ImageDownloader.default
    private var tasks: [RetrieveImageTask] = []
    
    var downloadedChaptersSignal = Variable<Set<String>>([])
    
    func cancelDownload() {
        tasks.forEach { $0.cancel() }
        tasks.removeAll()
    }
    
    func removeCachedImage(_ urlString: String?) {
        guard let urlString = urlString else {return}
        ImageCache.default.removeImage(forKey: urlString)
    }
    
    func hasBeenCached(_ urlString: String?) -> Bool {
        guard let urlString = urlString else {return false}
        return ImageCache.default.imageCachedType(forKey: urlString) != .none
    }
    
    func downloadedPageCount(_ chapterDetail: ChapterDetailProtocol?) -> Int {
        guard let chapterDetail = chapterDetail, let imageUrls = chapterDetail.chapterImages else {return 0}
        return imageUrls.filter({hasBeenCached($0)}).count
    }
    
    func downloadImage(_ urlString: String?, completion: @escaping (Bool) -> Void) {
        guard let urlString = urlString, let url = URL(string: urlString) else {return}
        
        if hasBeenCached(urlString) {
            // image has been cached
            completion(true)
            return
        }
        
        let task = KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { (image, error, cacheType, url) in
            if let error = error {
                print("Image download error: \(error), for url: \(url?.absoluteString ?? "N/A")")
            } else {
                print("Image download success, for url: \(url?.absoluteString ?? "N/A")")
            }
            
            completion(error == nil)
        }
        tasks.append(task)
    }

    // MARK: subclass methods 
    func download(manga: MangaProtocol?, chapterDetail: ChapterDetailProtocol?) {
        fatalError("should be implemented by subclass")
    }
    
    func download(manga: MangaProtocol?, chapters: [ChapterProtocol]?) {
        fatalError("should be implemented by subclass")
    }
}
