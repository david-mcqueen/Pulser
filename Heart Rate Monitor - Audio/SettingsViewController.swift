//
//  SettingsViewController.swift
//  Heart Rate Monitor - Audio
//
//  Created by DavidMcQueen on 28/03/2015.
//  Copyright (c) 2015 David McQueen. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var audioAnnouncementSwitch: UISwitch!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var audioMinutes: UILabel!
    
    
    @IBOutlet weak var healthkitSwitch: UISwitch!
    @IBOutlet weak var healthkitSlider: UISlider!
    @IBOutlet weak var healthkitMinutes: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func audioSliderChanged(sender: AnyObject) {
        self.audioSlider.value = round(self.audioSlider.value)
        self.audioMinutes.text = String(format: "%.0f", self.audioSlider.value);
    }
    
    @IBAction func healthkitSliderChange(sender: AnyObject) {
        self.healthkitSlider.value = round(self.healthkitSlider.value)
        self.healthkitMinutes.text = String(format: "%.0f", self.healthkitSlider.value);
    }
    
}
