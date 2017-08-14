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
//  TrainConnection+JSONSerialization.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 05.04.17.
//

import Foundation
import JSONCodable

extension TrainConnection: JSONDecodable, JSONEncodable {
    public init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        trainType = try decoder.decode("trainType")
        vzn = try decoder.decode("vzn")
        trainNumber = (try decoder.decode("trainNumber") as String?) ?? try decoder.decode("lineName")
        schedule = try decoder.decode("timetable")
        track = try decoder.decode("track")
        destination = try decoder.decode("station")
    }
    
    public func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(trainType, key: "trainType")
            try encoder.encode(vzn, key: "vzn")
            try encoder.encode(trainNumber, key: "trainNumber")
            try encoder.encode(schedule, key: "timetable")
            try encoder.encode(track, key: "track")
            try encoder.encode(destination, key: "destination")
        })
    }
    
}
