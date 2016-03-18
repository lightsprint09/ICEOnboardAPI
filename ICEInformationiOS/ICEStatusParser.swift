//
//  ICEStatusLoader.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 10.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import Foundation
import JSONParser

extension ICEStatus: JSONParsable {
    public init(JSON: Dictionary<String, AnyObject>) {
        self.speed = JSON["speed"] as! Float
        self.location = Location(JSON: JSON)
    }
}

extension Location: JSONParsable {
    public init(JSON: Dictionary<String, AnyObject>) {
        self.latitude = JSON["latitude"] as! Double
        self.longitude = JSON["longitude"] as! Double
    }
}

extension ICETrip: JSONParsable {
    public init(JSON: Dictionary<String, AnyObject>) {
        self.trainType = JSON["trainType"] as! String
        self.trainNumber = JSON["vzn"] as! String
        self.stops = JSON.transformToList(keyPath: "stops") ?? []
    }
}

extension Station: JSONParsable {
    public init(JSON: Dictionary<String, AnyObject>) {
        let stationData = JSON["station"] as! [String: AnyObject]
        self.location = Location(JSON: stationData["geocoordinates"] as! [String: AnyObject])
        self.evaNr = stationData["evaNr"] as! String
        self.name = stationData["name"] as! String
        self.schduledTimes = JSON.transformToObject(keyPath: "timetable")!
        self.track = JSON.transformToObject(keyPath: "track.scheduled")!
        self.passed = JSON.transformToObject(keyPath: "info.passed")!
    }
}

extension StationSchedule: JSONParsable {
    public init(JSON: Dictionary<String, AnyObject>) {
        let scheduledArrivalTime = JSON["scheduledArrivalTime"] as? Double
        let scheduledDepartureTime = JSON["scheduledDepartureTime"] as? Double
        
        self.arrivalTime = NSDate(timeIntervalSince1970: (scheduledArrivalTime ?? scheduledDepartureTime!) * 0.001)
        self.departureTime = NSDate(timeIntervalSince1970: (scheduledDepartureTime ?? scheduledArrivalTime!) * 0.001)
        
        self.arrivalDelay = extractDelay(JSON["arrivalDelay"] as? String)
        self.depatureDelay = extractDelay(JSON["departureDelay"] as? String)
    }
}


public class ICEStatusParser {
    let jsonParser: JSONParsing = JSONParser()
    public init() {
    }
    
    public func parseDataToICETrip(data: NSData) throws -> ICETrip {
        return try jsonParser.parseObject(data) as ICETrip
    }
    public func parseDataToICEStatus(data: NSData) throws -> ICEStatus {
        return try jsonParser.parseObject(data) as ICEStatus
    }
    
}

func extractDelay(delay:String?) -> NSTimeInterval? {
    guard let delay = delay,
        let delayTime = Double(delay.stringByReplacingOccurrencesOfString("+", withString: "")) else { return nil }
    return delayTime * 60
}
