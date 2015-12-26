//
//  ICEInformationiOSTests.swift
//  ICEInformationiOSTests
//
//  Created by Lukas Schmidt on 25.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import XCTest
@testable import ICEInformationiOS

class ICEInformationiOSTests: XCTestCase {
    let statusLoader = ICEStatusLoader()
    
    func testParseICEStatus() {
        let data = statusDataString.dataUsingEncoding(NSUTF8StringEncoding)!
        let iceStatus = statusLoader.parseDataToICEStatus(data)
        XCTAssertEqual(iceStatus.latitude, 49.404305)
        XCTAssertEqual(iceStatus.longitude, 8.547148)
        XCTAssertEqual(iceStatus.speed, 221.8000030517578)
        
    }
    
    func testParseICETripInformation() {
        let data = tripInforationDataString.dataUsingEncoding(NSUTF8StringEncoding)!
        let tripInfo = statusLoader.parseDataToICETrip(data)
        XCTAssertEqual(tripInfo.stops.count, 10)
        print(tripInfo)
    }
    
}
