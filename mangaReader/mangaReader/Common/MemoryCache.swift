//
//  MemoryCache.swift
//  mangaReader
//
//  Created by Yiming Dong on 2019/3/17.
//  Copyright © 2019 Yiming Dong. All rights reserved.
//

import Foundation

class MemoryCache {
    private init(){}
    static var shared = MemoryCache()
    
    var limitedFunction = false
}
