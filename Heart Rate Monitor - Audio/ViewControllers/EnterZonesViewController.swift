//
//  EnterZonesViewController.swift
//  Heart Rate Monitor - Audio
//
//  Created by DavidMcQueen on 30/03/2015.
//  Copyright (c) 2015 David McQueen. All rights reserved.
//

import Foundation
import UIKit


class EnterZonesViewController: UITableViewController, UITableViewDelegate{
    
    @IBOutlet weak var restZone: UITextField!
    @IBOutlet weak var maxZone: UITextField!
    
    @IBOutlet var zoneInput1: [UITextField]!
    @IBOutlet var zoneInput2: [UITextField]!
    @IBOutlet var zoneInput3: [UITextField]!
    @IBOutlet var zoneInput4: [UITextField]!
    @IBOutlet var zoneInput5: [UITextField]!
    
    weak var delegate: UserZonesDelegate?
    var userSettings: UserSettings?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO:- Add a zone caluclator
        
        
        //Add a save button to the nav bar
        var saveButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveZones"));
        self.navigationItem.rightBarButtonItem = saveButtonItem;
        
        displayZones();
    }
    
    func displayZones(){
        for userZone in userSettings!.UserZones{
            switch userZone.ZoneType{
            case HeartRateZone.Rest:
                displayZonesValues([userZone.Upper!], _zoneFields: [restZone]);
            case HeartRateZone.ZoneOne:
                displayZonesValues(userZone.getZoneValuesAsArray(), _zoneFields: zoneInput1);
            case HeartRateZone.ZoneTwo:
                displayZonesValues(userZone.getZoneValuesAsArray(), _zoneFields: zoneInput2);
            case HeartRateZone.ZoneThree:
                displayZonesValues(userZone.getZoneValuesAsArray(), _zoneFields: zoneInput3);
            case HeartRateZone.ZoneFour:
                displayZonesValues(userZone.getZoneValuesAsArray(), _zoneFields: zoneInput4);
            case HeartRateZone.ZoneFive:
                displayZonesValues(userZone.getZoneValuesAsArray(), _zoneFields: zoneInput5);
            case HeartRateZone.Max:
                displayZonesValues([userZone.Lower!], _zoneFields: [maxZone]);
            default:
                break;
            }
        }
    }
    
    func displayZonesValues(_zoneValues:[Int], _zoneFields: [UITextField]){
        
        if(_zoneValues.count == _zoneFields.count){
            var loopCounter = 0;
            for zoneField in _zoneFields{
                zoneField.text = String(_zoneValues[loopCounter]);
                loopCounter++;
            }
        }
        
    }
    
    func displayTextValueInField(_textField: UITextField, _input: String){
        _textField.text = _input;
    }
    
    func saveZones(){
        //Validate that all the zones are OK
        var (allZonesValid, validatedZones) = validateZones();
        //TODO:- Implement bound checking between zones
        
        if(allZonesValid){
            userSettings!.UserZones = validatedZones;
            if delegate != nil{
                delegate?.didUpdateUserZones(userSettings!);
                self.navigationController?.popViewControllerAnimated(true);
            }
        }else{
            displayAlert("Error", "Please check the zone values and try again")
        }
    }
    
    func validateZones()->(Bool, [Zone]){
        var validatedZones: [Zone] = [];
        var valid = true;
        var restBPM: [String] = ["0", restZone.text];
        var zoneOneBPM: [String] = getZoneInputValues(zoneInput1);
        var zoneTwoBPM: [String] = getZoneInputValues(zoneInput2);
        var zoneThreeBPM: [String] = getZoneInputValues(zoneInput3);
        var zoneFourBPM: [String] = getZoneInputValues(zoneInput4);
        var zoneFiveBPM: [String] = getZoneInputValues(zoneInput5);
        var maxBPM: [String] =  [maxZone.text, "999"];
        
        if(allZoneInputsValid(restBPM)){
            validatedZones.append(createZone(restBPM, _type: HeartRateZone.Rest));
        }else{
            valid = false;
        }
        
        if(allZoneInputsValid(zoneOneBPM)){
            validatedZones.append(createZone(zoneOneBPM, _type: HeartRateZone.ZoneOne));
        }else{
            valid = false;
        }
        
        if(allZoneInputsValid(zoneTwoBPM)){
            validatedZones.append(createZone(zoneTwoBPM, _type: HeartRateZone.ZoneTwo));
        }else{
            valid = false;
        }
        
        if(allZoneInputsValid(zoneThreeBPM)){
            validatedZones.append(createZone(zoneThreeBPM, _type: HeartRateZone.ZoneThree));
        }else{
            valid = false;
        }
        
        if(allZoneInputsValid(zoneFourBPM)){
            validatedZones.append(createZone(zoneFourBPM, _type: HeartRateZone.ZoneFour));
        }else{
            valid = false;
        }
        
        if(allZoneInputsValid(zoneFiveBPM)){
            validatedZones.append(createZone(zoneFiveBPM, _type: HeartRateZone.ZoneFive));
        }else{
            valid = false;
        }
        
        if(allZoneInputsValid(maxBPM)){
            validatedZones.append(createZone(maxBPM, _type: HeartRateZone.Max));
        }else{
            valid = false;
        }
        
        return (valid, validatedZones);
    }
    
    
    //Create a new zone
    func createZone(_zoneInputs: [String], _type: HeartRateZone)->Zone{
        return Zone(_lower: _zoneInputs[0].toInt(), _upper: _zoneInputs[1].toInt(), _zone: _type);
    }
    
    //Return the input values for the provided UITextField collection
    func getZoneInputValues(_zoneInputGroup: [UITextField])->[String]{
        var zoneBPM: [String] = [];
        
        for inputBPM in _zoneInputGroup{
            zoneBPM.append(inputBPM.text);
        }
        return zoneBPM;
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
    
    //TODO:- Handle the "Next" and "Done" buttons on the keyboard
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as UITableViewHeaderFooterView;
        
        header.textLabel.textColor = redColour;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section{
        case 0:
            restZone.becomeFirstResponder();
        case 1:
            zoneInput1[indexPath.row].becomeFirstResponder()
        case 2:
            zoneInput2[indexPath.row].becomeFirstResponder();
        case 3:
            zoneInput3[indexPath.row].becomeFirstResponder();
        case 4:
            zoneInput4[indexPath.row].becomeFirstResponder();
        case 5:
            zoneInput5[indexPath.row].becomeFirstResponder();
        case 6:
            maxZone.becomeFirstResponder();
        default:
            break;
        }
    }
}