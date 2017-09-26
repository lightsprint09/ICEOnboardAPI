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
//  TrainConnection.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 05.04.17.
//

import Foundation

public struct TrainConnections: Decodable {
    public let connections: [TrainConnection]
}

public struct TrainConnection: Decodable {
    public let trainType: String
    public let vzn: String
    public let trainNumber: String
    public let schedule: StationSchedule
    public let track: Track?
    public let destination: Station
    
    enum CodingKeys: String, CodingKey {
        case trainType
        case vzn
        case trainNumber
        case schedule = "timetable"
        case track
        case destination = "station"
    }
//    
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        trainType = try container.decode(String.self, forKey: .trainType)
//        vzn = try container.decode(String.self, forKey: .vzn)
//        trainNumber = try container.decode(String.self, forKey: .trainNumber)
//        schedule = try container.decode(StationSchedule.self, forKey: .schedule)
//        track = try container.decode(Track.self, forKey: .track)
//        destination = try container.decode(Station.self, forKey: .destination)
//    }

}
