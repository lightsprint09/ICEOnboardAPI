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
//  Stop.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 05.04.17.
//

import Foundation

public struct Stop {
    public let station: Station
    public let passed: Bool
    public let scheduledTimes: StationSchedule
    public let track: Track?
}

extension Stop: Decodable {
    enum CodingKeys: String, CodingKey {
        case station
        case info
        case scheduledTimes = "timetable"
        case track
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        station = try container.decode(Station.self, forKey: .station)
        scheduledTimes = try container.decode(StationSchedule.self, forKey: .scheduledTimes)
        track = try container.decode(Track.self, forKey: .track)
        let info = try container.decode(Info.self, forKey: .info)
        passed = info.passed
    }
}

struct Info: Decodable {
    public let passed: Bool
}

extension Stop: Equatable { }

public func ==(lhs: Stop, rhs: Stop) -> Bool {
    return lhs.station.evaId == rhs.station.evaId
}

