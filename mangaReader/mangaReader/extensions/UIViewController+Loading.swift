//
//  UIViewController+Loading.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/6.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

extension UIViewController {
    func showLoading() {
        let color = ThemeManager.shared.currentTheme.textColor
        let activityData = ActivityData(size:CGSize(width: 35, height: 35), type: .ballPulse, color: color)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    func hideLoading() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
}