//
//  Station.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 26.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import Foundation

public struct StationSchedule: Decodable {
    public let arrivalTime: Date?
    public let departureTime: Date?
    
    public let arrivalDelay: TimeInterval?
    public let depatureDelay: TimeInterval?
    
    enum CodingKeys: String, CodingKey {
        case arrivalTime = "scheduledArrivalTime"
        case departureTime = "scheduledDepartureTime"
        case arrivalDelay
        case depatureDelay = "departureDelay"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        arrivalTime = try container.decode(Date?.self, forKey: .arrivalTime)
        departureTime = try container.decode(Date?.self, forKey: .departureTime)
        
        arrivalDelay = extractDelay(try container.decode(String.self, forKey: .arrivalDelay))
        depatureDelay = extractDelay(try container.decode(String.self, forKey: .depatureDelay))
    }
}

func extractDelay(_ delay:String?) -> TimeInterval? {
    guard let delay = delay,
        let delayTime = Double(delay.replacingOccurrences(of: "+", with: "")) else { return nil }
    return delayTime * 60
}

public struct Station: Decodable {
    public let evaId: String
    public let name: String
    public let location: Location?
    
    enum CodingKeys: String, CodingKey {
        case evaId = "evaNr"
        case name
        case location = "geocoordinates"
    }
}
