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
    
    var textColor: UIColor {
        switch self {
        case .light:
            return UIColor.black
        case .dark:
            return UIColor.white
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
}

class ThemeManager {
    private init(){
        let savedThemeId = (UserDefaults.standard.value(forKey: key_currentTheme) as? Int) ?? Theme.light.rawValue
        let savedTheme = Theme(rawValue: savedThemeId) ?? Theme.light
        currentTheme = savedTheme
    }
    static var shared = ThemeManager()
    
    let key_currentTheme = "currentTheme"
    
    var currentTheme: Theme = .light {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: key_currentTheme)
            handleThemeChanged(currentTheme: currentTheme)
        }
    }
    
    func handleThemeChanged(currentTheme: Theme) {

        UINavigationBar.appearance().barTintColor = currentTheme.backgroundColor
        UINavigationBar.appearance().tintColor = currentTheme.tintColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: currentTheme.textColor]
        
        UIApplication.shared.statusBarStyle = currentTheme.statusBarStyle
//        switch currentTheme {
//        case .light:
//            UINavigationBar.appearance().backgroundColor = .white
//            UINavigationBar.appearance().barTintColor = .white
//        case .dark:
//            UINavigationBar.appearance().backgroundColor = .black
//            UINavigationBar.appearance().barTintColor = .black
//        }
        NotificationCenter.default.post(name: NSNotification.Name.themeChanged, object: currentTheme)
    }
}




