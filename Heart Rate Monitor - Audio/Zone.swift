//
//  Zone.swift
//  Heart Rate Monitor - Audio
//
//  Created by DavidMcQueen on 27/03/2015.
//  Copyright (c) 2015 David McQueen. All rights reserved.
//

import Foundation


class Zone{
    var Lower:Int?;
    var Upper:Int?;
    var ZoneType:HeartRateZone;
    
    init(_lower: Int?, _upper:Int?, _zone:HeartRateZone){
        Lower = _lower;
        Upper = _upper;
        ZoneType = _zone;
    }
    
}