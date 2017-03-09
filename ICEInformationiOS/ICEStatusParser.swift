//
//  ICEStatusLoader.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 10.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import Foundation
import JSONCodable

extension ICEStatus: JSONDecodable {
    public init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        self.speed = try decoder.decode("speed")
        self.location = try Location(object: object)
    }
}

extension Location: JSONDecodable {
    public init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        self.latitude = try decoder.decode("latitude")
        self.longitude = try decoder.decode("longitude")
    }
}

extension ICETrip: JSONDecodable {
    public init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        self.trainType = try decoder.decode("trainType")
        self.trainNumber = try decoder.decode("vzn")
        self.stops = try decoder.decode("stops")
    }
}

extension Station: JSONDecodable {
    public init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        self.location = try decoder.decode("station.geocoordinates")
        self.evaNr = try decoder.decode("station.evaNr")
        self.name = try decoder.decode("station.name")
        self.schduledTimes = try decoder.decode("timetable")
        self.track = try decoder.decode("track.scheduled")
        self.passed = try decoder.decode("info.passed")
    }
}

extension StationSchedule: JSONDecodable {
    public init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        let scheduledArrivalTime: Double? = try decoder.decode("scheduledArrivalTime")
        let scheduledDepartureTime: Double? = try decoder.decode("scheduledDepartureTime")
        
        self.arrivalTime = Date(timeIntervalSince1970: (scheduledArrivalTime ?? scheduledDepartureTime!) * 0.001)
        self.departureTime = Date(timeIntervalSince1970: (scheduledDepartureTime ?? scheduledArrivalTime!) * 0.001)
        
        self.arrivalDelay = extractDelay(try decoder.decode("arrivalDelay"))
        self.depatureDelay = extractDelay(try  decoder.decode("departureDelay"))
    }
}


func extractDelay(_ delay:String?) -> TimeInterval? {
    guard let delay = delay,
        let delayTime = Double(delay.replacingOccurrences(of: "+", with: "")) else { return nil }
    return delayTime * 60
}
