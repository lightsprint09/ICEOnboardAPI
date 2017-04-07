//
//  StationViewController.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 15.01.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import UIKit
import ICEInTrainAPI
import MapKit

class StationViewController: UIViewController {
    var stop: Stop!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    @IBOutlet weak var arrivalDelayLabel: UILabel!
    @IBOutlet weak var depatureLabel: UILabel!
    @IBOutlet weak var departureDelayLabel: UILabel!
    
    override func viewDidLoad() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let mapAnotation = stop.station.mapAnnotation, let location = stop.station.location {
            mapView.addAnnotation(mapAnotation)
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: location.locationCoordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
        
        title = stop.station.name
        
        trackLabel.text = stop.track?.scheduledTrack
        arrivalLabel.text = dateFormatter.string(from: stop.schduledTimes.arrivalTime)
        depatureLabel.text = dateFormatter.string(from: stop.schduledTimes.departureTime)
        setDelayTimeAtLabel(arrivalDelayLabel, delay: stop.schduledTimes.arrivalDelay)
        setDelayTimeAtLabel(departureDelayLabel, delay: stop.schduledTimes.depatureDelay)
    }
    
    func setDelayTimeAtLabel(_ lable: UILabel, delay: TimeInterval?) {
        if let delay = delay {
            lable.text = "+\(Int(delay / 60))"
            lable.textColor = UIColor(red:178 / 255.0, green:42 / 255.0, blue:34 / 255.0, alpha:1.0)
        }else {
            lable.text = "+0"
            lable.textColor = UIColor(red:93 / 255.0, green:179 / 255.0, blue:113 / 255.0, alpha:1.0)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let connectionTrainsViewController = segue.destination as? ConnectingTrainViewController {
         connectionTrainsViewController.station = stop.station
        }
    }
}
