//
//  DataRequester.swift
//  mangaReader
//
//  Created by Yiming Dong on 16/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

enum MangaEdenAPI: String {
    case mangaList = "https://www.mangaeden.com/api/list/0/"
}

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
        guard let chapterID = chapterID else {
            completion(nil)
            return
        }
        let urlString = "https://www.mangaeden.com/api/chapter/\(chapterID)/"
        Alamofire.request(urlString).responseObject { (respObject: DataResponse<ChapterDetailResponse>) in
            let detail = respObject.result.value
            if let images = detail?.images {
                var imageObjects = [ChapterImage]()
                images.forEach({ (image) in
                    if let imageData = image as? [Any] {
                        let imageObj = ChapterImage(arrayData: imageData)
                        imageObjects.append(imageObj)
                    }
                })
                detail?.imageObjets = imageObjects.reversed()
            }
            
            completion(detail)
        }
    }
    
    static func getMangaDetail(mangaID: String?, completion:@escaping (MangaDetailResponse?)->Void) {
        guard let mangaID = mangaID else {
            completion(nil)
            return
        }
        let urlString = "https://www.mangaeden.com/api/manga/\(mangaID)/"
        Alamofire.request(urlString).responseObject { (respObject: DataResponse<MangaDetailResponse>) in
            let detail = respObject.result.value
            if let chapters = detail?.chapters {
                var chapterObjects = [Chapter]()
                chapters.forEach({ (chapter) in
                    if let chapterData = chapter as? [Any] {
                        let chapterObj = Chapter(arrayData: chapterData)
                        chapterObjects.append(chapterObj)
                    }
                })
                detail?.chapterObjects = chapterObjects
            }
            
            completion(detail)
        }
    }
    
    static func getMangaListFromCache(completion:@escaping (MangaListResponse?)->Void) {
        guard  let url = mangaListCachePath(), let mangaListString = try? String(contentsOf: url, encoding: String.Encoding.utf8) else {
            getFullMangaList(completion: completion)
            return
        }
        
        let mangaListResponse = MangaListResponse(JSONString: mangaListString)
        completion(mangaListResponse)
        
        let now = Date()
        if let cacheDate = UserDefaults.standard.object(forKey: cacheDateKey) as? Date
            , now.timeIntervalSince(cacheDate) > updateInterval {
            getFullMangaList(completion: completion)
        }
    }
    
    static func getFullMangaList(completion:@escaping (MangaListResponse?)->Void) {
        
        Alamofire.request(MangaEdenAPI.mangaList.rawValue).responseObject { (response: DataResponse<MangaListResponse>) in
            
            completion(response.result.value);
            
            }.responseData { (responseData) in
                if responseData.result.isSuccess, let data = responseData.result.value {
                    cacheMangaListData(data)
                }
        }
    }
    
    static func getMangaList(page:Int, size:Int, completion:@escaping (MangaListResponse?)->Void) {
        let manager = Alamofire.SessionManager.default;
        manager.session.configuration.timeoutIntervalForRequest = 120
        let params: Parameters = ["p":page, "l":size]
        Alamofire.request(MangaEdenAPI.mangaList.rawValue, parameters: params, encoding: URLEncoding.queryString)
            
            .responseObject { (response: DataResponse<MangaListResponse>) in
            
            completion(response.result.value);
            
            }.responseString { (responseString) in
                
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
