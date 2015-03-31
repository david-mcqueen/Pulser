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
    var AudioIntervalMinutes: Double;
    var SaveHealthkit: Bool;
    var HealthkitIntervalMinutes: Double;
    var UserZones: [Zone];
    var CurrentZone: HeartRateZone;
    
    init(){
        //Default user settings
        AnnounceAudio = true;
        AudioIntervalMinutes = 1.0;
        SaveHealthkit = false;
        HealthkitIntervalMinutes = 1.0;
        UserZones = [];
        CurrentZone = HeartRateZone.Rest;
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
    
    private func convertMinuteToSeconds(minutes: Double)->Double{
        return minutes * 60;
    }
    
    func getZoneforBPM(BPM:Int) -> HeartRateZone{
        
        //Loop all the zones to find the correct one.
        for zone in UserZones {
            if ((BPM >= zone.Lower || zone.Lower == nil) && (BPM <= zone.Upper || zone.Upper == nil)){
                return zone.ZoneType;
            }
        }
        
        return HeartRateZone.Unknown;
    }
}