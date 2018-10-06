//
//  ChapterImage.swift
//  mangaReader
//
//  Created by Yiming Dong on 19/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class ChapterImage: Codable {
    var number: Int?
    var imagePath: String?
    var chapterNumber: Int?
    var hitCount: Int?
    
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
