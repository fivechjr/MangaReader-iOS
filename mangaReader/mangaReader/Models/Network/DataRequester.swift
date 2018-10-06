//
//  DataRequester.swift
//  mangaReader
//
//  Created by Yiming Dong on 16/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import Alamofire
//import AlamofireObjectMapper

class DataRequester {
    
    private static var mangaListCacheFileName:String = "mangaList.json"
    private static var cacheDateKey = "cacheDate"
    private static var updateInterval:Double = 86400
    
    static func copyCacheFileFromBundleIfNotExist() {
        guard let filePath = Bundle.main.path(forResource: "mangaList", ofType: "json")
            , let cachePath = mangaListCachePath() else {
                return
        }
        
        let cacheExists = FileManager.default.fileExists(atPath: cachePath.absoluteString)
        let fileExists = FileManager.default.fileExists(atPath: filePath)
        if !cacheExists && fileExists {
            try? FileManager.default.copyItem(atPath: filePath, toPath: cachePath.path)
        }
    }
    
    static func getImageUrl(withImagePath path: String?) -> String? {
        if let path = path {
            return "https://cdn.mangaeden.com/mangasimg/\(path)"
        }
        
        return nil
    }
    
    static func getChapterDetail(chapterID: String?, completion:@escaping (ChapterDetailResponse?)->Void) {
//        guard let chapterID = chapterID else {
//            completion(nil)
//            return
//        }
//        let urlString = "https://www.mangaeden.com/api/chapter/\(chapterID)/"
//        Alamofire.request(urlString).responseObject { (respObject: DataResponse<ChapterDetailResponse>) in
//            let detail = respObject.result.value
//            if let images = detail?.images {
//                var imageObjects = [ChapterImage]()
//                images.forEach({ (image) in
//                    if let imageData = image as? [Any] {
//                        let imageObj = ChapterImage(arrayData: imageData)
//                        imageObjects.append(imageObj)
//                    }
//                })
//                detail?.imageObjets = imageObjects.reversed()
//            }
//
//            completion(detail)
//        }
    }
    
    static func getMangaDetail(mangaID: String?, completion:@escaping (Manga?)->Void) {
//        guard let mangaID = mangaID else {
//            completion(nil)
//            return
//        }
//        let urlString = "https://www.mangaeden.com/api/manga/\(mangaID)/"
//        Alamofire.request(urlString).responseObject { (respObject: DataResponse<MangaDetailResponse>) in
//            let detail = respObject.result.value
//            if let chapters = detail?.chapters {
//                var chapterObjects = [Chapter]()
//                chapters.forEach({ (chapter) in
//                    if let chapterData = chapter as? [Any] {
//                        let chapterObj = Chapter(arrayData: chapterData)
//                        chapterObjects.append(chapterObj)
//                    }
//                })
//                detail?.chapterObjects = chapterObjects
//            }
//
//            completion(detail)
//        }
    }
    
    static func getMangaList(page:Int, size:Int, completion:@escaping (MangaListResponse?, Error?)->Void) {
        let path = MangaEndpoint.mangaList(pageIndex: page, pageSize: size).path
        guard let url = URL(string: path) else {return}
        Alamofire.request(url).responseData { (response) in
            guard let data = response.result.value else {
                completion(nil, response.result.error)
                return
            }
            
            do {
                let object = try JSONDecoder().decode(MangaListResponse.self, from: data)
                completion(object, nil)
            } catch let error {
                completion(nil, error)
            }
        }
    }
    
    static func mangaListCachePath() -> URL? {
        guard let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return nil
        }
        
        var url = URL(fileURLWithPath: documentsPath, isDirectory: true)
        url.appendPathComponent(mangaListCacheFileName)
        
        return url
    }
    
    static func cacheMangaListData(_ data: Data) {
        if let cacheUrl = mangaListCachePath() {
            try? data.write(to: cacheUrl)
            
            let cacheDate = Date();
            UserDefaults.standard.set(cacheDate, forKey: cacheDateKey)
            UserDefaults.standard.synchronize()
        }
    }
}
