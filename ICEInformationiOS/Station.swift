//
//  Station.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 26.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import Foundation
public struct StationSchedule{
    public let arrivalTime: NSDate
    public let departureTime: NSDate
    
    let arrivalDelay: NSTimeInterval?
    let depatureDelay: NSTimeInterval?
}

public struct Station {
    public let evaNr: String
    public let name: String
    public let passed: Bool
    public let schduledTimes: StationSchedule
    public let location: Location
    public let track: String
}