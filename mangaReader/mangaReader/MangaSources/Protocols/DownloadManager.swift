//
//  DownloadManager.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/27.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import AlamofireImage

class DownloadManager {
    
    let downloader = ImageDownloader()
    private var receipts: [RequestReceipt] = []
    
    func cancelDownload() {
        receipts.forEach { downloader.cancelRequest(with: $0) }
        receipts.removeAll()
    }
    
    func downloadImage(_ urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {return}
        
        let urlRequest = URLRequest(url: url)
        
        let receipt = downloader.download(urlRequest) { response in
            print("Download:\(urlRequest.url?.absoluteString ?? "") - Success: \(response.result.isSuccess)")
        }
        
        if let receipt = receipt {
            receipts.append(receipt)
        }
    }

    // MARK: subclass methods 
    func download(mangaId: String?, chapterDetail: ChapterDetailProtocol?) {
        fatalError("should be implemented by subclass")
    }
    
    func download(mangaId: String?, chapters: [ChapterProtocol]?) {
        fatalError("should be implemented by subclass")
    }
}
