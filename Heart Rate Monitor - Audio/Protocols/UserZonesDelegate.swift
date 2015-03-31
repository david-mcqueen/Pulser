//
//  UserZonesDelegate.swift
//  Heart Rate Monitor - Audio
//
//  Created by DavidMcQueen on 31/03/2015.
//  Copyright (c) 2015 David McQueen. All rights reserved.
//

import Foundation

protocol UserZonesDelegate: class {
    func didUpdateUserZones(_newSettings: UserSettings);
}