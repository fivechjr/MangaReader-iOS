//
//  EdenCategory.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/22.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class EdenCategory: CategoryProtocol, Codable {
    
    var id: String {
        return title
    }
    var title: String
    
    init(title: String) {
        self.title = title
    }
}
