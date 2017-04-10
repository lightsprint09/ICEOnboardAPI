//
//  TodayViewController.swift
//  ICEOnboardWidget
//
//  Created by Lukas Schmidt on 07.04.17.
//  Copyright © 2017 Lukas Schmidt. All rights reserved.
//

import UIKit
import NotificationCenter
import DBNetworkStack
import ICEInTrainAPI


class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var nextStopArrivalLabel: UILabel!
    @IBOutlet weak var nextStopStationNameLabel: UILabel!
    @IBOutlet weak var nextStopPlatformLabel: UILabel!
    
    let networkService: NetworkServiceProviding = NetworkService(networkAccess: URLSession(configuration: .default), endPoints: urlKeys)
     var timer: Timer?
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer(timeInterval: 5, repeats: true, block: { timer in
            self.reloadInformation()
        })
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    
    func reloadInformation() {
        networkService.request(ICEStatusResource(), onCompletion: { status in
            self.speedLabel.text = "\(Int(status.speed)) km/h"
        }, onError: { err in
        })
        
        networkService.request(ICETripResource(), onCompletion: { trip in
            self.destinationLabel.text = "\(trip.trainName) nach \(trip.to.station.name)"
            let nextStop = trip.commingStops.first
            let arrivaleDate = nextStop?.schduledTimes.arrivalTime
            self.nextStopArrivalLabel.text = arrivaleDate.map { TodayViewController.dateFormatter.string(from: $0)}.map { $0 + (nextStop?.schduledTimes.depatureDelay.map {" +\(Int($0 / 60))" } ?? "") }
            self.nextStopStationNameLabel.text = nextStop?.station.name
            self.nextStopPlatformLabel.text = (nextStop?.track?.actualTrack ?? nextStop?.track?.scheduledTrack).map { "Gleis " + $0 }
        }, onError: { err in
        })
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(.noData)
//        networkService.request(ICEStatusResource(), onCompletion: { status in
//            self.speedLabel.text = "\(status.speed) km/h"
//            completionHandler(.newData)
//        }, onError: { err in
//            completionHandler(.failed)
//        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
}
