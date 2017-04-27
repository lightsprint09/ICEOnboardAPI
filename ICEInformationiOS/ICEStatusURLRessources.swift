//
//  ICEStatusURLRessources.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 26.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import Foundation
import DBNetworkStack

let baseURLKey = "INTrainBaseURLKey"
let baseURL = URL(string: "https://portal.imice.de/api1/rs/")!
public let urlKeys: [String: URL] = [baseURLKey: baseURL]
let statusAPIURL = URL(string: "status", relativeTo: baseURL)!
let tripInfoURL = URL(string: "tripInfo", relativeTo: baseURL)!

extension ICEStatus: JSONMappable { }
extension ICETrip: JSONMappable { }
extension TrainConnections: JSONMappable { }
extension FirstClassDeliverOffers: JSONMappable { }

public func ICEStatusResource() -> Resource<ICEStatus> {
    let request = NetworkRequest(path: "status", baseURLKey: "INTrainBaseURLKey")
    
    return JSONResource(request: request).wrapped()
}

public func ICETripResource() -> Resource<ICETrip> {
    let request = NetworkRequest(path: "tripInfo", baseURLKey: "INTrainBaseURLKey")
    
    return JSONResource(request: request).wrapped()
}

public func ConnectingTrains(at station: Station) -> Resource<TrainConnections> {
    return ConnectingTrains(for: station.evaId)
}

public func ConnectingTrains(for evaId: String) -> Resource<TrainConnections> {
    let request = NetworkRequest(path: "tripInfo/connection/\(evaId)", baseURLKey: "INTrainBaseURLKey")
    
    return JSONResource(request: request).wrapped()
}

public func FirstClassOffer() -> Resource<FirstClassDeliverOffers> {
    let request = NetworkRequest(path: "filterTop/1259026820/0", baseURLKey: "INTrainBaseURLKey")
    
    return JSONResource(request: request).wrapped()
}
