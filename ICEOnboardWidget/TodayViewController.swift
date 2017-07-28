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
import ICEOnboardAPI


class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var nextStopArrivalLabel: UILabel!
    @IBOutlet weak var nextStopStationNameLabel: UILabel!
    @IBOutlet weak var nextStopPlatformLabel: UILabel!
    
    let widgetController: NCWidgetController? = nil
    let widgetBundleIDentifier = "de.freiraum.ICEInformation.ICEOnboardWidget"
    let trainOnBoardAPI = TrainOnBoardAPI()
    
    let networkService: NetworkServiceProviding = NetworkService(networkAccess: URLSession(configuration: .default))
     var timer: Timer?
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService.request(trainOnBoardAPI.trip(), onCompletion: { trip in
            self.setICETripUI(trip: trip)

            self.widgetController?.setHasContent(true, forWidgetWithBundleIdentifier: self.widgetBundleIDentifier)
            
        }, onError: { err in
            self.widgetController?.setHasContent(false, forWidgetWithBundleIdentifier: self.widgetBundleIDentifier)
            print(err)
            
        })
    }
    
    func setICETripUI(trip: ICETrip) {
        destinationLabel.text = "\(trip.trainName) nach \(trip.to.station.name)"
        let nextStop = trip.commingStops.first
        let arrivaleDate = nextStop?.schduledTimes.arrivalTime
        nextStopArrivalLabel.text = arrivaleDate.map { TodayViewController.dateFormatter.string(from: $0)}.map { $0 + (nextStop?.schduledTimes.depatureDelay.map {" +\(Int($0 / 60))" } ?? "") }
        nextStopStationNameLabel.text = nextStop?.station.name
        nextStopPlatformLabel.text = (nextStop?.track?.actualTrack ?? nextStop?.track?.scheduledTrack).map { "Gleis " + $0 }
    }
    
    func reloadInformation(onCompletion doneCallback: @escaping (Bool) -> Void) {
        networkService.request(trainOnBoardAPI.status(), onCompletion: { status in
            self.speedLabel.text = "\(Int(status.speed)) km/h"
            doneCallback(true)
        }, onError: { err in
            print(err)
            doneCallback(false)
        })
        
        networkService.request(trainOnBoardAPI.trip(), onCompletion: { trip in
           self.setICETripUI(trip: trip)
            
            self.widgetController?.setHasContent(true, forWidgetWithBundleIdentifier: self.widgetBundleIDentifier)
            doneCallback(true)
            
        }, onError: { err in
            self.widgetController?.setHasContent(false, forWidgetWithBundleIdentifier: self.widgetBundleIDentifier)
            print(err)
            doneCallback(false)
        })
    }
    
    @IBAction func didTapNextStation(_ sender: Any) {
        //extensionContext?.open(<#T##URL: URL##URL#>, completionHandler: nil)
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
