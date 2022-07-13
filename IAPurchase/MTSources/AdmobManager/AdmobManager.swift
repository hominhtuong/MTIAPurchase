//
//  AdmobManager.swift
//  IAPurchase
//
//  Created by Minh Tường on 13/07/2022.
//
#if canImport(GoogleMobileAds)
import GoogleMobileAds
import UIKit

public class AdmobManager: NSObject {
    public static let shared = AdmobManager()
    
    private var interstitial: GADInterstitialAd?
    private var appOpenAd: GADAppOpenAd?
    
    private var interstitialHasBeenShow: Bool = false
    private var interstitialLoading: Bool = false
    private var lastDate = Date().timeIntervalSince1970
    
    //Configs
    public var configs: AdmobConfigs = AdmobConfigs()
    
    public var isProversion: Bool {
        get {
            return UserDefaults.standard.bool(forKey: configs.kStorageProversion)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: configs.kStorageProversion)
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    public func loadInterstitial() {
        if self.isProversion {return}
        if self.interstitial != nil {return}
        if self.interstitialLoading {return}
        self.interstitialLoading = true
        print("requesting ads mod.....")
        GADInterstitialAd.load(withAdUnitID: configs.interstitialAdUnitID, request: GADRequest(), completionHandler: { [self] ad,error in
            self.interstitialLoading = false
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
            self.interstitialHasBeenShow = false
        })
    }
    
    public func canShowAd() -> Bool {
        return self.interstitial != nil
    }
    
    public func showInterstitial(withPercent percent: Int = 100) {
        if self.isProversion {return}
        let date = Date().timeIntervalSince1970
        let diff = date - self.lastDate
        if diff < configs.timeBetweenInterstitial {
            print("mới vừa show ads xong: \(diff)")
            return
        }
        let randomPercent = Int.random(in: 0...99)
        print("config: \(percent), random: \(randomPercent)")
        if randomPercent < percent {
            if let ad = self.interstitial {
                print("showing ads mod....")
                if let topViewController = self.topViewController {
                    self.interstitialHasBeenShow = true
                    ad.present(fromRootViewController: topViewController)
                    self.lastDate = Date().timeIntervalSince1970
                }
            } else {
                print("interstitial is nil")
                self.loadInterstitial()
            }
        } else {
            print("Hên quá, ads sẽ không show")
        }
    }

}


//MARK: Open Ads
extension AdmobManager: GADFullScreenContentDelegate {
    func requestAppOpenAd() {
        if self.isProversion {return}
        print("request ads")
        self.appOpenAd = nil
        let request = GADRequest()
        GADAppOpenAd.load(withAdUnitID: configs.openAdUnitID, request: request, orientation: .portrait, completionHandler: { appOpenAd, error in
            if error != nil {
                //print("Failed to load app open ad: \(error?.localizedDescription ?? "")")
                return
            }
            self.appOpenAd = appOpenAd
            self.appOpenAd?.fullScreenContentDelegate = self
        })
    }
    
    func showAppOpenAd() {
        if self.isProversion {return}
        print("show ad")
        if let ad = self.appOpenAd {
            if let topViewController = topViewController {
                ad.present(fromRootViewController: topViewController)
            }
        } else {
            print("request new ad")
            self.requestAppOpenAd()
        }
    }
    
    //MARK: Delegate
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("didFailToPresentFullScreenCContentWithError: \(error.localizedDescription)")
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("adDidPresentFullScreenContent")
    }
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        print("GADFullScreenPresentingAd")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("adDidDismissFullScreenContent")
        if self.interstitialHasBeenShow {
            self.interstitial = nil
            self.loadInterstitial()
            self.interstitialHasBeenShow = false
        }
    }
}

extension AdmobManager {
    private var topViewController: UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
}
#endif
