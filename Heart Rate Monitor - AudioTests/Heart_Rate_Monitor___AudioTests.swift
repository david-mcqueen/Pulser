//
//  Heart_Rate_Monitor___AudioTests.swift
//  Heart Rate Monitor - AudioTests
//
//  Created by DavidMcQueen on 15/01/2015.
//  Copyright (c) 2015 David McQueen. All rights reserved.
//

import UIKit
import XCTest

class Heart_Rate_Monitor___AudioTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testZoneChanges(){
        var user = UserHeartRate();
        
        var rest = Zone(_lower: nil, _upper: 99, _zone: HeartRateZone.Rest);
        var zone1 = Zone(_lower: 100, _upper: 119, _zone: HeartRateZone.ZoneOne);
        let zone2 = Zone(_lower: 120, _upper: 139, _zone: HeartRateZone.ZoneTwo);
        let zone3 = Zone(_lower: 140, _upper: 159, _zone: HeartRateZone.ZoneThree);
        let zone4 = Zone(_lower: 160, _upper: 179, _zone: HeartRateZone.ZoneFour);
        let zone5 = Zone(_lower: 180, _upper: 199, _zone: HeartRateZone.ZoneFive);
        let max = Zone(_lower: 200, _upper: nil, _zone: HeartRateZone.Max);
        
        
        user.Zones.append(rest);
        user.Zones.append(zone1);
        user.Zones.append(zone2);
        user.Zones.append(zone3);
        user.Zones.append(zone4);
        user.Zones.append(zone5);
        user.Zones.append(max);
        
        var currentBPM = 0;
        
        currentBPM = 100
        var newZone = user.getZoneforBPM(currentBPM)
        XCTAssertTrue(newZone == HeartRateZone.ZoneOne, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 119
        newZone = user.getZoneforBPM(currentBPM)
        XCTAssertTrue(newZone == HeartRateZone.ZoneOne, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 120
        newZone = user.getZoneforBPM(currentBPM)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.ZoneTwo, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 139
        newZone = user.getZoneforBPM(currentBPM)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.ZoneTwo, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 140
        newZone = user.getZoneforBPM(currentBPM)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.ZoneThree, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 159
        newZone = user.getZoneforBPM(currentBPM)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.ZoneThree, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 160
        newZone = user.getZoneforBPM(currentBPM)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.ZoneFour, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 179
        newZone = user.getZoneforBPM(currentBPM)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.ZoneFour, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 180
        newZone = user.getZoneforBPM(currentBPM)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.ZoneFive, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 199
        newZone = user.getZoneforBPM(currentBPM)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.ZoneFive, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 200
        newZone = user.getZoneforBPM(currentBPM)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.Max, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 219
        newZone = user.getZoneforBPM(currentBPM)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.Max, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 99
        newZone = user.getZoneforBPM(currentBPM)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.Rest, "Zone match - Pass");
        
        currentBPM = 0
        newZone = user.getZoneforBPM(currentBPM)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.Rest, "Zone match - Pass");
        
        
    }
    
}
