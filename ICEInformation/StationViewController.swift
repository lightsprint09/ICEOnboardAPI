//
//  StationViewController.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 15.01.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import UIKit
import ICEOnboardAPI
import MapKit

extension UIColor {
    static let delayedRed = UIColor(red: 178 / 255, green: 42 / 255, blue: 34 / 255, alpha: 1)
    
    static let inTimeGreen = UIColor(red: 93 / 255, green: 179 / 255, blue: 113 / 255, alpha: 1)
}

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
        arrivalLabel.text = stop.scheduledTimes.arrivalTime.map( {dateFormatter.string(from: $0) } )
        depatureLabel.text = stop.scheduledTimes.departureTime.map( {dateFormatter.string(from: $0) } ) 
        setDelayTimeAt(lable: arrivalDelayLabel, delay: stop.scheduledTimes.arrivalDelay)
        setDelayTimeAt(lable: departureDelayLabel, delay: stop.scheduledTimes.depatureDelay)
    }
    
    func setDelayTimeAt(lable : UILabel, delay: TimeInterval?) {
        let delay = stop.scheduledTimes.arrivalDelay ?? 0
        lable.text = "+\(Int(delay / 60))"
        lable.textColor = delay >= 5 ? .delayedRed : .inTimeGreen
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let connectionTrainsViewController = segue.destination as? ConnectingTrainViewController {
         connectionTrainsViewController.station = stop.station
        }
    }
}
