//
//  ICEInformationiOSTests.swift
//  ICEInformationiOSTests
//
//  Created by Lukas Schmidt on 25.12.15.
//  Copyright © 2015 Lukas Schmidt. All rights reserved.
//

import XCTest
@testable import ICEOnboardAPI

class ICEInformationiOSTests: XCTestCase {
    
    let service = TrainOnBoardAPI(baseURL: URL(string: "https://bahn.de")!)
    
    func testParseICEStatus() {
        //Given
        let data = statusDataString.data(using: .utf8)!
        let resource = service.status()
        
        
        //When
        let iceStatus = try! resource.parse(data)
        
        //Then
        XCTAssertEqual(iceStatus.location.latitude, 49.404305)
        XCTAssertEqual(iceStatus.location.longitude, 8.547148)
        XCTAssertEqual(iceStatus.speed, 221.8000030517578)
    }
    
    func testParseICETripInformation() {
        // Given
        let data = tripInforationDataString.data(using: .utf8)!
        let resource = service.trip()
        
        // When
        do {
            let tripInfo = try resource.parse(data)
            
            // Then
            XCTAssertEqual(tripInfo.trainNumber, "108")
            XCTAssertEqual(tripInfo.trainType, "ICE")
            XCTAssertEqual(tripInfo.stops.count, 10)
            if let firstStop = tripInfo.stops.first {
                XCTAssertEqual(firstStop.track?.scheduledTrack, "12")
                XCTAssertEqual(firstStop.station.name, "Basel SBB")
                XCTAssertEqual(firstStop.station.evaId, "8500010_00")
                XCTAssertEqual(firstStop.station.location!.longitude, 7.589169)
                XCTAssertEqual(firstStop.station.location!.latitude, 47.547077)
                XCTAssertEqual(firstStop.scheduledTimes.departureTime, Date(timeIntervalSince1970: 1449742380000 * 0.001))
            }
            let freiburg = tripInfo.stops[2]
            XCTAssertEqual(freiburg.scheduledTimes.depatureDelay, 60)
            XCTAssertTrue(freiburg.passed)
            XCTAssertEqual(freiburg.track?.scheduledTrack, "1")
        } catch let e {
            print(e)
            XCTFail()
        }
    }
    
}
