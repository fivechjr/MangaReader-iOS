//
//  ChapterImage.swift
//  mangaReader
//
//  Created by Yiming Dong on 19/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class ChapterImage {
    var number: Int?
    var imagePath: String?
    var chapterNumber: Int?
    var hitCount: Int?
    
    init(arrayData: [Any]?) {
        if let data = arrayData, data.count == 4 {
            
            if let number = data[0] as? Int {
                self.number = number
            }
            
            if let imagePath = data[1] as? String {
                self.imagePath = imagePath
            }
            
            if let chapterNumber = data[2] as? Int {
                self.chapterNumber = chapterNumber
            }
            
            if let hitCount = data[3] as? Int {
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
