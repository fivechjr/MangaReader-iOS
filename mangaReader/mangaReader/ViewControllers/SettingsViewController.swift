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
        case "Feedback":
            sendFeedBack()
        case "Share This App":
            shareApp()
        default:
            print("Not an option")
        }
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
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
    
    func sendFeedBack() {
        
        guard MFMailComposeViewController.canSendMail() else {
            view.makeToast("Sorry, Your device can not send a email.", position: .center)
//            BPStatusBarAlert.show(withMessage: "Sorry, Your device can not send a email.")
            return
        }
        
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
//        mailVC.navigationBar.tintColor = UIColor.black
        
        mailVC.setSubject("Feedback")
        
        var bundleDisplayName = "This App"
        if let bundleName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String {
            bundleDisplayName = bundleName
        }
        mailVC.setMessageBody("Please write your feedback for '\(bundleDisplayName)'：\n\n", isHTML: false)
        mailVC.setToRecipients(["dymx103@gmail.com"])
        
        present(mailVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            view.makeToast("Feedback has been sent, thank you!", position: .center)
        case .failed:
            view.makeToast("Feedback failed.", position: .center)
        default:
            break
        }
        
        controller.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func shareApp() {
        let textToShare = "I'm reading my favorite manga with Manga Monster! It's an awesome app, you should download it if you love reading manga!"
    
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
