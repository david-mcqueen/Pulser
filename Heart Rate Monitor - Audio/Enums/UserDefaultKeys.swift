//
//  UserDefaultKeys.swift
//  Heart Rate Monitor - Audio
//
//  Created by DavidMcQueen on 31/03/2015.
//  Copyright (c) 2015 David McQueen. All rights reserved.
//

import Foundation

enum UserDefaultKeys: String{
    case SaveAudio = "SettingsAnnounceAudio";
    case SaveHealthKit = "SettingsSaveHealthkit";
    case AudioInterval = "SettingsAudioInterval";
    case HealthKitInterval = "SettingsHealthkitInterval";
    
    case ZoneRest = "SettingsZoneRest";
    case ZoneOne = "SettingsZoneOne";
    case ZoneTwo = "SettingsZoneTwo";
    case ZoneThree = "SettingsZoneThree";
    case ZoneFour = "SettingsZoneFour";
    case ZoneFive = "SettingsZoneFive";
    case ZoneMax = "SettingsZoneMax";
    
    case Unknown = "Unknown";
}