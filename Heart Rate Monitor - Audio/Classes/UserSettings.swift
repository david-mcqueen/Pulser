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
    var AnnounceInterval: Int;
    var SaveHealthkit: Bool;
    var HealthkitInterval: Int;
    
    init(_audio: Bool, _audioInterval: Int, _healthkit: Bool, _healthkitInterval: Int){
        AnnounceAudio = _audio;
        AnnounceInterval = _audioInterval;
        SaveHealthkit = _healthkit;
        HealthkitInterval = _healthkitInterval;
    }
    
    func getAudioIntervalasFloat()->Float{
        return convertIntToFloat(self.AnnounceInterval);
    }
    
    func getHealthkitIntervalasFloat()->Float{
        return convertIntToFloat(self.HealthkitInterval);
    }
    
    private func convertIntToFloat(input: Int)->Float{
    
        return Float(input);
    }
}