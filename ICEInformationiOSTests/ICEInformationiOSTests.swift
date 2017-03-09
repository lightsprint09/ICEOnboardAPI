//
//  ICEInformationiOSTests.swift
//  ICEInformationiOSTests
//
//  Created by Lukas Schmidt on 25.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import XCTest
@testable import ICEInTrainAPI

class ICEInformationiOSTests: XCTestCase {
    
    func testParseICEStatus() {
        let data = statusDataString.data(using: String.Encoding.utf8)!
        guard let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            XCTFail()
            return
        }
        
        let iceStatus = try! ICEStatus(object: json)
        XCTAssertEqual(iceStatus.location.latitude, 49.404305)
        XCTAssertEqual(iceStatus.location.longitude, 8.547148)
        XCTAssertEqual(iceStatus.speed, 221.8000030517578)
    }
    
    func testParseICETripInformation() {
        let data = tripInforationDataString.data(using: .utf8)!
        guard let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            XCTFail()
            return
        }
        let tripInfo = try! ICETrip(object: json)
        XCTAssertEqual(tripInfo.trainNumber, "108")
        XCTAssertEqual(tripInfo.trainType, "ICE")
        XCTAssertEqual(tripInfo.stops.count, 10)
        if let firstStop = tripInfo.stops.first {
            XCTAssertEqual(firstStop.track, "12")
            XCTAssertEqual(firstStop.name, "Basel SBB")
            XCTAssertEqual(firstStop.evaNr, "8500010_00")
            XCTAssertEqual(firstStop.location.longitude, 7.589169)
            XCTAssertEqual(firstStop.location.latitude, 47.547077)
            XCTAssertEqual(firstStop.schduledTimes.departureTime, Date(timeIntervalSince1970: 1449742380000 * 0.001))
        }
        let freiburg = tripInfo.stops[2]
        XCTAssertEqual(freiburg.schduledTimes.depatureDelay, 60)
        XCTAssertTrue(freiburg.passed)
        XCTAssertEqual(freiburg.track, "1")
    }
    
}
