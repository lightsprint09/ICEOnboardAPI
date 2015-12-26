//
//  ICEStatusURLRessources.swift
//  ICEInformation
//
//  Created by Lukas Schmidt on 26.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import Foundation

let baseURL = NSURL(string: "http://ice.portal2/jetty/api/v1/")
let statusAPIURL = NSURL(string: "status", relativeToURL: baseURL)!
let tripInfoURL = NSURL(string: "tripInfo", relativeToURL: baseURL)!
