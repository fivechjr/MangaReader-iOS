//
//  BaseViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/14.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ThemeManager.shared.currentTheme.backgroundColor
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleThemeChanged(notification:)), name: NSNotification.Name.themeChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTheme()
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
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    class func newInstance() -> UIViewController? {
        let storyboardId = String(describing: self)
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: storyboardId)
    }
}

