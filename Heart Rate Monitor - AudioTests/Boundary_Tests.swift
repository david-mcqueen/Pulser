//
//  Boundary_Tests.swift
//  Heart Rate Monitor - Audio
//
//  Created by DavidMcQueen on 31/03/2015.
//  Copyright (c) 2015 David McQueen. All rights reserved.
//

import UIKit
import XCTest

class Boundary_Tests: XCTestCase {
    
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
    
    func testvalidateZoneBoundaries_1(){
        let user = UserSettings();
        
        let rest = Zone(_lower: 0, _upper: 99, _zone: HeartRateZone.Rest);
        let zone1 = Zone(_lower: 100, _upper: 119, _zone: HeartRateZone.ZoneOne);
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
        
        let (zonesValid, _) = validateZoneBoundaries(user.UserZones)
        
        XCTAssertTrue(zonesValid, "Zone Boundaries - Valid");
    }
    
    func testvalidateZoneBoundaries_2(){
        let user = UserSettings();
        
        let rest = Zone(_lower: 0, _upper: 100, _zone: HeartRateZone.Rest);
        let zone1 = Zone(_lower: 100, _upper: 119, _zone: HeartRateZone.ZoneOne);
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
        
        let (zonesValid, _) = validateZoneBoundaries(user.UserZones)
        
        XCTAssertFalse(zonesValid, "Zone Boundaries - Invalid, rest -> zone 1");
    }
    
    func testvalidateZoneBoundaries_3(){
        let user = UserSettings();
        
        let rest = Zone(_lower: 0, _upper: 99, _zone: HeartRateZone.Rest);
        let zone1 = Zone(_lower: 99, _upper: 119, _zone: HeartRateZone.ZoneOne);
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
        
        let (zonesValid, _) = validateZoneBoundaries(user.UserZones)
        
        XCTAssertFalse(zonesValid, "Zone Boundaries - Invalid, rest -> zone 1");
    }
    
    func testvalidateZoneBoundaries_4(){
        let user = UserSettings();
        
        let rest = Zone(_lower: 0, _upper: 99, _zone: HeartRateZone.Rest);
        let zone1 = Zone(_lower: 100, _upper: 120, _zone: HeartRateZone.ZoneOne);
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
        
        let (zonesValid, _) = validateZoneBoundaries(user.UserZones)
        
        XCTAssertFalse(zonesValid, "Zone Boundaries - Invalid, zone 1 -> zone 2");
    }
    
    func testvalidateZoneBoundaries_5(){
        let user = UserSettings();
        
        let rest = Zone(_lower: 0, _upper: 99, _zone: HeartRateZone.Rest);
        let zone1 = Zone(_lower: 100, _upper: 199, _zone: HeartRateZone.ZoneOne);
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
        
        let (zonesValid, _) = validateZoneBoundaries(user.UserZones)
        
        XCTAssertFalse(zonesValid, "Zone Boundaries - Invalid, zone1 -> zone 5");
    }
    
    func testvalidateZoneBoundaries_6(){
        let user = UserSettings();
        
        let rest = Zone(_lower: 0, _upper: 99, _zone: HeartRateZone.Rest);
        let zone1 = Zone(_lower: 100, _upper: 99, _zone: HeartRateZone.ZoneOne);
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
        
        let (zonesValid, _) = validateZoneBoundaries(user.UserZones)
        
        XCTAssertFalse(zonesValid, "Zone Boundaries - Invalid, zone1");
    }
    
}