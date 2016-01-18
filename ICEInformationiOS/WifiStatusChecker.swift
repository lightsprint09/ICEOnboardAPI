//
//  WifiStatusChecker.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 28.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//


import Foundation
import SystemConfiguration.CaptiveNetwork

public class WifiCheck {
    static let iceWLANSSId = "Telekom_ICE"
    public static func fetchSSIDInfo() ->  String {
        var currentSSID = ""
        if let interfaces:CFArray = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces){
                let interfaceName: UnsafePointer<Void> = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)")
                if unsafeInterfaceData != nil {
                    let interfaceData = unsafeInterfaceData! as Dictionary!
                    currentSSID = interfaceData["SSID"] as! String
                }
            }
        }
        return currentSSID
    }
    
    static func isICEWifi() -> Bool {
        let currentSSID = fetchSSIDInfo()
        return iceWLANSSId == currentSSID
    }
    
}

