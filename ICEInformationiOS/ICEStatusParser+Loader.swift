//
//  ICEStatusParser+Loader.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 26.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import Foundation
public extension ICEStatusParser {
    
    public func loadICEStatus(onSucces: (ICEStatus)->(), onError:(ICEErrorType)->()) {
        guard WifiCheck.isICEWifi() else {
            return onError(.WrongWifi)
        }
        let urlSession = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: statusAPIURL)
        let task = urlSession.dataTaskWithRequest(request) {data, response, error in
            guard let data = data else {
               return onError(.Network)
            }
            do {
                let iceStatus = try self.parseDataToICEStatus(data)
                dispatch_async(dispatch_get_main_queue(), {
                    onSucces(iceStatus)
                })
            } catch {
                onError(.Parse)
            }
        }
        
        task.resume()
    }
}

