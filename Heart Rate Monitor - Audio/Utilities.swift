//
//  Utilities.swift
//  Heart Rate Monitor - Audio
//
//  Created by DavidMcQueen on 27/03/2015.
//  Copyright (c) 2015 David McQueen. All rights reserved.
//

import Foundation
import HealthKit;
import UIKit;

var redColour:UIColor = UIColor(red: 0.824, green: 0.255, blue: 0.122, alpha: 1);

func havePermissionToSaveHealthKit()->Bool{
    var healthStore: HKHealthStore? = nil;
    //TODO:- If no Healthkit store this WILL crash.
    //Need to consolidate the request and write into one file.
    healthStore = HKHealthStore();
    
    let identifier = HKQuantityTypeIdentifierHeartRate;
    let quantityType = HKObjectType.quantityTypeForIdentifier(identifier);
    let authorisationStatus = healthStore?.authorizationStatusForType(quantityType!);
    
    if (authorisationStatus != HKAuthorizationStatus.SharingAuthorized){
        return false;
    }else{
        return true;
    }
}



func writeBPM(BPMInput: Double){
    var healthStore: HKHealthStore? = nil;
    healthStore = HKHealthStore();
    
    if(!havePermissionToSaveHealthKit()){
        displayAlert("Error", message: "Permission not received to save HealthKit. Grant permission from iPhone settings to allow Pulser to save to HealthKit")
    }
    
    let startDate = NSDate();
    let endDate = NSDate();
    
    // Save the user's heart rate into HealthKit.
    let heartRateUnit: HKUnit = HKUnit.countUnit().unitDividedByUnit(HKUnit.minuteUnit())
    let heartRateQuantity: HKQuantity = HKQuantity(unit: heartRateUnit, doubleValue: BPMInput)
    
    let heartRate : HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!
    
    let WeightSample = HKQuantitySample(type: heartRate, quantity: heartRateQuantity, startDate: startDate, endDate: endDate);
    
    
    healthStore?.saveObject(WeightSample, withCompletion: {
        (success: Bool, error: NSError?) -> Void in
        if success {
            dispatch_async(dispatch_get_main_queue(), {
                NSLog("BPM was saved OK");
            })
        }else{
            NSLog("Failed to save BPM. Error: \(error)");
        }
    })
    
}

func saveUserSettings(newUserSettings: UserSettings){
    NSUserDefaults.standardUserDefaults().setObject(newUserSettings.AnnounceAudio, forKey: UserDefaultKeys.SaveAudio.rawValue);
    NSUserDefaults.standardUserDefaults().setObject(newUserSettings.AnnounceAudioZoneChange, forKey: UserDefaultKeys.SaveAudioZoneChange.rawValue);
    NSUserDefaults.standardUserDefaults().setObject(newUserSettings.SaveHealthkit, forKey: UserDefaultKeys.SaveHealthKit.rawValue);
    NSUserDefaults.standardUserDefaults().setObject(newUserSettings.getAudioIntervalMinutesFloat(), forKey: UserDefaultKeys.AudioInterval.rawValue);
    NSUserDefaults.standardUserDefaults().setObject(newUserSettings.getAudioIntervalSecondsFloat(), forKey: UserDefaultKeys.AudioIntervalSeconds.rawValue);
    NSUserDefaults.standardUserDefaults().setObject(newUserSettings.getHealthkitIntervalasFloat(), forKey: UserDefaultKeys.HealthKitInterval.rawValue);
    NSUserDefaults.standardUserDefaults().setObject(newUserSettings.AnnounceAudioShort, forKey: UserDefaultKeys.AnnounceAudioShort.rawValue);
    
    NSUserDefaults.standardUserDefaults().synchronize();
    saveUserZones(newUserSettings);
}

private func saveUserZones(userSettings: UserSettings){
    
    //Save each of the zones
    for zone in userSettings.UserZones{
        NSUserDefaults.standardUserDefaults().setObject(zone.getZoneForSaving(), forKey: zone.getZoneKey().rawValue);
    }
    NSUserDefaults.standardUserDefaults().synchronize();
    
}

func loadUserSettings()->UserSettings{
    let savedUser:UserSettings = UserSettings();
    
    if let savedValue: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.SaveAudio.rawValue) {
        savedUser.AnnounceAudio = savedValue as! Bool;
    }
    if let savedValue: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.SaveAudioZoneChange.rawValue) {
        savedUser.AnnounceAudioZoneChange = savedValue as! Bool;
    }
    if let savedValue: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.SaveHealthKit.rawValue) {
        savedUser.SaveHealthkit = savedValue as! Bool;
    }
    if let savedValue: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.AudioInterval.rawValue) {
        savedUser.AudioIntervalMinutes = savedValue as! Double;
    }
    if let savedValue: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.HealthKitInterval.rawValue) {
        savedUser.HealthkitIntervalMinutes = savedValue as! Double;
    }
    if let savedValue: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.AudioIntervalSeconds.rawValue) {
        savedUser.AudioIntervalSeconds = savedValue as! Double;
    }
    if let savedValue: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.AnnounceAudioShort.rawValue) {
        savedUser.AnnounceAudioShort = savedValue as! Bool;
    }
    
    
    savedUser.UserZones = loadUserZones().UserZones;
    
    return savedUser;
}

private func loadUserZones()->UserSettings{
    let savedUserZones: UserSettings = UserSettings();
    
    //All the zone keys, and correspoing types to be retrieved
    let zoneDictionary: [UserDefaultKeys: HeartRateZone] = [
        UserDefaultKeys.ZoneRest : HeartRateZone.Rest,
        UserDefaultKeys.ZoneOne : HeartRateZone.ZoneOne,
        UserDefaultKeys.ZoneTwo : HeartRateZone.ZoneTwo,
        UserDefaultKeys.ZoneThree : HeartRateZone.ZoneThree,
        UserDefaultKeys.ZoneFour : HeartRateZone.ZoneFour,
        UserDefaultKeys.ZoneFive : HeartRateZone.ZoneFive,
        UserDefaultKeys.ZoneMax : HeartRateZone.Max
    ];
    
    for (key, zone) in zoneDictionary{
        if let savedZone: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(key.rawValue) {
            let zoneValues = savedZone as! [NSString];
            savedUserZones.UserZones.append(createZone(zoneValues as! [String], _type: zone))
        }
    }
    
    return savedUserZones;
}


//Check that the input string is a valid BPM
func isValidBPM(_inputBPM: String)->Bool{
    let validBPMRegex = "^([0-9]{1,3})$";
    let bpmTest = NSPredicate(format:"SELF MATCHES %@", validBPMRegex);
    return bpmTest.evaluateWithObject(_inputBPM);
}

//Check the zone boundaries dont overlap
func validateZoneBoundaries(_inputZones: [Zone])->(Bool, String){
    var valid = true;
    var errorMessage = "\nZone boundaries invalid:";
    
    for zone in _inputZones{
        if(zone.Lower > zone.Upper || (getAllZonesforBPM(zone.Lower, _zones: _inputZones).count > 1 || getAllZonesforBPM(zone.Upper, _zones: _inputZones).count > 1)){
            valid = false;
            errorMessage += "\n - Zone \(zone.getZoneType().rawValue) incorrect"
        }
    }
    return (valid, errorMessage);
}

//Create a new zone
func createZone(_zoneInputs: [String], _type: HeartRateZone)->Zone{
    return Zone(_lower: Int(_zoneInputs[0])!, _upper: Int(_zoneInputs[1])!, _zone: _type);
}

//Return the input values for the provided UITextField collection
func getZoneInputValues(_zoneInputGroup: [UITextField])->[String]{
    var zoneBPM: [String] = [];
    
    for inputBPM in _zoneInputGroup{
        zoneBPM.append(inputBPM.text!);
    }
    return zoneBPM;
}

func getZoneforBPM(BPM:Int, _zones:[Zone]) -> HeartRateZone{
    return getAllZonesforBPM(BPM, _zones: _zones)[0];
}

//Return all zones that the BPM falls into
//Should only return one. Is also used for validating hence the possibility to return more than 1
func getAllZonesforBPM(BPM:Int, _zones:[Zone]) -> [HeartRateZone]{
    
    var matchedZones:[HeartRateZone] = [];
    //Loop all the zones to find the correct one.
    for zone in _zones {
        if ((BPM >= zone.Lower) && (BPM <= zone.Upper)){
            matchedZones.append(zone.getZoneType());
        }
    }
    
    //Return Rest as default
    if (matchedZones.count < 1){
        matchedZones.append(HeartRateZone.Rest)
    }
    
    return matchedZones;
}

//Check each of the inputs are a valid BPM
func allZoneInputsValid(_inputStrings: [String])->Bool{
    for input in _inputStrings{
        if (!isValidBPM(input)){
            return false;
        }
    }
    return true;
}

//Displays the corresponding zone value in the relevant text field
func displayZonesValues(_zoneValues:[Int], _zoneFields: [UITextField]){
    
    if(_zoneValues.count == _zoneFields.count){
        var loopCounter = 0;
        for zoneField in _zoneFields{
            zoneField.text = String(_zoneValues[loopCounter]);
            loopCounter += 1;
        }
    }
    
}


func displayAlert(title: String, message: String){
    let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
    alert.show();
}


func calculateHeartRateZones(_maxBPM: Double, _restBPM: Double)->[Zone]{
    //Following http://www.runnersworld.com/running-tips/heart-rate-training-is-it-right-for-you
    
    let heartRateReserve: Double = Double(_maxBPM - _restBPM);
    var allZones: [Zone] = [];
    
    let rest: Zone = Zone(
        _lower: Int(_restBPM),
        _upper: calculateBPMForZone(heartRateReserve, _modifier: 0.50, _restBPM: _restBPM)-1,
        _zone: HeartRateZone.Rest
    );
    
    let zone1: Zone = Zone(
        _lower: calculateBPMForZone(heartRateReserve, _modifier: 0.50, _restBPM: _restBPM),
        _upper: calculateBPMForZone(heartRateReserve, _modifier: 0.599999, _restBPM: _restBPM),
        _zone: HeartRateZone.ZoneOne
    );
    
    let zone2: Zone = Zone(
        _lower: calculateBPMForZone(heartRateReserve, _modifier: 0.60, _restBPM: _restBPM),
        _upper: calculateBPMForZone(heartRateReserve, _modifier: 0.70, _restBPM: _restBPM),
        _zone: HeartRateZone.ZoneTwo
    );
    
    let zone3: Zone = Zone(
        _lower: calculateBPMForZone(heartRateReserve, _modifier: 0.71, _restBPM: _restBPM),
        _upper: calculateBPMForZone(heartRateReserve, _modifier: 0.80, _restBPM: _restBPM),
        _zone: HeartRateZone.ZoneThree
    );
    
    let zone4: Zone = Zone(
        _lower: calculateBPMForZone(heartRateReserve, _modifier: 0.81, _restBPM: _restBPM),
        _upper: calculateBPMForZone(heartRateReserve, _modifier: 0.93, _restBPM: _restBPM),
        _zone: HeartRateZone.ZoneFour
    );
    
    let zone5: Zone = Zone(
        _lower: calculateBPMForZone(heartRateReserve, _modifier: 0.94, _restBPM: _restBPM),
        _upper: calculateBPMForZone(heartRateReserve, _modifier: 1.0, _restBPM: _restBPM) - 1,
        _zone: HeartRateZone.ZoneFive
    );
    
    let max: Zone = Zone(
        _lower: calculateBPMForZone(heartRateReserve, _modifier: 1.0, _restBPM: _restBPM),
        _upper: 999,
        _zone: HeartRateZone.Max
    );
    
    allZones.append(rest);
    allZones.append(zone1);
    allZones.append(zone2);
    allZones.append(zone3);
    allZones.append(zone4);
    allZones.append(zone5);
    allZones.append(max);
    
    return allZones;
}

private func calculateBPMForZone(_reserve: Double, _modifier: Double, _restBPM: Double)->Int{
    let step = (_reserve * (_modifier)) + _restBPM;
    return Int(step);
}




