//
//  ICETripInformation.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 25.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import Foundation

public struct Location {
    public let latitude: Double
    public let longitude: Double
}

public struct ICETripInformation {
    //public let trainType: String
    public let trainNumber: String
    public let stops: Array<Station>
}
