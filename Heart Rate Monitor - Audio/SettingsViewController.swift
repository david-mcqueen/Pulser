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

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var audioAnnouncementSwitch: UISwitch!
    @IBOutlet weak var audioAnnouncementZoneSwitch: UISwitch!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var audioMinutes: UILabel!
    @IBOutlet weak var audioSecondsSlider: UISlider!
    @IBOutlet weak var audioSecondsLabel: UILabel!
    
    @IBOutlet weak var announcementSummarySwitch: UISwitch!
    
    @IBOutlet weak var frequencyLabel: UILabel!
    
    @IBOutlet weak var healthkitSwitch: UISwitch!
    @IBOutlet weak var healthkitSlider: UISlider!
    @IBOutlet weak var healthkitMinutes: UILabel!
    
    weak var delegate: UserSettingsDelegate?;
    
    var setUserSettings: UserSettings?;
    var healthStore: HKHealthStore? = nil;
    
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
        
        setUserSettings = loadUserSettings();
        
        let audioAnnounce = setUserSettings?.AnnounceAudio;
        let audioAnnounceZones = setUserSettings?.AnnounceAudioZoneChange;
        let healthkitSave = setUserSettings?.SaveHealthkit;
        let audioInterval = setUserSettings?.getAudioIntervalMinutesFloat();
        let audioIntervalSeconds = setUserSettings?.getAudioIntervalSecondsFloat();
        let healthkitInterval = setUserSettings?.getHealthkitIntervalasFloat();
        let announcementSummary = setUserSettings?.AnnounceAudioShort;
        
        audioAnnouncementSwitch.on = audioAnnounce!;
        audioAnnouncementZoneSwitch.on = audioAnnounceZones!;
        healthkitSwitch.on = healthkitSave!;
        announcementSummarySwitch.on = announcementSummary!;
        
        audioSlider.value = audioInterval!;
        audioSecondsSlider.value = audioIntervalSeconds!;
        healthkitSlider.value = healthkitInterval!;
        
        
        populateSliderFields(audioSlider, _text: audioMinutes);
        populateSliderFields(healthkitSlider, _text: healthkitMinutes);
        populateSliderFields(audioSecondsSlider, _text: audioSecondsLabel);
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
    }
    
    @IBAction func audioSliderChanged(sender: AnyObject) {
        populateSliderFields(self.audioSlider, _text: self.audioMinutes);
        setUserSettings?.AudioIntervalMinutes = Double(self.audioSlider.value);
    }
    
    @IBAction func audioSecondsSliderChanged(sender: AnyObject) {
        populateSliderFields(self.audioSecondsSlider, _text: self.audioSecondsLabel);
        setUserSettings?.AudioIntervalSeconds = Double(self.audioSecondsSlider.value);
    }
    
    @IBAction func healthkitSliderChange(sender: AnyObject) {
        populateSliderFields(self.healthkitSlider, _text: self.healthkitMinutes);
        setUserSettings?.HealthkitIntervalMinutes = Double(self.healthkitSlider.value);
    }
    
    @IBAction func audioSummarySwitchChanged(sender: AnyObject) {
        setUserSettings?.AnnounceAudioShort = announcementSummarySwitch.on;
        self.tableView.reloadData();
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
            displayAlert("Error", message: "Healthkit not supported on this device");
            return;
        }
        
        self.healthStore = HKHealthStore();
        
        let dataTypesToWrite: Set<HKSampleType> = [
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!
            ]
        let dataTypesToRead: Set<HKObjectType> = [];
        
        self.healthStore?.requestAuthorizationToShareTypes(
                dataTypesToWrite as Set<HKSampleType>,
                readTypes: dataTypesToRead as Set<HKObjectType>, completion: {
            (success, error) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    if(!havePermissionToSaveHealthKit()){
                        displayAlert("Error", message: "Permission not received to save HealthKit data. Grant permission from iPhone settings to allow Pulser to save to HealthKit")
                        self.setUserSettings?.SaveHealthkit = false
                        self.healthkitSwitch.on = false;
                    }else{
                        self.setUserSettings?.SaveHealthkit = self.healthkitSwitch.on
                    }
                    self.tableView.reloadData()
                    
                })
            }else{
                dispatch_async(dispatch_get_main_queue(), {
                    displayAlert("Error", message: "Permission not received to save HealthKit data. Grant permission from iPhone settings to allow Pulser to save to HealthKit")
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
            return audioAnnouncementSwitch.on ? 5 : 1;
        case 2:
            return healthkitSwitch.on ? 2 : 1;
        case 3:
            return 2;
        default:
            return 1;
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 3){
            switch indexPath.row{
            case 0:
                Instabug.invokeFeedbackSender();
            case 1:
                UIApplication.sharedApplication().openURL(NSURL(string: "itms-apps://itunes.apple.com/ca/app/pulser-hear-your-heart/id981645997")!)
            default:
                break;
            }
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.ManageZones.rawValue{
            //Save the current settings before moving to a new screen
            saveUserSettings(setUserSettings!)
//            let zonesViewController = segue.destinationViewController as! ManageZonesViewController
//            zonesViewController.setUserSettings = setUserSettings!
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView;
        
        header.textLabel!.textColor = redColour;
    }
    
}
