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
//  StationSchedule+JSONSerialization.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 05.04.17.
//

import Foundation
import JSONCodable

extension StationSchedule: JSONDecodable, JSONEncodable {
    public init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        let scheduledArrivalTime: Double? = try decoder.decode("scheduledArrivalTime")
        let scheduledDepartureTime: Double? = try decoder.decode("scheduledDepartureTime")
        
        arrivalTime = Date(timeIntervalSince1970: (scheduledArrivalTime ?? scheduledDepartureTime!) * 0.001)
        departureTime = Date(timeIntervalSince1970: (scheduledDepartureTime ?? scheduledArrivalTime!) * 0.001)
        
        arrivalDelay = extractDelay(try decoder.decode("arrivalDelay"))
        depatureDelay = extractDelay(try  decoder.decode("departureDelay"))
    }
    
    public func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(arrivalTime.timeIntervalSinceReferenceDate, key: "scheduledArrivalTime")
            try encoder.encode(departureTime.timeIntervalSinceReferenceDate, key: "scheduledArrivalTime")
            try encoder.encode(arrivalDelay, key: "arrivalDelay")
            try encoder.encode(depatureDelay, key: "depatureDelay")
        })
    }
}


func extractDelay(_ delay:String?) -> TimeInterval? {
    guard let delay = delay,
        let delayTime = Double(delay.replacingOccurrences(of: "+", with: "")) else { return nil }
    return delayTime * 60
}
