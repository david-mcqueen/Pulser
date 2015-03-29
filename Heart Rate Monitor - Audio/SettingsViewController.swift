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
    
    weak var delegate: UserSettingsDelegate?;
    
    var setUserSettings: UserSettings?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true;
        var backBtn: UIBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Done, target: self, action: Selector("saveSettings"));
        self.navigationItem.leftBarButtonItem = backBtn;
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        var audioAnnounce = setUserSettings?.AnnounceAudio;
        var healthkitSave = setUserSettings?.SaveHealthkit;
        var audioInterval = setUserSettings?.getAudioIntervalasFloat();
        var healthkitInterval = setUserSettings?.getHealthkitIntervalasFloat();
        
        audioAnnouncementSwitch.on = audioAnnounce!;
        healthkitSwitch.on = healthkitSave!;
        audioSlider.value = audioInterval!;
        healthkitSlider.value = healthkitInterval!;
        
        populateSliderFields(audioSlider, _text: audioMinutes);
        populateSliderFields(healthkitSlider, _text: healthkitMinutes);
        
    }

    //TODO:- Only display the sliders when the relevant switches are on
    // Look at project example for showing & hiding the table rows
    
    @IBAction func audioSliderChanged(sender: AnyObject) {
        populateSliderFields(self.audioSlider, _text: self.audioMinutes);
        setUserSettings?.AnnounceInterval = Int(self.audioSlider.value);
    }
    
    @IBAction func healthkitSliderChange(sender: AnyObject) {
        populateSliderFields(self.healthkitSlider, _text: self.healthkitMinutes);
        setUserSettings?.HealthkitInterval = Int(self.healthkitSlider.value);
    }
    
    @IBAction func audioSwitchChanged(sender: AnyObject) {
        setUserSettings?.AnnounceAudio = audioAnnouncementSwitch.on;
    }
    
    @IBAction func healthkitSwitchChanged(sender: AnyObject) {
        setUserSettings?.SaveHealthkit = healthkitSwitch.on;
    }
    
    func populateSliderFields(_slider: UISlider, _text: UILabel){
        _slider.value = round(_slider.value);
        _text.text = String(format: "%.0f", _slider.value);
    }
    
    func saveSettings(){
        if (self.delegate != nil){
            self.delegate?.didUpdateUserSettings(setUserSettings!);
        }
        self.navigationController?.popViewControllerAnimated(true);
    }
    
}
