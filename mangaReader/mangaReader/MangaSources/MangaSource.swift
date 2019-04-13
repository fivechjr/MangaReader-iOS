//
//  MangaSource.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/11.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import RxSwift

enum MangaSource: String {
    case mangaEden
    case mangaEdenReal
    case lama
    
    static var sourceChangedSignal = Variable<MangaSource>(MangaSource.current)
    
    private static let storageKey = "manga_source_current_key"
    static var current: MangaSource {
        get {
            let str = UserDefaults.standard.value(forKey: storageKey) as? String ?? ""
            return MangaSource(rawValue: str) ?? .mangaEden
        }
        set {
            let oldValue = current
            UserDefaults.standard.set(newValue.rawValue, forKey: storageKey)
            
            if oldValue != newValue {
                sourceChangedSignal.value = newValue
            }
        }
    }
}
