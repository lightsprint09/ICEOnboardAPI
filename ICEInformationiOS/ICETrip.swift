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
        return stops.filter { $0.passed }
    }
    
    public var commingStops: [Station] {
        return stops.filter { !$0.passed }
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
