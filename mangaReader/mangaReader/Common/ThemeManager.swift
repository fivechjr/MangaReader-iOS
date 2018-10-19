//
//  ThemeManager.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/19.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

enum Theme {
    case light
    case dark
    
    var backgroundColor: UIColor {
        switch self {
        case .light:
            return UIColor.white
        case .dark:
            return UIColor(white: 0.1, alpha: 1)
        }
    }
}

class ThemeManager {
    private init(){}
    static var shared = ThemeManager()
    
    var currentTheme: Theme = .light {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name.themeChanged, object: currentTheme)
        }
    }
}




