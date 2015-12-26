//
//  ViewController.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 10.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import UIKit
import ICEInformationiOS

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let iceStatusLoader = ICEStatusLoader()
        iceStatusLoader.loadICEStatus({status in
            
            }, onError: {error in
                
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

