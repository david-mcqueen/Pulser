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
    
    
    func testisValidBPM(){
        XCTAssertTrue(isValidBPM("098"), "Valid BPM");
        XCTAssertTrue(isValidBPM("0"), "Valid BPM");
        XCTAssertTrue(isValidBPM("999"), "Valid BPM");
        XCTAssertTrue(isValidBPM("08"), "Valid BPM");
        XCTAssertTrue(isValidBPM("123"), "Valid BPM");
        XCTAssertTrue(isValidBPM("5"), "Valid BPM");
        
        XCTAssertFalse(isValidBPM("098a"), "Invalid BPM");
        XCTAssertFalse(isValidBPM("a"), "Invalid BPM");
        XCTAssertFalse(isValidBPM("098-"), "Invalid BPM");
        XCTAssertFalse(isValidBPM("0/"), "Invalid BPM");
        XCTAssertFalse(isValidBPM("0986"), "Invalid BPM");
        XCTAssertFalse(isValidBPM("098678656647"), "Invalid BPM");
        XCTAssertFalse(isValidBPM("-9"), "Invalid BPM");
        XCTAssertFalse(isValidBPM(" "), "Invalid BPM");
    }
    
    func testallZoneInputsValid(){
        XCTAssertTrue(allZoneInputsValid(["9", "8"]), "All zone inputs valid");
        XCTAssertTrue(allZoneInputsValid(["986", "67"]), "All zone inputs valid");
        
        XCTAssertFalse(allZoneInputsValid(["9", ""]), "All zone inputs valid");
        XCTAssertFalse(allZoneInputsValid(["9", "a"]), "All zone inputs valid");
        XCTAssertFalse(allZoneInputsValid(["a", "8"]), "All zone inputs valid");
    }
    
    func testCreateZone(){
        var zoneValues: [String] = ["0", "100"];
        var newZone:Zone = createZone(zoneValues, HeartRateZone.ZoneOne)
        
        XCTAssertTrue(newZone.Lower == 0, "Create New Zone - lower value");
        XCTAssertTrue(newZone.Upper == 100, "Create New Zone = upper value");
    }
    
    func testZoneChanges(){
        var user = UserSettings();
        
        var rest = Zone(_lower: 0, _upper: 99, _zone: HeartRateZone.Rest);
        var zone1 = Zone(_lower: 100, _upper: 119, _zone: HeartRateZone.ZoneOne);
        let zone2 = Zone(_lower: 120, _upper: 139, _zone: HeartRateZone.ZoneTwo);
        let zone3 = Zone(_lower: 140, _upper: 159, _zone: HeartRateZone.ZoneThree);
        let zone4 = Zone(_lower: 160, _upper: 179, _zone: HeartRateZone.ZoneFour);
        let zone5 = Zone(_lower: 180, _upper: 199, _zone: HeartRateZone.ZoneFive);
        let max = Zone(_lower: 200, _upper: 999, _zone: HeartRateZone.Max);
        
        
        user.UserZones.append(rest);
        user.UserZones.append(zone1);
        user.UserZones.append(zone2);
        user.UserZones.append(zone3);
        user.UserZones.append(zone4);
        user.UserZones.append(zone5);
        user.UserZones.append(max);
        
        var currentBPM = 0;
        
        currentBPM = 100
        var newZone = getZoneforBPM(currentBPM, user.UserZones)
        XCTAssertTrue(newZone == HeartRateZone.ZoneOne, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 119
        newZone = getZoneforBPM(currentBPM, user.UserZones)
        XCTAssertTrue(newZone == HeartRateZone.ZoneOne, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 120
        newZone = getZoneforBPM(currentBPM, user.UserZones)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.ZoneTwo, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 139
        newZone = getZoneforBPM(currentBPM, user.UserZones)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.ZoneTwo, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 140
        newZone = getZoneforBPM(currentBPM, user.UserZones)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.ZoneThree, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 159
        newZone = getZoneforBPM(currentBPM, user.UserZones)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.ZoneThree, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 160
        newZone = getZoneforBPM(currentBPM, user.UserZones)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.ZoneFour, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 179
        newZone = getZoneforBPM(currentBPM, user.UserZones)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.ZoneFour, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 180
        newZone = getZoneforBPM(currentBPM, user.UserZones)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.ZoneFive, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 199
        newZone = getZoneforBPM(currentBPM, user.UserZones)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.ZoneFive, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 200
        newZone = getZoneforBPM(currentBPM, user.UserZones)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.Max, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 219
        newZone = getZoneforBPM(currentBPM, user.UserZones)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.Max, "Zone match - Pass");
        XCTAssertFalse(newZone == HeartRateZone.Rest, "Zone match - Fail");
        
        currentBPM = 99
        newZone = getZoneforBPM(currentBPM, user.UserZones)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.Rest, "Zone match - Pass");
        
        currentBPM = 0
        newZone = getZoneforBPM(currentBPM, user.UserZones)
        XCTAssertFalse(newZone == HeartRateZone.ZoneOne, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneTwo, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneThree, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFour, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.ZoneFive, "Zone match - Fail");
        XCTAssertFalse(newZone == HeartRateZone.Max, "Zone match - Fail");
        XCTAssertTrue(newZone == HeartRateZone.Rest, "Zone match - Pass");
        
        
    }
    
}
