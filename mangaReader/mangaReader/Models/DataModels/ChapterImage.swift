//
//  ChapterImage.swift
//  mangaReader
//
//  Created by Yiming Dong on 19/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class ChapterImage: Codable, Equatable {
    
    static func == (lhs: ChapterImage, rhs: ChapterImage) -> Bool {
        guard let path1 = lhs.imagePath, let path2 = rhs.imagePath else {
            return lhs === rhs
        }
        
        return path1 == path2
    }
    
    var number: Int?
    var imagePath: String?
    var chapterNumber: Int?
    var hitCount: Int?
    
    private enum CodingKeys: String, CodingKey {
        case number
        case imagePath
        case chapterNumber
        case hitCount
    }
    
    init(datas: [CodableValue?]?) {
        
        if let datas = datas, datas.count == 4 {
            
            if let data = datas[0], case let CodableValue.int(number) = data {
                self.number = number
            }
            
            if let data = datas[1], case let CodableValue.string(imagePath) = data {
                self.imagePath = imagePath
            }
            
            if let data = datas[2], case let CodableValue.int(chapterNumber) = data {
                self.chapterNumber = chapterNumber
            }
            
            if let data = datas[3], case let CodableValue.int(hitCount) = data {
                self.hitCount = hitCount
            }
        }
    }
}


/*
 [
 1,
 "42/42afe7a499ced293a5f197165c39e137f579e816ef352e7a2b1fad14.jpg",
 760,
 1721
 ]
 */
