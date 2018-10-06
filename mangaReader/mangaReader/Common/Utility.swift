//
//  Utility.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/7.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class Utility {
    static func string(_ target: String, containsAny stringArray: [String], caseSensitive: Bool = false) -> Bool {
        for str in stringArray {
            if caseSensitive {
                if target.contains(str) {
                    return true
                }
            } else {
                if target.lowercased().contains(str.lowercased()) {
                    return true
                }
            }
        }
        
        return false
    }
    
    static func strings(_ targets: [String], containsAny stringArray: [String], caseSensitive: Bool = false) -> Bool {
        for target in targets {
            if string(target, containsAny: stringArray, caseSensitive: caseSensitive) {
                return true
            }
        }
        
        return false
    }
}

public func LocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: key)
}
