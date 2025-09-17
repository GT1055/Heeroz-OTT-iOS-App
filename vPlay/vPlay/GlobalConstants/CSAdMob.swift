//
//  CSAdMob.swift
//  vPlay
//
//  Created by user on 26/02/21.
//  Copyright © 2021 user. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

protocol CSAdMobDelegate: class {
    func didAdDismissed()
}

class CSAdMob: NSObject {
    static let shared = CSAdMob()
    var interstitial: GADInterstitial!
    weak var delegate: CSAdMobDelegate?
    private override init() {
        super.init()
    }
    func requestInterstitialAds() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-5072889448887445/5098596439")
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
    }
}
extension CSAdMob: GADInterstitialDelegate {
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
      print("Interstitial ad loaded.")
    }

    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("Interstitial ad failed to load with error: \(error.localizedDescription)")
    }
    
    /// Tells the delegate failed to present.
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Interstitial Fail to present screen.")
        delegate?.didAdDismissed()
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
      print("Interstitial ad will be presented.")
    }

    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
      print("Interstitial ad will be dismissed.")
    }

    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("Interstitial ad dismissed.")
        delegate?.didAdDismissed()
    }
}
