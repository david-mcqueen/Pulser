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

func isValidBPM(_inputBPM: String)->Bool{
    let validBPMRegex = "^([0-9]{1,3})$";
    var bpmTest = NSPredicate(format:"SELF MATCHES %@", validBPMRegex);
    return bpmTest!.evaluateWithObject(_inputBPM);
}


func displayAlert(title: String, message: String){
    var alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
    alert.show();
}