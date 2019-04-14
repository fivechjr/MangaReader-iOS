//
//  SettingsViewModel.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/19.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

enum SettingItem {
    case disclaimer
    case feedback
    case rateUs
    case shareApp
    case aboutUs
    case changeTheme
    
    var localizedTitle: String {
        switch self {
        case .disclaimer:
            return LocalizedString("Disclaimer")
        case .feedback:
            return LocalizedString("Feedback")
        case .rateUs:
            return LocalizedString("Rate Us")
        case .shareApp:
            return LocalizedString("Share This App")
        case .aboutUs:
            return LocalizedString("About Us")
        case .changeTheme:
            return ThemeManager.shared.currentTheme.settingTitle
        }
    }
}

class SettingsViewModel {
    
    var settingItems: [SettingItem] = [.disclaimer, .feedback, .rateUs, .shareApp, .aboutUs, .changeTheme]
    
    var count: Int {
        return settingItems.count
    }
    
    subscript(index: Int) -> SettingItem? {
        guard index < count, index >= 0 else {return nil}
        return settingItems[index]
    }
}
