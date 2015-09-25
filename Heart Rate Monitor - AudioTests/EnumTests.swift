//
//  EnumTests.swift
//  Pulser
//
//  Created by David McQueen on 25/09/2015.
//  Copyright © 2015 David McQueen. All rights reserved.
//

import XCTest

class EnumTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHeartRateZones(){
        //Test that the HeartRateZones Enum is correct
        XCTAssertEqual(HeartRateZone.Rest.rawValue, "Rest");
        XCTAssertEqual(HeartRateZone.ZoneOne.rawValue, "One");
        XCTAssertEqual(HeartRateZone.ZoneTwo.rawValue, "Two");
        XCTAssertEqual(HeartRateZone.ZoneThree.rawValue, "Three");
        XCTAssertEqual(HeartRateZone.ZoneFour.rawValue, "Four");
        XCTAssertEqual(HeartRateZone.ZoneFive.rawValue, "Five");
        XCTAssertEqual(HeartRateZone.Max.rawValue, "Max");
        
        XCTAssertEqual(HeartRateZone.Unknown.rawValue, "Unknown");
    }
    
    func testSegueIdentifier(){
        XCTAssertEqual(SegueIdentifier.ShowSettings.rawValue, "showSettings");
        XCTAssertEqual(SegueIdentifier.ModifyUserZones.rawValue, "modifyUserZones");
        XCTAssertEqual(SegueIdentifier.ManageZones.rawValue, "manageZones");
        XCTAssertEqual(SegueIdentifier.CalculateZones.rawValue, "calculateZones");
    }
    
    
    func testUserDefaultKets(){
        XCTAssertEqual(UserDefaultKeys.SaveAudio.rawValue, "SettingsAnnounceAudio");
        XCTAssertEqual(UserDefaultKeys.SaveHealthKit.rawValue, "SettingsSaveHealthkit");
        XCTAssertEqual(UserDefaultKeys.AudioInterval.rawValue, "SettingsAudioInterval");
        XCTAssertEqual(UserDefaultKeys.HealthKitInterval.rawValue, "SettingsHealthkitInterval");
        XCTAssertEqual(UserDefaultKeys.SaveAudioZoneChange.rawValue, "SettingsAnnounceAudioZones");
        XCTAssertEqual(UserDefaultKeys.SaveAverageBPM.rawValue, "SettingsSaveAverageBPM");
        XCTAssertEqual(UserDefaultKeys.AverageBPM.rawValue, "SettingsAverageBPMInterval");
        
        XCTAssertEqual(UserDefaultKeys.ZoneRest.rawValue, "SettingsZoneRest");
        XCTAssertEqual(UserDefaultKeys.ZoneOne.rawValue, "SettingsZoneOne");
        XCTAssertEqual(UserDefaultKeys.ZoneTwo.rawValue, "SettingsZoneTwo");
        XCTAssertEqual(UserDefaultKeys.ZoneThree.rawValue, "SettingsZoneThree");
        XCTAssertEqual(UserDefaultKeys.ZoneFour.rawValue, "SettingsZoneFour");
        XCTAssertEqual(UserDefaultKeys.ZoneFive.rawValue, "SettingsZoneFive");
        XCTAssertEqual(UserDefaultKeys.ZoneMax.rawValue, "SettingsZoneMax");
        
        XCTAssertEqual(UserDefaultKeys.Unknown.rawValue, "Unknown");
    }
    
}



