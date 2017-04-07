//
//  Station+MKAnotation.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 15.01.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import MapKit

extension Station {
    public var mapAnnotation: MKPointAnnotation? {
        guard let locationCoordinate = location?.locationCoordinate else {
            return nil
        }
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = locationCoordinate
        dropPin.title = name
        
        return dropPin
    }
}
