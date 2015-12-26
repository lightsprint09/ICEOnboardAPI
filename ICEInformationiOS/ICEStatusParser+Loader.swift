//
//  ICEStatusParser+Loader.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 26.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import Foundation

public extension ICEStatusParser {
    public func loadICEStatus(onSucces: (ICEStatus)->(), onError:(NSError)->()) {
        let urlSession = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: statusAPIURL)
        let task = urlSession.dataTaskWithRequest(request) {data, response, error in
            guard let data = data else {
                let finalError = error ?? NSError(domain: "", code: 0, userInfo: nil)
                onError(finalError)
                return
            }
            let iceStatus = self.parseDataToICEStatus(data)
            dispatch_async(dispatch_get_main_queue(), {
                onSucces(iceStatus)
            })
            
        }
        
        task.resume()
    }
}

