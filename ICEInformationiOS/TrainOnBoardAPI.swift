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

public final class TrainOnBoardAPI {
    
    private let baseURL: URL
    private let iceDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }()
    
    public init(baseURL: URL = baseURLPortal) {
        self.baseURL = baseURL
    }
    
    public func status() -> Resource<ICEStatus> {
        let request = URLRequest(path: "status", baseURL: baseURL)
        
        return Resource(request: request, decoder: iceDecoder)
    }
    
    public func trip() -> Resource<ICETrip> {
        let request = URLRequest(path: "tripInfo", baseURL: baseURL)

        return Resource(request: request, decoder: iceDecoder)
    }

    public func connectionTrains(at station: Station) -> Resource<TrainConnections> {
        fatalError()
//        return connectionTrains(for: station.evaId)
    }

    public func connectionTrains(for evaId: String) -> Resource<TrainConnections> {
        fatalError()
//        let request = URLRequest(path: "tripInfo/connection/\(evaId)", baseURL: baseURL)
//
//        return Resource(resource: JSONResource(request: request))
    }

    public func firstClassOffers() -> Resource<FirstClassDeliverOffers> {
        fatalError()
//        let request = URLRequest(path: "filterTop/1259026820/0", baseURL: baseURL)
//
//        return Resource(resource: JSONResource(request: request))
    }
}
