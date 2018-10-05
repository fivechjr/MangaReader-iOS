//
//  Chapter.swift
//  mangaReader
//
//  Created by Yiming Dong on 17/04/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class Chapter: Codable {
    var id: String?
    var number: Int?
    var updateTime: Double?
    var title: String?
    
    init(datas: [CodableValue?]?) {
        if let datas = datas, datas.count == 4 {

            if let data = datas[0], case let CodableValue.int(number) = data {
                self.number = number
            }

            if let data = datas[1], case let CodableValue.double(updateTime) = data {
                self.updateTime = updateTime
            }

            if let data = datas[2], case let CodableValue.string(title) = data {
                self.title = title
            }

            if let data = datas[3], case let CodableValue.string(id) = data {
                self.id = id
            }
        }
    }
}
