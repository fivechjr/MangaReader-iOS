//
//  Utility.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/7.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class Utility {
    
    static func string(_ target: String, containsAny stringArray: [String], caseSensitive: Bool = false) -> Bool {
        for str in stringArray {
            if caseSensitive {
                if target.contains(str) {
                    return true
                }
            } else {
                if target.lowercased().contains(str.lowercased()) {
                    return true
                }
            }
        }
        
        return false
    }
    
    static func strings(_ targets: [String], containsAny stringArray: [String], caseSensitive: Bool = false) -> Bool {
        for target in targets {
            if string(target, containsAny: stringArray, caseSensitive: caseSensitive) {
                return true
            }
        }
        
        return false
    }
    
    static func rateApp() {
        
        if let url = URL(string: Constants.reviewURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    static func aboutApp() {
        var message = NSLocalizedString("This is an awesome manga app.", comment: "")
        if let bundleName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
            , let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            message = "\(bundleName) v\(version)"
        }
        
        let alertVC = UIAlertController(title: NSLocalizedString("About", comment: ""), message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: .default) { (action) in
        }
        
        alertVC.addAction(okAction)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
    }
    
    static func showDisclaimer() {
        let message = NSLocalizedString("disclaimer_message", comment: "")
        
        let alertVC = UIAlertController(title: NSLocalizedString("Disclaimer", comment: ""), message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("Agree", comment: ""), style: .default) { (action) in
            UserDefaults.standard.set(true, forKey: "agreedDisclaimer")
            UserDefaults.standard.synchronize()
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Disagree", comment: ""), style: .cancel) { _ in
            
            UserDefaults.standard.set(false, forKey: "agreedDisclaimer")
            UserDefaults.standard.synchronize()
            
            let message2 = NSLocalizedString("close_app_message", comment: "")
            let alertVC2 = UIAlertController(title: "", message: message2, preferredStyle: .alert)
            let okAction2 = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: .default) { _ in
                exit(0)
            }
            
            alertVC2.addAction(okAction2)
            
            UIApplication.shared.keyWindow?.rootViewController?.present(alertVC2, animated: true, completion: nil)
        }
        
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
    }
    
    static func getAppStoreVersion(completion: @escaping (String?) -> Void) {
        let urlString = "https://itunes.apple.com/lookup?id=\(Constants.appId)"
        guard let url = URL(string: urlString) else {return}
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                if let results = object??["results"] as? [[String: Any]] {
                    completion(results.first?["version"] as? String)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    static var shortVersionString: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.1"
    }
}

//+(NSString *)shortVersionString {
//    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//}

public func LocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: key)
}
