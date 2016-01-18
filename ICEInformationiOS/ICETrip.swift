//
//  ICETripInformation.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 25.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import Foundation

public struct ICETrip {
    public let trainType: String
    public let trainNumber: String
    public let stops: Array<Station>
    
    public var from: Station {
        return stops.first!
    }
    
    public var to: Station {
        return stops.last!
    }
    
    public var trainName: String {
        return trainType + trainNumber
    }
    
    public var passedStops: [Station] {
        var passedStops = [Station]()
        for (_, stop) in stops.enumerate() where stop.passed {
            passedStops.append(stop)
        }
        
        return passedStops
    }
    
    public var commingStops: [Station] {
        var commingStops = [Station]()
        for (_, stop) in stops.enumerate() where !stop.passed {
           commingStops.append(stop)
        }
        
        return commingStops
    }
    
    public init(trainNumber: String, stops: Array<Station>, trainType: String) {
        if stops.count < 2 {
            fatalError("A trip must have at least 2 stops")
        }
        self.trainNumber = trainNumber
        self.stops = stops
        self.trainType = trainType
    }
    
}
