//
//  TrainStationCell.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 15.01.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import UIKit
import ICEInformationiOS

class TrainStationCell: UITableViewCell {
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var delayLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    
    func configureWithStation(station: Station) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        stationNameLabel.text = station.name
        if let delay = station.schduledTimes.arrivalDelay {
            delayLabel.text = "+\(Int(delay / 60))"
            delayLabel.textColor = UIColor(red:178 / 255.0, green:42 / 255.0, blue:34 / 255.0, alpha:1.0)
        }else {
            delayLabel.text = "+0"
            delayLabel.textColor = UIColor(red:93 / 255.0, green:179 / 255.0, blue:113 / 255.0, alpha:1.0)
        }
        arrivalTimeLabel.text = dateFormatter.stringFromDate(station.schduledTimes.arrivalTime)
    }
    
}
