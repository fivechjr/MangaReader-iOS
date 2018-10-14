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

