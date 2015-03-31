//
//  Zone.swift
//  Heart Rate Monitor - Audio
//
//  Created by DavidMcQueen on 27/03/2015.
//  Copyright (c) 2015 David McQueen. All rights reserved.
//

import Foundation


class Zone{
    var Lower:Int;
    var Upper:Int;
    private var ZoneType:HeartRateZone;
    private var ZoneKey:UserDefaultKeys?;
    
    init(_lower: Int, _upper:Int, _zone:HeartRateZone){
        Lower = _lower;
        Upper = _upper;
        ZoneType = _zone;
        setZone(_zone);
    }
    
    func getZoneValuesAsArray()->[Int]{
        return [Lower, Upper]
    }
    
    func getZoneForSaving()->[NSString]{
        return [
            NSString(string: String(format: "%d", Lower)),
            NSString(string: String(format: "%d", Upper))
        ];
    }
    
    func getZoneType()->HeartRateZone{
        return ZoneType;
    }
    
    func getZoneKey()->UserDefaultKeys{
        return ZoneKey!;
    }
    
    //Set the zone type, and the corresponing UserDefaultsKey
    func setZone(_zone: HeartRateZone){
        ZoneType = _zone;
        
        switch _zone{
        case .Rest:
            ZoneKey = UserDefaultKeys.ZoneRest;
        case .ZoneOne:
            ZoneKey = UserDefaultKeys.ZoneOne;
        case .ZoneTwo:
            ZoneKey = UserDefaultKeys.ZoneTwo;
        case .ZoneThree:
            ZoneKey = UserDefaultKeys.ZoneThree;
        case .ZoneFour:
            ZoneKey = UserDefaultKeys.ZoneFour;
        case .ZoneFive:
            ZoneKey = UserDefaultKeys.ZoneFive;
        case .Max:
            ZoneKey = UserDefaultKeys.ZoneMax;
        default:
            ZoneKey = UserDefaultKeys.Unknown;
        }
    }
    
}