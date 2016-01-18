//
//  Trip+MKAnnotations.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 15.01.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import MapKit

extension ICETrip {
    public var mapAnnotations: [MKPointAnnotation] {
        return stops.map { $0.mapAnnotation }
    }
}
