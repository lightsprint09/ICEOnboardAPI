//
//  TrainStationCell.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 15.01.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import UIKit
import ICEInTrainAPI

class TrainStationCell: UITableViewCell {
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var delayLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter
    }()
    
    func configureWithStation(_ stop: Stop) {
        stationNameLabel.text = stop.station.name
        if let delay = stop.schduledTimes.arrivalDelay {
            delayLabel.text = "+\(Int(delay / 60))"
            delayLabel.textColor = UIColor(red:178 / 255.0, green:42 / 255.0, blue:34 / 255.0, alpha:1.0)
        }else {
            delayLabel.text = "+0"
            delayLabel.textColor = UIColor(red:93 / 255.0, green:179 / 255.0, blue:113 / 255.0, alpha:1.0)
        }
        arrivalTimeLabel.text = TrainStationCell.dateFormatter.string(from: stop.schduledTimes.arrivalTime)
    }
    
}
