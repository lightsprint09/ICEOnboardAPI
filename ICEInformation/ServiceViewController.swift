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

import UIKit
import DBNetworkStack
import ICEOnboardAPI
import Sourcing


class ServiceViewController: UITableViewController {
    
    let networkService = NetworkService(networkAccess: URLSession(configuration: .default))
    var dataSource: TableViewDataSource<Buyable>!
    var dataProvider: ArrayDataProvider<Buyable>!
    let trainOnBoardAPI = TrainOnBoardAPI()
    
    override func viewDidLoad() {
        tableView.estimatedRowHeight = 55
        tableView.rowHeight = UITableViewAutomaticDimension
        let firstClassOffers = trainOnBoardAPI.firstClassOffers()
        let cell = CellConfiguration<BuyableCell>()
        dataProvider = ArrayDataProvider(rows: [])
        dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, cell: cell)
        networkService.request(firstClassOffers, onCompletion: {[weak self] offers in
            self?.dataProvider.reconfigure(with: offers.food)
        }, onError: { err in
            print(err)
        })
    }
}
