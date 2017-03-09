//
//  ViewController.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 10.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import UIKit
import MapKit
import ICEInTrainAPI
import DBNetworkStack

class ViewController: UIViewController {
    var trip: ICETrip?
    @IBOutlet weak var speedLabel: UILabel!
    let networkService = NetworkService(networkAccess: URLSession(configuration: .default), endPoints: urlKeys)
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTrip()
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(loadTrip), userInfo: nil, repeats: true)
    }
    
    func loadTrip() {
        networkService.request(ICEStatusResource(), onCompletion: didLoadTrip, onError: { err in
            
        })
    }
        
    func didLoadTrip(status: ICEStatus) {
        speedLabel.text = "\(status.speed) km/h"
        let location = status.location.locationCoordinate
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = location
        dropPin.title = "ICE"
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(dropPin)
    }

}

