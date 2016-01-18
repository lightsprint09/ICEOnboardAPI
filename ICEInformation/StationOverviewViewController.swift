//
//  StationOverviewViewController.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 15.01.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import UIKit
import MapKit
import ICEInformationiOS

class StationOverviewViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    var trip: ICETrip?
    
    let tripParser = ICEStatusParser()
    
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tripParser.loadICETrip(didSuceedTripLoad, onError: {_ in})
        NSTimer.scheduledTimerWithTimeInterval(20, target: self, selector: Selector("fetchData"), userInfo: nil, repeats: true)
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("fetchStatus"), userInfo: nil, repeats: true)
    }
    
    func fetchStatus() {
        tripParser.loadICEStatus(didSuceedStatusLoad, onError: {error in
            print(error)
        })
    }
    
    func fetchData() {
        tripParser.loadICETrip(didSuceedTripLoad, onError: {_ in})
    }
    
    func didSuceedStatusLoad(iceStatus: ICEStatus) {
        speedLabel.text = "\(iceStatus.speed)km/h"
    }
    
    func didSuceedTripLoad(iceTrip: ICETrip) {
        title = iceTrip.trainName
        mapView.addAnnotations(iceTrip.mapAnnotations)
        trip = iceTrip
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let trip = trip else { return 0 }
        if section == 0 {
            return trip.passedStops.count
        }
        return trip.commingStops.count
    }
    
    func stopAtIndexPath(indexPath: NSIndexPath) -> Station? {
        if indexPath.section == 0 {
            return trip?.passedStops[indexPath.row]
        }
        return trip?.commingStops[indexPath.row]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("trainstation-cell", forIndexPath: indexPath)
        guard let stationCell = cell as? TrainStationCell, let stop = stopAtIndexPath(indexPath) else { return cell }
        stationCell.configureWithStation(stop)
        
        return stationCell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Passed Stops"
        }
        return "Next Stops"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let stationViewController = segue.destinationViewController as? StationViewController, let indexPath = sender as? UITableViewCell {
            stationViewController.station = stopAtIndexPath(tableView.indexPathForCell(indexPath)!)!
        }
    }
}
