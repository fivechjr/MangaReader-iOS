//
//  ThemeManager.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/19.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

enum Theme: Int {
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
    
    var backgroundSecondColor: UIColor {
        switch self {
        case .light:
            return UIColor(white: 0.98, alpha: 1)
        case .dark:
            return UIColor.greenBlack
        }
    }
    
    var cellSeperatorColor: UIColor {
        switch self {
        case .light:
            return UIColor(white: 0.9, alpha: 1)
        case .dark:
            return UIColor(white: 0.2, alpha: 1)
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .light:
            return UIColor.black
        case .dark:
            return UIColor.white
        }
    }
    
    var textSecondColor: UIColor {
        switch self {
        case .light:
            return UIColor(white: 0.2, alpha: 1)
        case .dark:
            return UIColor(white: 0.8, alpha: 1)
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .light:
            return UIColor.blueSky
        case .dark:
            return UIColor(white: 0.9, alpha: 1)
        }
    }
    
    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .light:
            return .default
        case .dark:
            return .lightContent
        }
    }
    
    var activityIndicatorStyle: UIActivityIndicatorViewStyle {
        switch self {
        case .light:
            return UIActivityIndicatorViewStyle.gray
        case .dark:
            return UIActivityIndicatorViewStyle.white
        }
    }
}

class ThemeManager {
    private init(){}
    static var shared = ThemeManager()
    
    let key_currentTheme = "currentTheme"
    
    func load() {
        let savedThemeId = (UserDefaults.standard.value(forKey: key_currentTheme) as? Int) ?? Theme.light.rawValue
        currentTheme = Theme(rawValue: savedThemeId) ?? Theme.light
    }
    
    var currentTheme: Theme = .light {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: key_currentTheme)
            handleThemeChanged(currentTheme: currentTheme)
        }
    }
    
    func handleThemeChanged(currentTheme: Theme) {

        updateAppearance()

        updateScreenUI()
    }
    
    func updateAppearance() {
        UINavigationBar.appearance().backgroundColor = currentTheme.backgroundColor
        UINavigationBar.appearance().barTintColor = currentTheme.backgroundColor
        UINavigationBar.appearance().tintColor = currentTheme.tintColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: UIFont.heading!, NSAttributedStringKey.foregroundColor: currentTheme.textColor]
        
        UIApplication.shared.statusBarStyle = currentTheme.statusBarStyle
    }
    
    func updateScreenUI() {
        let tabbar = (UIApplication.shared.keyWindow?.rootViewController as? UITabBarController)?.tabBar
        tabbar?.tintColor = currentTheme.tintColor
        tabbar?.barTintColor = currentTheme.backgroundColor
        
        NotificationCenter.default.post(name: NSNotification.Name.themeChanged, object: currentTheme)
    }
}




