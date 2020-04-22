//
//  SettingsViewController.swift
//  chattingApp
//
//  Created by Duale on 3/18/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import UIKit
import GoogleMobileAds
import FirebaseAuth

class SettingsViewController: UIViewController , GADBannerViewDelegate   {
    
    var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
    
    @IBAction func logOutClicked(_ sender: UIButton) {
        FireBaseManager.shared.signOut()
         let curUser = Auth.auth().currentUser
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let mainVc = storyBoard.instantiateViewController(identifier: "MainViewController") as? MainViewController else {
           return
        }
        UIApplication.shared.keyWindow?.rootViewController = mainVc
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
         bannerView.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(bannerView)
         view.addConstraints(
           [NSLayoutConstraint(item: bannerView,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: bottomLayoutGuide,
                               attribute: .top,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: bannerView,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .centerX,
                               multiplier: 1,
                               constant: 0)
           ])
        }

       /// Tells the delegate an ad request loaded an ad.
   //    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
   //      print("adViewDidReceiveAd")
   //    }

       /// Tells the delegate an ad request failed.
       func adView(_ bannerView: GADBannerView,
           didFailToReceiveAdWithError error: GADRequestError) {
         print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
       }
       
       func adViewDidReceiveAd(_ bannerView: GADBannerView) {
         bannerView.alpha = 0
         UIView.animate(withDuration: 1, animations: {
           bannerView.alpha = 1
         })
       }
       
       /// Tells the delegate that a full-screen view will be presented in response
       /// to the user clicking on an ad.
       func adViewWillPresentScreen(_ bannerView: GADBannerView) {
         print("adViewWillPresentScreen")
       }

       /// Tells the delegate that the full-screen view will be dismissed.
       func adViewWillDismissScreen(_ bannerView: GADBannerView) {
         print("adViewWillDismissScreen")
       }

       /// Tells the delegate that the full-screen view has been dismissed.
       func adViewDidDismissScreen(_ bannerView: GADBannerView) {
         print("adViewDidDismissScreen")
       }
       /// Tells the delegate that a user click will open another app (such as
       /// the App Store), backgrounding the current app.
       func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
         print("adViewWillLeaveApplication")
       }

    
}
