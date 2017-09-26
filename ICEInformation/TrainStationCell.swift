//
//  TrainStationCell.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 15.01.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import UIKit
import ICEOnboardAPI
import Sourcing

class TrainStationCell: UITableViewCell, ConfigurableCell {
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var delayLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter
    }()
    
    func configure(with stop: Stop) {
        stationNameLabel.text = stop.station.name
        let delay = stop.scheduledTimes.arrivalDelay ?? 0
        delayLabel.text = "+\(Int(delay / 60))"
        delayLabel.textColor = delay >= 5 ? .delayedRed : .inTimeGreen
        arrivalTimeLabel.text = stop.scheduledTimes.arrivalTime.map( {TrainStationCell.dateFormatter.string(from: $0) } )
    }
}

extension TrainStationCell: CellIdentifierProviding {}
