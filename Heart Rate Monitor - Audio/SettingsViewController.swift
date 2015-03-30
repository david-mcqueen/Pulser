//
//  SettingsViewController.swift
//  Heart Rate Monitor - Audio
//
//  Created by DavidMcQueen on 28/03/2015.
//  Copyright (c) 2015 David McQueen. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController, UITableViewDelegate {
    
   
    
    @IBOutlet weak var audioAnnouncementSwitch: UISwitch!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var audioMinutes: UILabel!
    
    
    @IBOutlet weak var healthkitSwitch: UISwitch!
    @IBOutlet weak var healthkitSlider: UISlider!
    @IBOutlet weak var healthkitMinutes: UILabel!
    
    weak var delegate: UserSettingsDelegate?;
    var isRunning: Bool?;
    
    var setUserSettings: UserSettings?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        //Check if the back button has been pressed
        for stackedView in self.navigationController!.viewControllers{
            if stackedView as NSObject == self{
                return
            }
        }
        saveSettings();
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
        
        toggleReadOnly(isRunning!);
        
    }
    
    func toggleReadOnly(_readOnly: Bool){
        audioAnnouncementSwitch.userInteractionEnabled = !_readOnly;
        audioSlider.userInteractionEnabled = !_readOnly;
        audioMinutes.userInteractionEnabled = !_readOnly;
        
        healthkitSwitch.userInteractionEnabled = !_readOnly;
        healthkitSlider.userInteractionEnabled = !_readOnly;
        healthkitMinutes.userInteractionEnabled = !_readOnly;
        
        if(_readOnly){
            displayAlert("Restricted", "Unable to modify settings when the monitor is running");
        }
    }
    @IBAction func audioSliderChanged(sender: AnyObject) {
        populateSliderFields(self.audioSlider, _text: self.audioMinutes);
        setUserSettings?.AudioIntervalMinutes = Double(self.audioSlider.value);
    }
    
    @IBAction func healthkitSliderChange(sender: AnyObject) {
        populateSliderFields(self.healthkitSlider, _text: self.healthkitMinutes);
        setUserSettings?.HealthkitIntervalMinutes = Double(self.healthkitSlider.value);
    }
    
    @IBAction func audioSwitchChanged(sender: AnyObject) {
        setUserSettings?.AnnounceAudio = audioAnnouncementSwitch.on;
        self.tableView.reloadData()
    }
    
    @IBAction func healthkitSwitchChanged(sender: AnyObject) {
        setUserSettings?.SaveHealthkit = healthkitSwitch.on;
        self.tableView.reloadData()
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
    
    
    //MARK:- UITableViewDelegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            if (audioAnnouncementSwitch.on){
                return 2
            }else{
                return 1
            }
        case 2:
            if(healthkitSwitch.on){
                return 2
            }else{
                return 1
            }
        default:
            return 1;
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as UITableViewHeaderFooterView;
        
        header.textLabel.textColor = redColour;
    }
    
}
