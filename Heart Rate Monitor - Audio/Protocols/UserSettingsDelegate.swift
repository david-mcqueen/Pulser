//
//  UserSettingsDelegate.swift
//  Heart Rate Monitor - Audio
//
//  Created by DavidMcQueen on 28/03/2015.
//  Copyright (c) 2015 David McQueen. All rights reserved.
//

import Foundation

protocol UserSettingsDelegate: class {
    func didUpdateUserSettings(_: UserSettings);
}