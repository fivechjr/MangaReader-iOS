//
//  AppDelegate.swift
//  mangaReader
//
//  Created by Yiming Dong on 27/03/2018.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import FacebookCore
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        AdsManager.sharedInstance.initAdsConfig()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.checkDisclaimer()
            ThemeManager.shared.updateScreenUI()
        }
        
        ThemeManager.shared.load()
        
        KingfisherManager.shared.downloader.downloadTimeout = 60
        
        customizeUI()
        
//        checkAppVersion()
        
        return true
    }
    
    func checkAppVersion() {
        Utility.getAppStoreVersion { (version) in
            guard let version = version else {return}
            
            if Utility.shortVersionString.compare(version) == .orderedDescending {
                MangaSource.current = .lama
                print("current version is newer")
            } else {
                MangaSource.current = .mangaEden
                print("current version is same or older")
            }
        }
    }
    
    func customizeUI() {
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

