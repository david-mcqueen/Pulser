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

func writeBPM(BPMInput: Double){
    var healthStore: HKHealthStore? = nil;
    
    //TODO:- If no Healthkit store this WILL crash.
    //Need to consolidate the request and write into one file.
    healthStore = HKHealthStore();
    
    let identifier = HKQuantityTypeIdentifierHeartRate;
    let quantityType = HKObjectType.quantityTypeForIdentifier(identifier);
    let authorisationStatus = healthStore?.authorizationStatusForType(quantityType);
    
    if (authorisationStatus != HKAuthorizationStatus.SharingAuthorized){
        NSLog("Not authorised to write BPM");
        return;
    }
    
    let startDate = NSDate();
    let endDate = NSDate();
    
    // Save the user's heart rate into HealthKit.
    let heartRateUnit: HKUnit = HKUnit.countUnit().unitDividedByUnit(HKUnit.minuteUnit())
    let heartRateQuantity: HKQuantity = HKQuantity(unit: heartRateUnit, doubleValue: BPMInput)
    
    var heartRate : HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
    
    let WeightSample = HKQuantitySample(type: heartRate, quantity: heartRateQuantity, startDate: startDate, endDate: endDate);
    
    
    healthStore?.saveObject(WeightSample, withCompletion: {
        (success: Bool, error: NSError!) -> Void in
        if success {
            dispatch_async(dispatch_get_main_queue(), {
                NSLog("BPM was saved OK");
            })
        }else{
            NSLog("Failed to save Weight. Error: \(error)");
        }
    })
    
}


//Check that the input string is a valid BPM
func isValidBPM(_inputBPM: String)->Bool{
    let validBPMRegex = "^([0-9]{1,3})$";
    var bpmTest = NSPredicate(format:"SELF MATCHES %@", validBPMRegex);
    return bpmTest!.evaluateWithObject(_inputBPM);
}

//Check the zone boundaries dont overlap
func validateZoneBoundaries(_inputZones: [Zone])->(Bool, String){
    var valid = true;
    var errorMessage = "\nZone boundaries invalid:";
    
    for zone in _inputZones{
        if(zone.Lower > zone.Upper || (getAllZonesforBPM(zone.Lower, _inputZones).count > 1 || getAllZonesforBPM(zone.Upper, _inputZones).count > 1)){
            valid = false;
            errorMessage += "\n - Zone \(zone.ZoneType.rawValue) incorrect"
        }
    }
    return (valid, errorMessage);
}

//Create a new zone
func createZone(_zoneInputs: [String], _type: HeartRateZone)->Zone{
    return Zone(_lower: _zoneInputs[0].toInt()!, _upper: _zoneInputs[1].toInt()!, _zone: _type);
}

//Return the input values for the provided UITextField collection
func getZoneInputValues(_zoneInputGroup: [UITextField])->[String]{
    var zoneBPM: [String] = [];
    
    for inputBPM in _zoneInputGroup{
        zoneBPM.append(inputBPM.text);
    }
    return zoneBPM;
}

func getZoneforBPM(BPM:Int, _zones:[Zone]) -> HeartRateZone{
    return getAllZonesforBPM(BPM, _zones)[0];
}

//Return all zones that the BPM falls into
//Should only return one. Is also used for validating hence the possibility to return more than 1
func getAllZonesforBPM(BPM:Int, _zones:[Zone]) -> [HeartRateZone]{
    
    var matchedZones:[HeartRateZone] = [];
    //Loop all the zones to find the correct one.
    for zone in _zones {
        if ((BPM >= zone.Lower) && (BPM <= zone.Upper)){
            matchedZones.append(zone.ZoneType);
        }
    }
    if (matchedZones.count > 1){
        matchedZones.append(HeartRateZone.Unknown)
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
            loopCounter++;
        }
    }
    
}


func displayAlert(title: String, message: String){
    var alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
    alert.show();
}