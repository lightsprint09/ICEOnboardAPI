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
    let statusLoader = ICEStatusParser()
    
    func testParseICEStatus() {
        let data = statusDataString.dataUsingEncoding(NSUTF8StringEncoding)!
        let iceStatus = try! statusLoader.parseDataToICEStatus(data)
        XCTAssertEqual(iceStatus.location.latitude, 49.404305)
        XCTAssertEqual(iceStatus.location.longitude, 8.547148)
        XCTAssertEqual(iceStatus.speed, 221.8000030517578)
    }
    
    func testParseICETripInformation() {
        let data = tripInforationDataString.dataUsingEncoding(NSUTF8StringEncoding)!
        let tripInfo = try! statusLoader.parseDataToICETrip(data)
        XCTAssertEqual(tripInfo.trainNumber, "108")
        XCTAssertEqual(tripInfo.trainType, "ICE")
        XCTAssertEqual(tripInfo.stops.count, 10)
        if let firstStop = tripInfo.stops.first {
            XCTAssertEqual(firstStop.track, "12")
            XCTAssertEqual(firstStop.name, "Basel SBB")
            XCTAssertEqual(firstStop.evaNr, "8500010_00")
            XCTAssertEqual(firstStop.location.longitude, 7.589169)
            XCTAssertEqual(firstStop.location.latitude, 47.547077)
            XCTAssertEqual(firstStop.schduledTimes.departureTime, NSDate(timeIntervalSince1970: 1449742380000 * 0.001))
        }
        let freiburg = tripInfo.stops[2]
        XCTAssertEqual(freiburg.schduledTimes.depatureDelay, 60)
        XCTAssertTrue(freiburg.passed)
        XCTAssertEqual(freiburg.track, "1")
    }
    
}
