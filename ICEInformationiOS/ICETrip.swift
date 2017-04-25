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
    public let stops: Array<Stop>
    
    public var from: Stop {
        return stops.first!
    }
    
    public var to: Stop {
        return stops.last!
    }
    
    public var trainName: String {
        return trainType + " " + trainNumber
    }
    
    public var passedStops: [Stop] {
        return stops.filter { $0.passed }
    }
    
    public var commingStops: [Stop] {
        return stops.filter { !$0.passed }
    }
    
    public var nextStop: Stop? {
        return commingStops.first
    }
    
    public init(trainNumber: String, stops: [Stop], trainType: String) {
        if stops.count < 2 {
            fatalError("A trip must have at least 2 stops")
        }
        self.trainNumber = trainNumber
        self.stops = stops
        self.trainType = trainType
    }
}
