//
//  Chapter.swift
//  mangaReader
//
//  Created by Yiming Dong on 17/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class Chapter {
    var id: String?
    var number: Int?
    var updateTime: Double?
    var title: String?
    
    init(arrayData: [Any]?) {
        if let data = arrayData, data.count == 4 {
            
            if let number = data[0] as? Int {
                self.number = number
            }
            
            if let updateTime = data[1] as? Double {
                self.updateTime = updateTime
            }
            
            if let title = data[2] as? String {
                self.title = title
            }
            
            if let id = data[3] as? String {
                self.id = id
            }
        }
    }
}
