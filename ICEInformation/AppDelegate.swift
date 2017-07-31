//
//  AppDelegate.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 10.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if let localNotificationInfo = launchOptions?[.remoteNotification] as? UILocalNotification {
            if let something = localNotificationInfo.userInfo!["evaId"] as? [String: Any] {
                print(something)
            }
            
            
        }
        
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        if let something = userInfo["evaId"] as? [String: Any] {
            print(something)
        }
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        print(notification.userInfo)
        if let something = notification.userInfo?["evaId"] as? [String: Any] {
            print(something)
        }
    }

}

