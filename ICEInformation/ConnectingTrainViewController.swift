//
//  Copyright (C) 2017 Lukas Schmidt.
//
//  Permission is hereby granted, free of charge, to any person obtaining a 
//  copy of this software and associated documentation files (the "Software"), 
//  to deal in the Software without restriction, including without limitation 
//  the rights to use, copy, modify, merge, publish, distribute, sublicense, 
//  and/or sell copies of the Software, and to permit persons to whom the 
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in 
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
//  DEALINGS IN THE SOFTWARE.
//
//
//  ConnectingTrainViewController.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 05.04.17.
//

import UIKit
import DBNetworkStack
import ICEOnboardAPI

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    
    return formatter
}()


class ConnectingTrainViewController: UITableViewController {
    var station: Station!
    var connections: TrainConnections?
    let networkService = NetworkService(networkAccess: URLSession(configuration: .default))
    let trainOnBoardAPI = TrainOnBoardAPI()
    
    override func viewDidLoad() {
        networkService.request(trainOnBoardAPI.connectionTrains(at: station), onCompletion: { connections in
            self.connections = connections
            self.tableView.reloadData()
        }, onError: { error in
        
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connections?.connections.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainConnectionCell", for: indexPath)
        if let connection = connections?.connections[indexPath.row] {
            cell.textLabel?.text = "\(dateFormatter.string(from: connection.schedule.departureTime)) \(connection.trainType) \(connection.trainNumber) nach \(connection.destination.name)"
            cell.detailTextLabel?.text = connection.track?.actualTrack ?? connection.track?.scheduledTrack
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Anschlusszüge"
    }
}
