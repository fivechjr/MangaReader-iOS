//
//  Notification+Name.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/19.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    private static let prefix = "com.dymx101.mangamonster.notification."
    static let themeChanged = NSNotification.Name(prefix + "themeChanged")
}
