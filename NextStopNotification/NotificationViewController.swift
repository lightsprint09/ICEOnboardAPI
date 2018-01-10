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

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    let networkService: NetworkService = BasicNetworkService(networkAccess: URLSession(configuration: .default))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        print("hallo")
        guard let connection = notification.request.content.userInfo["payload"] as? TrainConnections else { return }
        label?.text = connection.connections.first?.destination.name
        
    }

}
