//
//  AppDelegate.swift
//  mangaReader
//
//  Created by Yiming Dong on 27/03/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import FacebookCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        AdsManager.sharedInstance.initAdsConfig()
        
        DataManager.shared.loadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.checkDisclaimer()
        }
        
        return true
    }
    
    func checkDisclaimer() {
        let agreedDisclaimer = UserDefaults.standard.bool(forKey: "agreedDisclaimer")
        if (!agreedDisclaimer) {
            Utility.showDisclaimer()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEventsLogger.activate(application)
    }
}

