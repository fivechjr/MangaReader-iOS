//
//  SettingsViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/4/27.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import RealmSwift

class SettingsViewController: UIViewController {

    var settingItems: [String] = ["Disclaimer", "Feedback", "Rate Us", "Share This App", "About Us"]
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = settingItems[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = settingItems[indexPath.row]
        
        switch title {
        case "Disclaimer":
            SettingsViewController.showDisclaimer()
        case "Rate Us":
            SettingsViewController.rateApp()
        default:
            print("Not an option")
        }
    }
}

extension SettingsViewController {
    static func rateApp() {
        
        guard let appId = Bundle.main.bundleIdentifier else {
            return
        }
        
        let templateReviewURLiOS8 = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=DYM_APP_ID&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"
        var reviewURL = templateReviewURLiOS8.replacingOccurrences(of: "DYM_APP_ID", with: appId)
        
        if #available(iOS 11.0, *) {
            reviewURL = "https://itunes.apple.com/app/id\(appId)"
        }
        
        if let url = URL(string: reviewURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    static func showDisclaimer() {
        let message = "All manga, characters and logos belong to their respective copyrights owners. Manga Monster is developed independently and does not have any affiliation with the content providers. We reserve the right to change the source of manga without prior notice."
        
        let alertVC = UIAlertController(title: "Disclaimer", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Agree", style: .default) { (action) in
            UserDefaults.standard.set(true, forKey: "agreedDisclaimer")
            UserDefaults.standard.synchronize()
        }
        
        let cancelAction = UIAlertAction(title: "Disagree", style: .cancel) { _ in
            
            UserDefaults.standard.set(false, forKey: "agreedDisclaimer")
            UserDefaults.standard.synchronize()
            
            let message2 = "Sorry, we have to close the app because you disagreed with the disclaimer."
            let alertVC2 = UIAlertController(title: "", message: message2, preferredStyle: .alert)
            let okAction2 = UIAlertAction(title: "Okay", style: .default) { _ in
                exit(0)
            }
            
            alertVC2.addAction(okAction2)
            
            UIApplication.shared.keyWindow?.rootViewController?.present(alertVC2, animated: true, completion: nil)
        }
        
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
    }
}
