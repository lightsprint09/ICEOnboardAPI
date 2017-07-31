//
//  Copyright (C) 2017 Lukas Schmidt.
//
//  Permission is hereby granted, free of charge, to any person obtaining a 
//  copy of this software and associated documentation files (the "Software"), 
//  to deal in the Software without restriction, including without limitation 
//  the rights to use, copy, modify, merge, publish, distribute, sublicense, 
//  and/or sell copies of the Software, and to permit persons to whom the 
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in 
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
//  DEALINGS IN THE SOFTWARE.
//
//
//  FakeICENetworkAccess.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 07.04.17.
//

import Foundation
import DBNetworkStack

let statusPayload = "{\"serverTime\":1449749986439,\"speed\":221.8000030517578,\"latitude\":49.404305,\"connection\":true,\"servicelevel\":\"SERVICE\",\"longitude\":8.547148}".data(using: .utf8)

let tripInfoPayload = "{\"serverTime\":1449749986439,\"speed\":221.8000030517578,\"latitude\":49.404305,\"connection\":true,\"servicelevel\":\"SERVICE\",\"longitude\":8.547148}".data(using: .utf8)

public class FakeICENetworkAccess: NetworkAccessProviding {
    
    public init() {}
    
    public func load(request: URLRequest, callback: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) -> NetworkTaskRepresenting {
        guard let urlString = request.url?.absoluteString else {
            callback(nil, nil, nil)
            return NetworkTaskMock()
        }
        if urlString.contains("status") {
            callback(statusPayload, nil, nil)
        } else if urlString.contains("tripInfo") && !urlString.contains("connections") {
            
        }
        else {
            callback(nil, nil, nil)
        }
        return NetworkTaskMock()
    }
}
