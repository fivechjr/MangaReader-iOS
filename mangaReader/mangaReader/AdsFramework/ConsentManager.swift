//
//  ConsentManager.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/7/7.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation
import GoogleMobileAds
import PersonalizedAdConsent

class ConsentManager {
    
    private var adRetryDelay = 1.0
    private var allowPersonalizedAds = true
    
    func requestConsentInfoUpdate() {
        PACConsentInformation.sharedInstance.requestConsentInfoUpdate(forPublisherIdentifiers: ["pub-0123456789012345"])
        {(_ error: Error?) -> Void in
            if let _ = error {
                DispatchQueue.main.asyncAfter(delay: self.adRetryDelay, closure: self.requestConsentInfoUpdate)
            } else {
                if PACConsentInformation.sharedInstance.isRequestLocationInEEAOrUnknown {
                    let consent = PACConsentInformation.sharedInstance.consentStatus
                    if consent == .unknown {
                        DispatchQueue.main.async {
                            self.collectAdsConsent()
                        }
                    } else {
                        self.allowPersonalizedAds = consent == .personalized
                        DispatchQueue.main.async {
                            self.loadAd()
                        }
                    }
                } else {
                    self.allowPersonalizedAds = true
                    DispatchQueue.main.async {
                        self.loadAd()
                    }
                }
            }
        }
    }
    
    private func collectAdsConsent() {
        guard let privacyUrl = URL(string: "https://github.com/piscoTech/Workout/blob/master/PRIVACY.md"),
            let form = PACConsentForm(applicationPrivacyPolicyURL: privacyUrl) else {
                fatalError("Incorrect privacy URL.")
        }
        
        form.shouldOfferPersonalizedAds = true
        form.shouldOfferNonPersonalizedAds = true
        form.shouldOfferAdFree = false
        
        form.load { err in
            if err != nil {
                DispatchQueue.main.asyncAfter(delay: self.adRetryDelay, closure: self.requestConsentInfoUpdate)
            } else {
                DispatchQueue.main.async {
                    guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {return}
                    
                    form.present(from: viewController) { err, adsFree in
                        if err != nil {
                            DispatchQueue.main.asyncAfter(delay: self.adRetryDelay, closure: self.requestConsentInfoUpdate)
                        } else {
                            self.allowPersonalizedAds = !adsFree && PACConsentInformation.sharedInstance.consentStatus == .personalized
                            DispatchQueue.main.async {
                                self.loadAd()
                                if adsFree {
                                    // 用户想使用“去广告版本”
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func loadAd() {
        
    }
    
    func getAdRequest() -> GADRequest {
        let req = GADRequest()
        req.testDevices = [kGADSimulatorID, "28298224a065cc39eb8972e045c6f77a"]
        if !allowPersonalizedAds {
            let extras = GADExtras()
            extras.additionalParameters = ["npa": "1"]
            req.register(extras)
        }
        return req
    }
}

extension DispatchQueue {
    
    /// The default global queue with `background` priority.
    public static let background = DispatchQueue.global(qos: .background)
    /// The default global queue with `userInitiated` priority. Use it for task initiated by the user that requires immediate results or continuous user interaction.
    public static let userInitiated = DispatchQueue.global(qos: .userInitiated)
    /// The default global queue with `userInitiated` priority. Use it for task initiated by the user that needs to be done immediately, the amount of work in this queue should be minimal.
    public static let userInteractive = DispatchQueue.global(qos: .userInteractive)
    
    public func asyncAfter(delay t: Double, closure: @escaping () -> Void) {
        self.asyncAfter(deadline: DispatchTime.now() + t, execute: closure)
    }
    
}
