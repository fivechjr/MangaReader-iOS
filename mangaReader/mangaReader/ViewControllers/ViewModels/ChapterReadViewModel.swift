//
//  ChapterReadViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/8.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import AlamofireImage

class ChapterReadViewModel {
    var chapterObject: Chapter
    var manga: Manga
    
    var currentPageIndex: Int = 0
    
    init(chapterObject: Chapter, manga: Manga) {
        self.chapterObject = chapterObject
        self.manga = manga
    }
    
    var chapterDetail: ChapterDetailResponse?
    
    let downloader = ImageDownloader()
    private var receipts: [RequestReceipt] = []
    
    var chapterName: String {
        let name = chapterObject.title ?? String(chapterObject.number ?? 0)
        return "\(LocalizedString("Chapter")) - '\(name)'"
    }
    
    var pageInfoText: String? {
        return "\(currentPageIndex + 1)/\(chapterDetail?.chapter?.images?.count ?? 0)"
    }
    
    var nextChapterButtonHidden: Bool {
        guard let chapterIndex = getCurrentChapterIndex(), chapterIndex > 0 else {
            return true
        }
        
        return false
    }
    
    var prevChapterButtonHidden: Bool {
        guard let chapterCount = manga.chapters?.count,
            let chapterIndex = getCurrentChapterIndex(),
            chapterIndex < chapterCount - 1 else {
            return true
        }
        
        return false
    }
    
    func getChapterDetail(completion: @escaping ChapterDetailResponseHandler) {
        guard let mangaId = manga.id, let chapterId = chapterObject.id else {return}
        
        DataRequester.getChapterDetail(mangaId: mangaId, chapterId: chapterId) { [weak self] (chapterDetail, error) in
            self?.chapterDetail = chapterDetail
            completion(chapterDetail, error)
        }
    }
    
    func cancelDownload() {
        receipts.forEach { downloader.cancelRequest(with: $0) }
        receipts.removeAll()
    }
    
    func downloadImages() {
        
        cancelDownload()
        
        chapterDetail?.chapter?.imageObjets?.forEach({ (chapterImage) in
            if let imagePath = chapterImage.imagePath
                , let urlString = DataRequester.getImageUrl(withImagePath: imagePath)
                , let url = URL(string: urlString) {
                
                let urlRequest = URLRequest(url: url)
                
                let receipt = downloader.download(urlRequest) { response in
                    print("Download:\(urlRequest.url?.absoluteString ?? "") - Success: \(response.result.isSuccess)")
                }
                
                if let receipt = receipt {
                    receipts.append(receipt)
                }
            }
        })
    }
    
    func recordCurrentChapter() {
        DataManager.shared.recordCurrentChapter(chapterId: chapterObject.id, mangaId: manga.id)
    }
    
    func getCurrentChapterIndex() -> Int? {
        
        guard let chapterObjects = manga.chapterObjects, let currentId = chapterObject.id else {
            return nil
        }
        
        for (index, chapter) in chapterObjects.enumerated() {
            if let id = chapter.id, id == currentId {
                return index
            }
        }
        
        return nil;
    }
    
    func chapter(next: Bool) -> Chapter? {
        guard var index = getCurrentChapterIndex()
            , let chapterObjects = manga.chapterObjects else {
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