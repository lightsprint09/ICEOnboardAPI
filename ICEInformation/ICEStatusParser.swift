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
    
    public func parseDataToICETrip(data: NSData) -> ICETripInformation {
        do {
            if let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? Dictionary<String, AnyObject> {
                let train = jsonData["trainType"] as! String
                let trainstopData = jsonData["stops"] as! Array<[String: AnyObject]>
                let stops = trainstopData.map(parseDictToStation)
                let tripInfo = ICETripInformation(trainNumber: train, stops: stops)
                
                return tripInfo
            }
        }
        catch {}
        fatalError("Worng JSON data")
    }
    
    public func parseDataToICEStatus(data: NSData) -> ICEStatus {
        do {
            if let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? Dictionary<String, AnyObject> {
                let latitude = jsonData["latitude"] as! Double
                let longitude = jsonData["longitude"] as! Double
                let speed = jsonData["speed"] as! Float
                let location = Location(latitude: latitude, longitude: longitude)
                
                return ICEStatus(location: location, speed: speed)
            }
        }
        catch {}
        fatalError("Worng JSON data")
    }
    
    //MARK: private
    
    private func parseDictToStation(data: [String: AnyObject]) -> Station {
        let stationData = data["station"] as! [String: AnyObject]
        let evaNr = stationData["evaNr"] as! String
        let name = stationData["name"] as! String
        
        return Station(evaNr: evaNr, name: name)
    }
    
//    func parseSchuldeFromData(data: [String: AnyObject]) -> StationSchedule {
//        let track = data["track"] as! String
//        let schedule = data["timetable"] as! [String: AnyObject]
//        let arrivalTime = schedule["scheduledArrivalTime"] as! Int
//        
//        
//    }
    
    
    
}
