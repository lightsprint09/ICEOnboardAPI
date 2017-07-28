//
//  ICEStatusURLRessources.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 26.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import Foundation
import DBNetworkStack

let baseURLPortal = URL(string: "https://portal.imice.de/api1/rs/")!

extension ICEStatus: JSONMappable { }
extension ICETrip: JSONMappable { }
extension TrainConnections: JSONMappable { }
extension FirstClassDeliverOffers: JSONMappable { }

public final class TrainOnBoardAPI {
    
    private let baseURL: URL
    
    public init(baseURL: URL = baseURLPortal) {
        self.baseURL = baseURL
    }
    
    public func status() -> Resource<ICEStatus> {
        let request = URLRequest(path: "status", baseURL: baseURL)
        
        return Resource(resource: JSONResource(request: request))
    }
    
    public func trip() -> Resource<ICETrip> {
        let request = URLRequest(path: "tripInfo", baseURL: baseURL)
        
        return Resource(resource: JSONResource(request: request))
    }
    
    public func connectionTrains(at station: Station) -> Resource<TrainConnections> {
        return connectionTrains(for: station.evaId)
    }
    
    public func connectionTrains(for evaId: String) -> Resource<TrainConnections> {
        let request = URLRequest(path: "tripInfo/connection/\(evaId)", baseURL: baseURL)
        
        return Resource(resource: JSONResource(request: request))
    }
    
    public func firstClassOffers() -> Resource<FirstClassDeliverOffers> {
        let request = URLRequest(path: "filterTop/1259026820/0", baseURL: baseURL)
        
        return Resource(resource: JSONResource(request: request))
    }
}
