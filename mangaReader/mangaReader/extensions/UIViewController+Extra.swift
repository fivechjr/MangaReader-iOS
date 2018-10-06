//
//  UIViewController+Extra.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/7.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

extension UIViewController {
    @objc func farewell() {
        if let presentingViewController = presentingViewController {
            
            presentingViewController.dismiss(animated: true, completion: nil)
            
        } else if let navigationController = navigationController {
            
            if let presentingViewController = navigationController.presentingViewController {
                presentingViewController.dismiss(animated: true, completion: nil)
            } else {
                navigationController.popViewController(animated: true)
            }
        }
    }
}
