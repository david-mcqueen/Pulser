//
//  UserSettings.swift
//  Heart Rate Monitor - Audio
//
//  Created by DavidMcQueen on 28/03/2015.
//  Copyright (c) 2015 David McQueen. All rights reserved.
//

import Foundation


class UserSettings {
    var AnnounceAudio: Bool;
    var AnnounceAudioZoneChange: Bool;
    var AudioIntervalMinutes: Double;
    var SaveHealthkit: Bool;
    var HealthkitIntervalMinutes: Double;
    var UserZones: [Zone];
    var CurrentZone: HeartRateZone;
    
    init(){
        //Default user settings
        AnnounceAudio = true;
        AnnounceAudioZoneChange = true;
        AudioIntervalMinutes = 1.0;
        SaveHealthkit = false;
        HealthkitIntervalMinutes = 1.0;
        UserZones = [];
        CurrentZone = HeartRateZone.Rest;
    }
    
    func shouldAnnounceAudio()->Bool{
        return AnnounceAudio && AnnounceAudioZoneChange;
    }
    
    
    func getAudioIntervalasFloat()->Float{
        return convertDoubleToFloat(self.AudioIntervalMinutes);
    }
    
    func getHealthkitIntervalasFloat()->Float{
        return convertDoubleToFloat(self.HealthkitIntervalMinutes);
    }
    
    private func convertDoubleToFloat(input: Double)->Float{
        return Float(input);
    }
    
    
    func getAudioIntervalSeconds()->Double{
        return convertMinuteToSeconds(self.AudioIntervalMinutes)
    }
    
    func getHealthkitIntervalSeconds()->Double{
        return convertMinuteToSeconds(self.HealthkitIntervalMinutes)
    }
    
    func allZonesToString()->String{
        var zonesAsString: String = "";
        
        for zone in UserZones{
            zonesAsString += "\(singleZoneToString(zone))\n"
        }
        
        return zonesAsString;
    }
    
    private func singleZoneToString(inputZone: Zone)->String{
        return "Zone \(inputZone.getZoneType().rawValue) - Min: \(inputZone.Lower) - Max: \(inputZone.Upper)"
    }
    
    private func convertMinuteToSeconds(minutes: Double)->Double{
        return minutes * 60;
    }
    
}