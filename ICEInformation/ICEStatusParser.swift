//
//  ICEStatusLoader.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 10.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import Foundation

public class ICEStatusParser {
    public init() {}
    
    public func parseDataToICETrip(data: NSData) throws -> ICETrip {
        if let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? Dictionary<String, AnyObject> {
            let trainType = jsonData["trainType"] as! String
            let trainNumber = jsonData["vzn"] as! String
            let trainstopData = jsonData["stops"] as! Array<[String: AnyObject]>
            let stops = trainstopData.map(parseDictToStation)
            let tripInfo = ICETrip(trainNumber: trainNumber, stops: stops, trainType: trainType)
            
            return tripInfo
        }
        throw ICEErrorType.Parse
    }
    

    
    public func parseDataToICEStatus(data: NSData) throws -> ICEStatus {
        if let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? Dictionary<String, AnyObject> {
            let speed = jsonData["speed"] as! Float
            let location = parseDictToLocation(jsonData)
            
            return ICEStatus(location: location, speed: speed)
        }
        throw ICEErrorType.Parse
    }
    
    //MARK: private
    
    private func parseDictToStation(data: [String: AnyObject]) -> Station {
        let stationData = data["station"] as! [String: AnyObject]
        let locationData = stationData["geocoordinates"] as! [String: AnyObject]
        let location = parseDictToLocation(locationData)
        let evaNr = stationData["evaNr"] as! String
        let name = stationData["name"] as! String
        let schedule = parseSchuldeFromData(data["timetable"] as! [String: AnyObject])
        let passendStation = parseDidPassStationFromDictionary(data["info"] as! [String: AnyObject])
        let scheduledTrack = parseScheduledTrackFromDictionary(data["track"] as! [String: AnyObject])
        
        return Station(evaNr: evaNr, name: name, passed: passendStation ,schduledTimes: schedule, location: location, track: scheduledTrack)
    }
    
    private func parseDidPassStationFromDictionary(dictionary: [String: AnyObject]) -> Bool {
        return dictionary["passed"] as! Bool
    }
    
    private func parseScheduledTrackFromDictionary(dictionary: [String: AnyObject]) -> String {
        return dictionary["scheduled"] as! String
    }
    
    private func parseDictToLocation(data: [String: AnyObject]) -> Location {
        let latitude = data["latitude"] as! Double
        let longitude = data["longitude"] as! Double
        
        return Location(latitude: latitude, longitude: longitude)
    }
    
    func parseSchuldeFromData(data: [String: AnyObject]) -> StationSchedule {
        let scheduledArrivalTime = data["scheduledArrivalTime"] as? Double
        let scheduledDepartureTime = data["scheduledDepartureTime"] as? Double
        
        let scheduledArrivalDate = NSDate(timeIntervalSince1970: (scheduledArrivalTime ?? scheduledDepartureTime!) * 0.001)
        let scheduledDepartureDate = NSDate(timeIntervalSince1970: (scheduledDepartureTime ?? scheduledArrivalTime!) * 0.001)
        
        let arrivalDelay = extractDelay(data["arrivalDelay"] as? String)
        let departureDelay = extractDelay(data["departureDelay"] as? String)
        
        return StationSchedule(arrivalTime: scheduledArrivalDate, departureTime: scheduledDepartureDate, arrivalDelay: arrivalDelay, depatureDelay: departureDelay)
    }
    
    func extractDelay(delay:String?) -> NSTimeInterval? {
        guard let delay = delay else { return nil }
        return Double(delay.stringByReplacingOccurrencesOfString("+", withString: ""))
    }
    
    
    
}
