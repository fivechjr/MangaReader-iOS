//
//  BaseChapterReadViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/12.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import AlamofireImage

class BaseChapterReadViewModel {
    var chapterObject: ChapterProtocol?
    var manga: MangaProtocol?
    
    var currentPageIndex: Int = 0
    
    var chapterDetail: ChapterDetailProtocol?
    
    let downloader = ImageDownloader()
    private var receipts: [RequestReceipt] = []
    
    var chapterName: String {
        let name = chapterObject?.chapterTitle ?? chapterObject?.chapterId ?? ""
        return "\(LocalizedString("Chapter")) - '\(name)'"
    }
    
    var pageInfoText: String? {
        return "\(currentPageIndex + 1)/\(chapterDetail?.chapterImages?.count ?? 0)"
    }
    
    var nextChapterButtonHidden: Bool {
        guard let chapterIndex = getCurrentChapterIndex(), chapterIndex > 0 else {
            return true
        }
        
        return false
    }
    
    var prevChapterButtonHidden: Bool {
        guard let chapterCount = manga?.chapterObjects?.count,
            let chapterIndex = getCurrentChapterIndex(),
            chapterIndex < chapterCount - 1 else {
                return true
        }
        
        return false
    }
    
    func getChapterDetail(completion: @escaping (ChapterDetailProtocol?, Error?) -> Void) {
        fatalError("should be overrided by subclass")
    }
    
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
    
    func downloadImages() {
        fatalError("should be overrided by subclass")
    }
    
    func recordCurrentChapter() {
        guard let chapterId = chapterObject?.chapterId, let mangaId = manga?.mangaId else {return}
        DataManager.shared.recordCurrentChapter(chapterId: chapterId, mangaId: mangaId)
    }
    
    func getCurrentChapterIndex() -> Int? {
        
        guard let chapterObjects = manga?.chapterObjects, let currentId = chapterObject?.chapterId else {
            return nil
        }
        
        for (index, chapter) in chapterObjects.enumerated() {
            if let id = chapter.chapterId, id == currentId {
                return index
            }
        }
        
        return nil;
    }
    
    func chapter(next: Bool) -> ChapterProtocol? {
        guard var index = getCurrentChapterIndex()
            , let chapterObjects = manga?.chapterObjects else {
                return nil
        }
        
        // next is the earlier chapter, so -1
        index = next ? index - 1 : index + 1
        if (index >= 0 && index < chapterObjects.count) {
            return chapterObjects[index]
        }
        
        return nil
    }
    
    func goToChapter(next: Bool, completion: @escaping () -> Void) {
        guard let chapter = chapter(next: next) else {return}
        chapterObject = chapter
        completion()
    }
}
