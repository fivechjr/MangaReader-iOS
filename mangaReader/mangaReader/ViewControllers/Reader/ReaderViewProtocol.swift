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
    
    func install(to parentVC: UIViewController)
    func uninstall(sameChapter: Bool)
    
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
    
    var title: String {
        switch self {
        case .pageHorizontal:
            return LocalizedString("lbl_read_mode_page_horizonal")
        case .pageVertical:
            return LocalizedString("lbl_read_mode_page_vertical")
        case .pageCurl:
            return LocalizedString("lbl_read_mode_page_curl")
        case .collectionHorizontal:
            return LocalizedString("lbl_read_mode_collection_horizonal")
        case .collectionVertical:
            return LocalizedString("lbl_read_mode_collection_vertical")
        }
    }
    
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
        
        set {
            currentValue = newValue.rawValue
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
