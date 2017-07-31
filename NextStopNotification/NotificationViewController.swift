//
//  NotificationViewController.swift
//  NextStopNotification
//
//  Created by Lukas Schmidt on 24.04.17.
//  Copyright © 2017 Lukas Schmidt. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import DBNetworkStack
import ICEOnboardAPI
import JSONCodable

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    let networkService: NetworkServiceProviding = NetworkService(networkAccess: URLSession(configuration: .default))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        print("hallo")
        guard let object = notification.request.content.userInfo["payload"] as? [String: Any] else { return }
        let connection = try! TrainConnections(object: object)
        label?.text = connection.connections.first?.destination.name
        
    }

}
