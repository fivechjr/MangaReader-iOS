//
//  BetterRefreshControl.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/21.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

/// A refresh control, never stop in viewcontroller's transition
class BetterRefreshControl: UIRefreshControl {
    weak var scrollView: UIScrollView?
    
    func start(shouldAdjustOffset: Bool = false) {
        beginRefreshing()
        if shouldAdjustOffset {
            scrollView?.contentOffset = CGPoint(x: 0.0, y: -bounds.height)
        }
    }
    
    func stop(shouldAdjustOffset: Bool = false) {
        endRefreshing()
        if shouldAdjustOffset {
            scrollView?.contentOffset = CGPoint.zero
        }
    }
}
