//
//  SettingsViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/4/27.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import RealmSwift
import MessageUI
import Toast_Swift

class SettingsViewController: UIViewController {

    var settingItems: [String] = [
        NSLocalizedString("Disclaimer", comment: "")
        , NSLocalizedString("Feedback", comment: "")
        , NSLocalizedString("Rate Us", comment: "")
        , NSLocalizedString("Share This App", comment: "")
        , NSLocalizedString("About Us", comment: "")]
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
        case NSLocalizedString("Disclaimer", comment: ""):
            SettingsViewController.showDisclaimer()
        case NSLocalizedString("Rate Us", comment: ""):
            SettingsViewController.rateApp()
        case NSLocalizedString("Feedback", comment: ""):
            sendFeedBack()
        case NSLocalizedString("Share This App", comment: ""):
            shareApp()
        case NSLocalizedString("About Us", comment: ""):
            SettingsViewController.aboutApp()
        default:
            print("Not an option")
        }
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    static func rateApp() {
        
        let appId = "1378089411"
        
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
    
    func sendFeedBack() {
        
        guard MFMailComposeViewController.canSendMail() else {
            view.makeToast(NSLocalizedString("cant_send_email_message", comment: ""), position: .center)
//            BPStatusBarAlert.show(withMessage: "Sorry, Your device can not send a email.")
            return
        }
        
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
//        mailVC.navigationBar.tintColor = UIColor.black
        
        mailVC.setSubject(NSLocalizedString("Feedback", comment: ""))
        
        var bundleDisplayName = NSLocalizedString("This App", comment: "")
        if let bundleName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String {
            bundleDisplayName = bundleName
        }
        mailVC.setMessageBody("\(NSLocalizedString("Please write your feedback", comment: "")) - '\(bundleDisplayName)'：\n\n", isHTML: false)
        mailVC.setToRecipients(["dymx103@gmail.com"])
        
        present(mailVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            view.makeToast(NSLocalizedString("feedback_success_message", comment: ""), position: .center)
        case .failed:
            view.makeToast(NSLocalizedString("feedback_failed_message", comment: ""), position: .center)
        default:
            break
        }
        
        controller.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func shareApp() {
        let textToShare = NSLocalizedString("share_message", comment: "")
    
        var objectsToShare: [Any] = [textToShare]
        
        if let appId = Bundle.main.bundleIdentifier
            , let reviewURL = URL(string: "https://itunes.apple.com/app/id\(appId)") {
            
            objectsToShare.append(reviewURL)
        }
        
        if let iconImage = UIImage(named: "icon_share") {
            objectsToShare.append(iconImage)
        }
        
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        //New Excluded Activities Code
        activityVC.excludedActivityTypes = [.airDrop, .addToReadingList, .openInIBooks]
        //
        
        activityVC.popoverPresentationController?.sourceView = view
        activityVC.popoverPresentationController?.sourceRect = CGRect(x: view.frame.size.width * 0.5, y: view.frame.size.height * 0.5, width: 1.0, height: 1.0)
        
        present(activityVC, animated: true, completion: nil)
    }
}
