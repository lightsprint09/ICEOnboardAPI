//
//  ViewController.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 10.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import UIKit
import MapKit
import ICEInformationiOS

class ViewController: UIViewController {
    var trip: ICETrip?
    @IBOutlet weak var speedLabel: UILabel!
    let iceStatusLoader = ICEStatusParser()
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("fetchData"), userInfo: nil, repeats: true)
    }
    
    func fetchData() {
        iceStatusLoader.loadICEStatus({status in
            self.speedLabel.text = "\(status.speed) km/h"
            let location = status.location.locationCoordinate
            let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            self.mapView.setRegion(region, animated: true)
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = location
            dropPin.title = "ICE"
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotation(dropPin)
            }, onError: {error in
                
                print(error)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 0
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("", forIndexPath: indexPath)
//        cell.textLabel?.text = trip?.stops[indexPath.row].name
//        cell.detailTextLabel?.text = trip?.stops[indexPath.row].
//        return cell
//    }

}

