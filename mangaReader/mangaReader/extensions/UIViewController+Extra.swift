//
//  UIViewController+Extra.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/10/7.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import MessageUI

extension UIViewController: MFMailComposeViewControllerDelegate {
    
    var currentTheme: Theme {
        return ThemeManager.shared.currentTheme
    }
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
        mailVC.setToRecipients(["bkkdreamer001@hotmail.com"])
        
        present(mailVC, animated: true, completion: nil)
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .sent:
            view.makeToast(NSLocalizedString("feedback_success_message", comment: ""), position: .center)
        case .failed:
            view.makeToast(NSLocalizedString("feedback_failed_message", comment: ""), position: .center)
        default:
            break
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func shareApp() {
        let textToShare = NSLocalizedString("share_message", comment: "")
        
        var objectsToShare: [Any] = [textToShare]
        
        objectsToShare.append(Constants.appStoreURL)
        
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

class GesturesSharedTableView: UITableView, UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

class GesturesSharedScrollView: UIScrollView, UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
