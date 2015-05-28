//
//  SettingsViewController.swift
//  Heart Rate Monitor - Audio
//
//  Created by DavidMcQueen on 28/03/2015.
//  Copyright (c) 2015 David McQueen. All rights reserved.
//

import Foundation
import UIKit
import HealthKit

class SettingsViewController: UITableViewController, UITableViewDelegate {
    
    var tracker: GAITracker = GAI.sharedInstance().defaultTracker;
    
    @IBOutlet weak var audioAnnouncementSwitch: UISwitch!
    @IBOutlet weak var audioAnnouncementZoneSwitch: UISwitch!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var audioMinutes: UILabel!
    
    
    @IBOutlet weak var healthkitSwitch: UISwitch!
    @IBOutlet weak var healthkitSlider: UISlider!
    @IBOutlet weak var healthkitMinutes: UILabel!
    
    weak var delegate: UserSettingsDelegate?;
    
    var setUserSettings: UserSettings?;
    var healthStore: HKHealthStore? = nil;
    
    override func viewDidLoad() {
        tracker.set(kGAIScreenName, value: "Settings");
        var build = GAIDictionaryBuilder.createAppView().build() as [NSObject : AnyObject]
        tracker.send(build);
        
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        //Check if the back button has been pressed
        for stackedView in self.navigationController!.viewControllers{
            if stackedView as! NSObject == self{
                return
            }
        }
        saveSettings();
    }
    
    override func viewWillAppear(animated: Bool) {
        
        setUserSettings = loadUserSettings();
        
        var audioAnnounce = setUserSettings?.AnnounceAudio;
        var audioAnnounceZones = setUserSettings?.AnnounceAudioZoneChange;
        var healthkitSave = setUserSettings?.SaveHealthkit;
        var audioInterval = setUserSettings?.getAudioIntervalasFloat();
        var healthkitInterval = setUserSettings?.getHealthkitIntervalasFloat();
        
        audioAnnouncementSwitch.on = audioAnnounce!;
        audioAnnouncementZoneSwitch.on = audioAnnounceZones!;
        healthkitSwitch.on = healthkitSave!;
        audioSlider.value = audioInterval!;
        healthkitSlider.value = healthkitInterval!;
        
        populateSliderFields(audioSlider, _text: audioMinutes);
        populateSliderFields(healthkitSlider, _text: healthkitMinutes);
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
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
    
    @IBAction func audioZoneSwitchChanged(sender: AnyObject) {
        setUserSettings?.AnnounceAudioZoneChange = audioAnnouncementZoneSwitch.on;
        
    }
    
    @IBAction func healthkitSwitchChanged(sender: AnyObject) {
        
        if(!deviceSupportsHealthKitAccess()){
            displayAlert("Error", "Healthkit not supported on this device");
            return;
        }
        
        self.healthStore = HKHealthStore();
        
        let dataTypesToWrite = [
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        ]
        let dataTypesToRead = [];
        
        self.healthStore?.requestAuthorizationToShareTypes(NSSet(array: dataTypesToWrite) as Set<NSObject>, readTypes: NSSet(array: dataTypesToRead as [AnyObject]) as Set<NSObject>, completion: {
            (success, error) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    if(!havePermissionToSaveHealthKit()){
                        displayAlert("Error", "Permission not received to save HealthKit data. Grant permission from iPhone settings to allow Pulser to save to HealthKit")
                        self.setUserSettings?.SaveHealthkit = false
                        self.healthkitSwitch.on = false;
                    }else{
                        self.setUserSettings?.SaveHealthkit = self.healthkitSwitch.on
                    }
                    self.tableView.reloadData()
                    
                })
            }else{
                dispatch_async(dispatch_get_main_queue(), {
                    displayAlert("Error", "Permission not received to save HealthKit data. Grant permission from iPhone settings to allow Pulser to save to HealthKit")
                    self.setUserSettings?.SaveHealthkit = false
                    self.healthkitSwitch.on = false;
                    self.tableView.reloadData()
                })
            }
        })
        
    }
    
    func deviceSupportsHealthKitAccess()->Bool{
        //Check we are able to access healthkit
        if(!HKHealthStore.isHealthDataAvailable()){
            return false;
            
        }else{
            return true;
        }
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
                return 3
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.ManageZones.rawValue{
            //Save the current settings before moving to a new screen
            saveUserSettings(setUserSettings!)
            let zonesViewController = segue.destinationViewController as! ManageZonesViewController
//            zonesViewController.setUserSettings = setUserSettings!
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView;
        
        header.textLabel.textColor = redColour;
    }
    
}
