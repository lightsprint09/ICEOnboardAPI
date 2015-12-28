//
//  Station.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 26.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import Foundation
public struct StationSchedule{
//    let track: String
    public let arrivalTime: NSDate
    public let departureTime: NSDate
    
//    let arrivalDelay: NSTimeInterval?
//    let depatureDelay: NSTimeInterval?
}

public struct Station {
    public let evaNr: String
    public let name: String
    //let passed: Bool
    let schduledTimes: StationSchedule
    public let location: Location
}