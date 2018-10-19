//
//  Constants.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/4/25.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

struct Color {
    static let blue = UIColor(red: 21/255.0, green: 126/255.0, blue: 251/255.0, alpha: 1)
}

enum ImageConstant: String {
    case placeHolder = "manga_default"
}

struct Constants {
    static let appId = "1378089411"
    
    static var reviewURL: String {
        
        if #available(iOS 11.0, *) {
            return appStoreURL
        }
        
        let templateReviewURLiOS8 = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"
        
        return String(format: templateReviewURLiOS8, Constants.appId)
    }
    
    static var appStoreURL: String {
        return "https://itunes.apple.com/app/id\(Constants.appId)"
    }
}
