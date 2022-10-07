//
//  AppDelegate.swift
//  Example
//
//  Created by Minh Tường on 07/10/2022.
//

import UIKit
import GoogleMobileAds
import AdmobManager
import MTIAPurchase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.sharedInstance().start()
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["3bee8640fd90f80580322bc31417d55b"]
        
        MTIAPurchase.shared.completeTransactions(completion: { purchases in
            print(purchases)
        })
        
        let admobConfigs = AdmobConfiguration()
        admobConfigs.showLog = true
        admobConfigs.frequencyCapping = 4
        admobConfigs.impressionPercentage = 100
        
        AdmobManager.shared.configs = admobConfigs
        AdmobManager.shared.loadOpenAd()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

