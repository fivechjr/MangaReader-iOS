//
//  LamaCategory.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/12/26.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class LamaCategory: CategoryProtocol, Codable {
    
    var id: String
    var title: String
    
    init(title: String, id: String) {
        self.title = title
        self.id = id
    }
}
