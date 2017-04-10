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
import Sourcing

class StationOverviewViewController: UIViewController {
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    var trip: ICETrip?
    
    var dataProvider: ArrayDataProvider<Stop>!
    var dataSource: TableViewDataSource<Stop>!
    
    let networkService = NetworkService(networkAccess: URLSession(configuration: .default), endPoints: urlKeys)
    
    
    override func viewDidLoad() {
        setupDataSource()
        fetchData()
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(StationOverviewViewController.fetchData), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(StationOverviewViewController.fetchStatus), userInfo: nil, repeats: true)
    }
    
    func setupDataSource() {
        dataProvider = ArrayDataProvider(rows: [])
        dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, cell: CellConfiguration<TrainStationCell>())
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
        dataProvider.reconfigure(with: [iceTrip.passedStops, iceTrip.commingStops])
        dataProvider.headerTitles = ["Vergangene Halte", "Kommende Halte"]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let stationViewController = segue.destination as? StationViewController {
            stationViewController.stop = dataSource.selectedObject
        }
    }
}
