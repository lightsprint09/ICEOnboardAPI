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
        
        networkService.request(ICETripResource(), onCompletion: { trip in
            self.destinationLabel.text = "\(trip.trainName) nach \(trip.to.station.name)"
            let nextStop = trip.commingStops.first
            let arrivaleDate = nextStop?.schduledTimes.arrivalTime
            self.nextStopArrivalLabel.text = arrivaleDate.map { TodayViewController.dateFormatter.string(from: $0)}.map { $0 + (nextStop?.schduledTimes.depatureDelay.map {" +\(Int($0 / 60))" } ?? "") }
            self.nextStopStationNameLabel.text = nextStop?.station.name
            self.nextStopPlatformLabel.text = (nextStop?.track?.actualTrack ?? nextStop?.track?.scheduledTrack).map { "Gleis " + $0 }
            self.speedLabel.isHidden = true
            
            let widgetController = NCWidgetController()
            widgetController.setHasContent(true, forWidgetWithBundleIdentifier: "de.freiraum.ICEInformation.ICEOnboardWidget")
            
        }, onError: { err in
            let widgetController = NCWidgetController()
            widgetController.setHasContent(false, forWidgetWithBundleIdentifier: "de.freiraum.ICEInformation.ICEOnboardWidget")
            print(err.localizedDescription)
            
        })
    }
    
    func reloadInformation(onCompletion doneCallback: @escaping (Bool) -> Void) {
        networkService.request(ICEStatusResource(), onCompletion: { status in
            
            if status.speed == 0.0 {
                self.speedLabel.isHidden = true
            } else {
                self.speedLabel.text = "\(Int(status.speed)) km/h"
                self.speedLabel.isHidden = false
            }
            doneCallback(true)
        }, onError: { err in
            print(err.localizedDescription)
            doneCallback(false)
        })
        
        networkService.request(ICETripResource(), onCompletion: { trip in
            self.destinationLabel.text = "\(trip.trainName) nach \(trip.to.station.name)"
            let nextStop = trip.commingStops.first
            let arrivaleDate = nextStop?.schduledTimes.arrivalTime
            self.nextStopArrivalLabel.text = arrivaleDate.map { TodayViewController.dateFormatter.string(from: $0)}.map { $0 + (nextStop?.schduledTimes.depatureDelay.map {" +\(Int($0 / 60))" } ?? "") }
            self.nextStopStationNameLabel.text = nextStop?.station.name
            self.nextStopPlatformLabel.text = (nextStop?.track?.actualTrack ?? nextStop?.track?.scheduledTrack).map { "Gleis " + $0 }
            
            let widgetController = NCWidgetController()
            widgetController.setHasContent(true, forWidgetWithBundleIdentifier: "de.freiraum.ICEInformation.ICEOnboardWidget")
            doneCallback(true)
            
        }, onError: { err in
            let widgetController = NCWidgetController()
            widgetController.setHasContent(false, forWidgetWithBundleIdentifier: "de.freiraum.ICEInformation.ICEOnboardWidget")
            print(err.localizedDescription)
            doneCallback(false)
        })
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        print("widget perform update")
        
        timer = Timer(timeInterval: 5, repeats: true, block: { timer in
            self.reloadInformation(onCompletion: { success in
                if success {
                    completionHandler(.newData)
                } else {
                    completionHandler(.failed)
                }
            })
        })
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
}
