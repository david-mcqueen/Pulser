//
//  UserHeartRate.swift
//  Heart Rate Monitor - Audio
//
//  Created by DavidMcQueen on 27/03/2015.
//  Copyright (c) 2015 David McQueen. All rights reserved.
//

import Foundation

class UserHeartRate {
    
    var Zones:[Zone];
    var CurrentZone: HeartRateZone;
    
    init(){
        Zones = [];
        CurrentZone = HeartRateZone.Rest;
    }
    
    func getZoneforBPM(BPM:Int) -> HeartRateZone{
        
        //Loop all the zones to find the correct one.
        for zone in Zones {
            if ((BPM >= zone.Lower) && (BPM <= zone.Upper)){
                return zone.getZoneType();
            }
        }
        
        return HeartRateZone.Unknown;
    }
    
}