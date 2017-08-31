//
//  ICEStatus.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 25.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import Foundation

public struct ICEStatus {
    public let location: Location
    public let speed: Float
}

extension ICEStatus: Decodable {
    enum CodingKeys: String, CodingKey {
        case speed = "speed"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        speed = try container.decode(Float.self, forKey: .speed)
        location = try Location(from: decoder)
    }
}
