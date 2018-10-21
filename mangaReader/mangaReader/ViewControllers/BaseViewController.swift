//
//  BaseViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/14.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleThemeChanged(notification:)), name: NSNotification.Name.themeChanged, object: nil)
    }
    
    @objc public func handleThemeChanged(notification: Notification) {
        let theme = notification.object as? Theme
        view.backgroundColor = theme?.backgroundColor
        updateTheme()
    }
    
    func updateTheme() {
        
    }

    private class var storyboardName: String {
        return "Main"
    }
    
    class var storyboardId: String? {
        return nil
    }
    
    class func newInstance() -> UIViewController? {
        guard let storyboardId = storyboardId else {return nil}
        
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: storyboardId)
    }
}

