//
//  AdsManager.swift
//  NBVideoViewer
//
//  Created by Dong, Yiming (Agoda) on 10/22/2559 BE.
//  Copyright © 2559 Dong, Yiming (Agoda). All rights reserved.
//

import UIKit
import GoogleMobileAds
import UnityAds

/// 广告类型
enum AdsType: Int {
    case admob = 0
    case vungle
    case unity
    
    case count
}

let defaultAdsJsonString = "{ " +
"version\":1, " +
"maxFreeReadCount\":20,  " +
"enableBaiduReadCount\":1, " +
"intervalToShowAds\":600, " +
"cb_app_id\": \"54b2794004b0167ddb366e00\", " +
"cb_app_sign\": \"98629ca1ebbf6ecab5dbad8df22eb288f61d7b96\", " +
"vungle_app_id\": \"566437d827af870935000017\", " +
"unity_app_id\": \"95451\", " +
"apps\": " +
"{ " +
    "com.dymx.default\": " +
    "{ " +
        "app_name\":\"默认设定\", " +
        "admob_id\":\"\", " +
        "ads_enabled\":true, " +
        "admob_enabled\":true, " +
        "cb_enabled\":false, " +
        "vungle_enabled\":true, " +
        "unity_enabled\":true, " +
        "chapter_change_ads\":\"admob\", " +
        "unity_weight\":10, " +
        "vungle_weight\":5, " +
        "admob_weight\":10, " +
        "cb_weight\":0 " +
    "} " +
"} " +
"}"

open class AdsManager: NSObject
, GADBannerViewDelegate, GADInterstitialDelegate
, VungleSDKDelegate
, UnityAdsDelegate {
    
    var interstitial: GADInterstitial?
//    var needToShowedInterstitial = false
    
    var isInterstitialReady = false
    var isVungleStarted = false
    var weights = [AdsType]()
    
    /// 广告配置信息
    var appInfo: [String: AnyObject]?
    
    var lastAdsShowTime: Date?
    
    var vungleAppID: String?
    var unityAppID: String?
    var vunglePlacementID: String?
    var admob_banner_id: String?
    
    private let consentManager = ConsentManager()
    
    static let sharedInstance = AdsManager()
    
    fileprivate override init() {
//        needToShowedInterstitial = true
        vungleAppID = "566437d827af870935000017" // 盗墓笔记的ID
        vunglePlacementID = "DEFAULT38465"
        unityAppID = "95451"
        admob_banner_id = "ca-app-pub-7635376757557763/1563828618"
    }
    
    func adsEnabled(withType type: AdsType) -> Bool {
        var key: String! = "undefined"
        switch type {
        case .admob:
            key = "admob_enabled"
        case .vungle:
            key = "vungle_enabled"
        case .unity:
            key = "unity_enabled"
        default:
            break
        }
        
        return appInfo?[key] as? Bool ?? false
    }
    
    func initVungle() {
        
        guard adsEnabled(withType: .vungle)
            , let vungleAppID = vungleAppID
            , let vunglePlacementID = vunglePlacementID else {
            return
        }
        
        // Vungle Ads
        try? VungleSDK.shared().start(withAppId: vungleAppID, placements: [vunglePlacementID])
        VungleSDK.shared().delegate = self
        VungleSDK.shared().muted = true
    }
    
    func initUnity() {
        
        guard adsEnabled(withType: .unity), let unityAppID = unityAppID else {
            return
        }
        
        // init UnityAds
        UnityAds.initialize(unityAppID, delegate: self)
    }
    
//    func newRequest() -> GADRequest {
//        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID, "28298224a065cc39eb8972e045c6f77a"]
//        return request
//    }
    
    func requestAdmobInterstitial() {
        if let admobID = appInfo?["admob_id"] as? String , adsEnabled(withType: .admob) {
            interstitial = GADInterstitial(adUnitID: admobID)
            interstitial?.delegate = self
            interstitial?.load(consentManager.getAdRequest())
        }
    }
}

// MARK: Show Ads
extension AdsManager {
    // 产生随机广告类型
    func randomAdsType() -> AdsType {
        let index = arc4random_uniform(UInt32(weights.count))
        return weights[Int(index)]
    }
    
    /// 展示随机广告
    func showRandomAds() {
    #if DEBUG
//        return
    #endif
        // 如果禁用广告，则不弹
        guard let adsEnabled = appInfo?["ads_enabled"] as? Bool , adsEnabled else {
            return
        }
        
        var adsType = randomAdsType()
        var maxTry = 100, currentTry = 0
        let failedTypes = NSMutableSet()
        while !showAdsByType(adsType) {
            failedTypes.add(Int(adsType.rawValue))
            if failedTypes.count >= AdsType.count.rawValue || currentTry > maxTry {
                // 所有类型广告都失败了, 或是超过最大尝试次数，则退出循环
                break
            }
            
            adsType = randomAdsType()
            currentTry += 1
        }
    }
    
    
    func showVungleAds() -> Bool {
        guard adsEnabled(withType: .vungle)
            , let topVC = AdsManager.topMostVC() , canShowVungleWithTopVC(topVC)
            , let vunglePlacementID = vunglePlacementID
            , let _ = try? VungleSDK.shared().playAd(topVC, options: nil, placementID: vunglePlacementID) else {
                
            return false
        }
        
        print("Start showing 'Vungle' Ad")
        
        self.lastAdsShowTime = Date()
        
        return true
    }
    
    func canShowVungleWithTopVC(_ topVC: UIViewController) -> Bool {
        guard let vunglePlacementID = vunglePlacementID else {
            return false
        }
        return isTopVcAvailable(topVC) && VungleSDK.shared().isAdCached(forPlacementID: vunglePlacementID)
    }
    
    func showUnityAds() -> Bool {
        guard adsEnabled(withType: .unity)
            , let topVC = AdsManager.topMostVC()
            , UnityAds.isReady() else {
            return false
        }
        
        UnityAds.show(topVC)
        
        self.lastAdsShowTime = Date()
        
        return true
    }
    
    func isTopVcAvailable(_ topVC: UIViewController?) ->Bool {
        if let topVC = topVC {
            return !(topVC is UIAlertController) && !(topVC is SKStoreProductViewController)
        }
        
        return false
    }
    
    /// 展示Admob广告
    func showAdMobAds() -> Bool {
        
        if adsEnabled(withType: .admob)
            , let topVC = AdsManager.topMostVC()
             , interstitial?.isReady ?? false
            && isTopVcAvailable(topVC) {
            
            interstitial?.present(fromRootViewController: topVC)
            print("Start showing 'Admob' Ad")
            self.lastAdsShowTime = Date()
            
            return true
        }
        
        return false
    }
    
    func showRandomAdsIfComfortable() {
        if isComfortableToShowAds() {
//            showRandomAds()
        }
    }
    
    /// 是否是显示广告的良好时机
    func isComfortableToShowAds() -> Bool {
        // 用户在前台，距上次弹广告超过10分钟 --> 弹广告
        return UIApplication.shared.applicationState == .active
        && lastAdsShowsBefore(UserDefaults.standard.double(forKey: "intervalToShowAds"))
    }
    
    /// 距离上次广告显示时间，超过指定的秒数
    func lastAdsShowsBefore(_ secondsAgo: Double) -> Bool {
        
        guard let lastShowTime = lastAdsShowTime else {
            return true
        }
        
        let interval = Date().timeIntervalSince(lastShowTime)
        print("Actual Interval: \(interval), expected: \(secondsAgo)")
        
        return interval > secondsAgo
    }
    
    /// 切换章节，显示广告
    func showChapterChangeAds() -> Bool {
        guard let chapterChangeAdsType = appInfo?["chapter_change_ads"] as? String else {
            return showVungleAds()
        }
        
        switch chapterChangeAdsType {
        case "admob":
            return showAdMobAds()
        case "vungle":
            return showVungleAds()
        case "unity":
            return showUnityAds()
        case "cb":
            return showAdMobAds()
        default:
            return showVungleAds()
        }
    }
    
    func showAdsByType(_ adsType: AdsType) -> Bool {
        var showed = false
        switch adsType {
        case .admob:
            showed = showAdMobAds()
        case .vungle:
            showed = showVungleAds()
        case .unity:
            showed = showUnityAds()
        default:
            break
        }
        
        if showed {
//            needToShowedInterstitial = false
//            GlobalSettings.shared.lastTimeShowAds = Date()
        }
        
        return showed
    }
    
    static func topMostVC() -> UIViewController? {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while let presnetedVC = topVC?.presentedViewController {
            topVC = presnetedVC
        }
        return topVC
    }
}

// MARK: Admob delegate
extension AdsManager {
    
    public func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("\(#function)")
    }
    
    public func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("\(#function)")
    }
    
    public func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("\(#function)")
    }
    
    public func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("\(#function)")
    }
    
    public func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.requestAdmobInterstitial()
    }
    
    public func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("Got Admob Ad")
    }
    
    public func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to get Admob Ad: \(error)")
    }
}

// MARK: Vungle delegate
extension AdsManager {
    public func vungleSDKDidInitialize() {
        print("\(#function)")
    }
    
    public func vungleSDKFailedToInitializeWithError(_ error: Error) {
        print("\(#function)")
    }
    
    public func vungleWillShowAd(forPlacementID placementID: String?) {
        print("\(#function)")
    }
    
    public func vungleWillCloseAd(with info: VungleViewInfo, placementID: String) {
        print("\(#function)")
    }
    
    public func vungleAdPlayabilityUpdate(_ isAdPlayable: Bool, placementID: String?) {
        print("vungle ads can play: \(isAdPlayable), placementID: \(placementID ?? "")")
    }
    
    static func getJsonFromURL(_ urlString: String!, cacheFileName: String?, completion: @escaping ((AnyObject?)->Void)) {
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let request = NSMutableURLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData;
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let data = data, var json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject? else {
                completion(nil)
                return
            }
            
            // 缓存到本地
            if let cacheFileName = cacheFileName , cacheFileName.count > 0
                , let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as NSString? {
                
                let filePath = docPath.appendingPathComponent(cacheFileName)
                
                if let json = json as? NSDictionary { // 如果有数据，就更新缓存
                    json.write(toFile: filePath, atomically: true)
                } else { // 否则读缓存
                    json = NSDictionary(contentsOfFile: filePath)
                }
            }
            
            completion(json)
        }
        
        task.resume()
    }
}

// MARK: Unity delegate
extension AdsManager {
    public func unityAdsReady(_ placementId: String) {
        print("\(#function)")
    }
    
    public func unityAdsDidStart(_ placementId: String) {
        print("\(#function)")
    }
    
    public func unityAdsDidError(_ error: UnityAdsError, withMessage message: String) {
        print("\(#function)")
    }
    
    public func unityAdsDidFinish(_ placementId: String, with state: UnityAdsFinishState) {
        print("\(#function)")
    }
}

// MARK: Ads configuration
extension AdsManager {
    
    func initAdsConfig() {
        getAdsConfig { (json) in
            var jsonObject = json
            if jsonObject == nil {
                jsonObject = self.defaultLocalAdsSetting()
            }
            
            guard let jsonDic = jsonObject as? [String: AnyObject]
                , let bundleID = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
                , let appsInfo = jsonDic["apps"] as? [String: AnyObject] else {
                    return
            }
            
            let thisAppInfo = appsInfo[bundleID] ?? appsInfo["com.dymx.default"]
            print("This App Info:\n \(String(describing: thisAppInfo))")
            
            if let vungleAppId = jsonDic["vungle_app_id"] as? String {
                self.vungleAppID = vungleAppId
            }
            
            if let unityAppID = jsonDic["unity_app_id"] as? String {
                self.unityAppID = unityAppID
            }
            
            if let admob_banner_id = jsonDic["admob_banner_id"] as? String {
                self.admob_banner_id = admob_banner_id;
            }
            
            if let intervalToShowAds = jsonDic["intervalToShowAds"] as? Double {
                UserDefaults.standard.set(intervalToShowAds, forKey: "intervalToShowAds")
                UserDefaults.standard.synchronize()
            }
            
            DispatchQueue.main.async(execute: {
                self.appInfo = thisAppInfo as? [String: AnyObject];
                self.updateAdsSettingsWithAppInfo(self.appInfo)
                
                
                self.consentManager.requestConsentInfoUpdate({ (success) in
                    if success {
                        self.requestAdmobInterstitial()
                    }
                })
                
                self.initVungle()
                self.initUnity()
            })
        }
    }
    
    func getAdsConfig(_ completion: @escaping (AnyObject?)->Void) {
        
        AdsManager.getJsonFromURL("http://df-16.com:8080/static/dym_config/reader_app_cfg_dymx102.json", cacheFileName: "app_config.plist") { (json) in
            
            guard let json = json else {
                AdsManager.getJsonFromURL("http://dymx102.github.io/PhotoMagicSite/reader_app_cfg_dymx102.json", cacheFileName: "app_config.plist", completion: completion)
                return
            }
            
            completion(json)
        }
        
    }
    
    func defaultLocalAdsSetting() -> AnyObject? {
        if let data = defaultAdsJsonString.data(using: String.Encoding.utf8)
        , let defaultSettingObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
            return defaultSettingObject as AnyObject?
        }
        
        return nil
    }
    
    func updateAdsSettingsWithAppInfo(_ appInfo: [String: AnyObject]?) {
        var weights = [AdsType]()
        
        let admob_weight = appInfo?["admob_weight"] as? Int ?? 0
        var cb_weight = appInfo?["cb_weight"] as? Int ?? 0
        let vungle_weight = appInfo?["vungle_weight"] as? Int ?? 0
        let unity_weight = appInfo?["unity_weight"] as? Int ?? 0
        
        if admob_weight == 0 && cb_weight == 0
            && vungle_weight == 0 && unity_weight == 0{
            cb_weight = 5
        }
        
        for _ in 0..<admob_weight {
            weights.append(.admob)
        }
        
        for _ in 0..<vungle_weight {
            weights.append(.vungle)
        }
        
        for _ in 0..<unity_weight {
            weights.append(.unity)
        }
        
        self.weights = weights
    }
}
