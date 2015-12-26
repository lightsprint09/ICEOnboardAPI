//
//  ICETripInformation.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 25.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import Foundation

public struct StationSchedule{
    let track: String
    let arrivalTime: NSDate
    let departureTime: NSDate
    
    let arrivalDelay: NSTimeInterval?
    let depatureDelay: NSTimeInterval?
}

public struct Station {
    let evaNr: String
    let name: String
    //let passed: Bool
    //let schduledTimes: StationSchedule
    //let location: Location
}

public struct Location {
    let longitude: Float
    let latitude: Float
}

public struct ICETripInformation {
    let trainNumber: String
    let stops: Array<Station>
}
