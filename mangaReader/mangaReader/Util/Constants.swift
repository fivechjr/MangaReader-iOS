//
//  Constants.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/4/25.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

enum ImageConstant: String {
    case placeHolder = "manga_default"
    
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
}

struct Constants {
    static let appId = "1378089411"
    
    private static let mangaCountInRowPad = 5
    private static let mangaCountInRowPhone = 3
    
    static var isPad: Bool {
        return (UI_USER_INTERFACE_IDIOM() == .pad)
    }
    
    static var pageSize: Int {
        return mangaCountInRow * 7
    }
    
    static var mangaCountInRow: Int {
        return isPad ? mangaCountInRowPad : mangaCountInRowPhone
    }
    
    static var reviewURL: String {
        
        if #available(iOS 11.0, *) {
            return appStoreURL
        }
        
        let templateReviewURLiOS8 = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"
        
        return String(format: templateReviewURLiOS8, Constants.appId)
    }
    
    static var appStoreURL: String {
        // https://itunes.apple.com/us/app/manga-monster/id1378089411?ls=1&mt=8
        return "https://itunes.apple.com/app/id\(Constants.appId)"
    }
}
