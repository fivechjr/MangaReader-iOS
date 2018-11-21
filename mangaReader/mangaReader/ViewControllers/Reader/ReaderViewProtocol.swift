//
//  ReaderViewProtocol.swift
//  mangaReader
//
//  Created by Yiming Dong on 18/11/18.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

protocol ReaderViewProtocol: class {
    
    var readerMode: ReaderMode {get set}
    
    var presenter: ReaderViewPresenterProtocol? {get set}
    var imageObjets:[ChapterImage]? {get set}
    
    func install(to parentVC: UIViewController, sameChapter: Bool)
    func start()
    func gotoPreviousPage()
    func gotoNextPage()
}

enum ReaderMode: Int {
    case pageHorizontal
    case pageVertical
    case pageCurl
    case collectionHorizontal
    case collectionVertical
    
    enum ViewType {
        case page
        case collection
    }
    
    static let cacheKey = "readerMode"
    
    static var currentValue: Int {
        get {
            return UserDefaults.standard.value(forKey: cacheKey) as? Int ?? 0
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: cacheKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var currentMode: ReaderMode {
        get {
            return ReaderMode(rawValue: currentValue) ?? .pageHorizontal
        }
    }
    
    var viewType: ViewType {
        switch self {
        case .pageVertical, .pageHorizontal, .pageCurl:
            return .page
        case .collectionVertical, .collectionHorizontal:
            return .collection
        }
    }
}
