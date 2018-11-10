//
//  Font+Custom.swift
//  mangaReader
//
//  Created by Yiming Dong on 24/10/18.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

extension UIFont {
    
    static let heading = customFont(type: .gilroySemibold, size: 20)
    static let title = customFont(type: .gilroySemibold, size: 18)
    static let button = customFont(type: .sfProTextRegular, size: 16)
    static let content = customFont(type: .sfProTextRegular, size: 14)
    
    enum CustomFontType: String {
        case sfProTextRegular = "SFProText-Regular"
        case gilroySemibold = "Gilroy-SemiBold"
    }
    
    static func customFont(type: CustomFontType, size: CGFloat) -> UIFont? {
        return UIFont(name: type.rawValue, size: size)
    }
}
