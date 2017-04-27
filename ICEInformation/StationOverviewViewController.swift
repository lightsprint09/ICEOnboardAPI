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
import NotificationCenter
import UserNotifications


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
        fetchStatus()
        NCWidgetController().setHasContent(true, forWidgetWithBundleIdentifier: "de.freiraum.ICEInformation.ICEOnboardWidget")
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
        dataProvider.headerTitles = ["Vergangene Halte", "Kommende Halte"]
        dataProvider.reconfigure(with: [iceTrip.passedStops, iceTrip.commingStops])
        guard let nextStop = iceTrip.nextStop, let indexPath = dataProvider.indexPath(for: nextStop) else {
            return
        }
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        if #available(iOS 10.0, *) {
            scheduleNotification(at: nextStop)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func registerNotifications() {
        
    }
    var registerdNextStop: Stop?
    @available(iOS 10.0, *)
    func scheduleNotification(at nextStop: Stop) {
        guard registerdNextStop != nextStop else {
            return
        }
        registerdNextStop = nextStop
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(accepted, error) in
            if !accepted {
                print("Notification access denied.")
            }
        }
        let category = UNNotificationCategory(identifier: "NextStop", actions: [], intentIdentifiers: [], options: .customDismissAction)
        UNUserNotificationCenter.current().setNotificationCategories([category])
        let calendar = Calendar(identifier: .gregorian)
        let date = Date().addingTimeInterval(60)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute, second: components.second)
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "Nächster Halt"
        content.body = "Um \(dateFormatter.string(from: nextStop.schduledTimes.arrivalTime.addingTimeInterval(nextStop.schduledTimes.arrivalDelay ?? 0))) erreichen wir \(nextStop.station.name)."
        
        content.categoryIdentifier = "NextStop"
        
        content.sound = UNNotificationSound.default()
        let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
        networkService.request(ConnectingTrains(at: nextStop.station), onCompletion: { connections in
            content.userInfo = ["evaId": try! nextStop.station.toJSON(), "payload": try! connections.toJSON()]
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().add(request) {(error) in
                if let error = error {
                    print("Uh oh! We had an error: \(error)")
                }
            }
        }, onError: {_ in })
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let stationViewController = segue.destination as? StationViewController {
            stationViewController.stop = dataSource.selectedObject
        }
    }
}
