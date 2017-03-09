//
//  StationOverviewViewController.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 15.01.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import UIKit
import MapKit
import ICEInTrainAPI
import DBNetworkStack

class StationOverviewViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    var trip: ICETrip?
    
    let networkService = NetworkService(networkAccess: URLSession(configuration: .default), endPoints: urlKeys)
    
    
    override func viewDidLoad() {
        tableView.dataSource = self
        
        fetchData()
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(StationOverviewViewController.fetchData), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(StationOverviewViewController.fetchStatus), userInfo: nil, repeats: true)
    }
    
    func fetchStatus() {
        let resource = ICEStatusResource()
        networkService.request(resource, onCompletion: didSuceedStatusLoad, onError: { error in
            print(error)
        })
    }
    
    func fetchData() {
        let resource = ICETripResource()
        networkService.request(resource, onCompletion: didSuceedTripLoad, onError: { error in
            print(error)
        })
    }
    
    func didSuceedStatusLoad(_ iceStatus: ICEStatus) {
        speedLabel.text = "\(iceStatus.speed)km/h"
    }
    
    func didSuceedTripLoad(_ iceTrip: ICETrip) {
        title = iceTrip.trainName
        mapView.addAnnotations(iceTrip.mapAnnotations)
        trip = iceTrip
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let trip = trip else { return 0 }
        if section == 0 {
            return trip.passedStops.count
        }
        return trip.commingStops.count
    }
    
    func stopAtIndexPath(_ indexPath: NSIndexPath) -> Station? {
        if indexPath.section == 0 {
            return trip?.passedStops[indexPath.row]
        }
        return trip?.commingStops[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trainstation-cell", for: indexPath)
        guard let stationCell = cell as? TrainStationCell, let stop = stopAtIndexPath(indexPath as NSIndexPath) else { return cell }
        stationCell.configureWithStation(stop)
        
        return stationCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Passed Stops"
        }
        return "Next Stops"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let stationViewController = segue.destination as? StationViewController, let indexPath = sender as? UITableViewCell {
            stationViewController.station = stopAtIndexPath(tableView.indexPath(for: indexPath)! as NSIndexPath)!
        }
    }
}
