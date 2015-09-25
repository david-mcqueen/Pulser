//
//  EnterZonesViewController.swift
//  Heart Rate Monitor - Audio
//
//  Created by DavidMcQueen on 30/03/2015.
//  Copyright (c) 2015 David McQueen. All rights reserved.
//

import Foundation
import UIKit


class EnterZonesViewController: UITableViewController{
        
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
        
        //Add a save button to the nav bar
        let saveButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveZones"));
        self.navigationItem.rightBarButtonItem = saveButtonItem;

        displayZones();
    }
    
    func displayZones(){
        for userZone in userSettings!.UserZones{
            switch userZone.getZoneType(){
            case HeartRateZone.Rest:
                displayZonesValues([userZone.Lower], _zoneFields: [restZone]);
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
                displayZonesValues([userZone.Lower], _zoneFields: [maxZone]);
            default:
                break;
            }
        }
    }
    
    
    //Displays text in the provided text field
    func displayTextValueInField(_textField: UITextField, _input: String){
        _textField.text = _input;
    }
    
    func saveZones(){
        //Validate that all the zones are OK
        let (allZonesValid, validatedZones, zoneErrors) = validateZones();
        
        if(allZonesValid){
            userSettings!.UserZones = validatedZones;
            if delegate != nil{
                delegate?.didUpdateUserZones(userSettings!);
                self.navigationController?.popViewControllerAnimated(true);
            }
        }else{
            displayAlert("Error", message: "\(zoneErrors)")
        }
    }
    
    func validateZones()->(Bool, [Zone], String){
        var validatedZones: [Zone] = [];
        var valid = true;
        var errorMessage:String = "Please check the zone values and try again:";
        let restBPM: [String] = [restZone!.text!, zoneInput1[0].text!];
        let zoneOneBPM: [String] = getZoneInputValues(zoneInput1);
        let zoneTwoBPM: [String] = getZoneInputValues(zoneInput2);
        let zoneThreeBPM: [String] = getZoneInputValues(zoneInput3);
        let zoneFourBPM: [String] = getZoneInputValues(zoneInput4);
        let zoneFiveBPM: [String] = getZoneInputValues(zoneInput5);
        let maxBPM: [String] =  [maxZone!.text!, "999"];
        
        //Check each of the inputs is a vaid BPM, and create a new zone
        if(allZoneInputsValid(restBPM)){
            let restZone = createZone(restBPM, _type: HeartRateZone.Rest);
            restZone.Upper = restZone.Upper - 1; //Remove 1 to not overlap with Zone1
            validatedZones.append(restZone);
        }else{
            valid = false;
            errorMessage += "\n - Zone \(HeartRateZone.Rest.rawValue) invalid"
        }
        
        if(allZoneInputsValid(zoneOneBPM)){
            validatedZones.append(createZone(zoneOneBPM, _type: HeartRateZone.ZoneOne));
        }else{
            valid = false;
            errorMessage += "\n - Zone \(HeartRateZone.ZoneOne.rawValue) invalid"
        }
        
        if(allZoneInputsValid(zoneTwoBPM)){
            validatedZones.append(createZone(zoneTwoBPM, _type: HeartRateZone.ZoneTwo));
        }else{
            valid = false;
            errorMessage += "\n - Zone \(HeartRateZone.ZoneTwo.rawValue) invalid"
        }
        
        if(allZoneInputsValid(zoneThreeBPM)){
            validatedZones.append(createZone(zoneThreeBPM, _type: HeartRateZone.ZoneThree));
        }else{
            valid = false;
            errorMessage += "\n - Zone \(HeartRateZone.ZoneThree.rawValue) invalid"
        }
        
        if(allZoneInputsValid(zoneFourBPM)){
            validatedZones.append(createZone(zoneFourBPM, _type: HeartRateZone.ZoneFour));
        }else{
            valid = false;
            errorMessage += "\n - Zone \(HeartRateZone.ZoneFour.rawValue) invalid"
        }
        
        if(allZoneInputsValid(zoneFiveBPM)){
            validatedZones.append(createZone(zoneFiveBPM, _type: HeartRateZone.ZoneFive));
        }else{
            valid = false;
            errorMessage += "\n - Zone \(HeartRateZone.ZoneFive.rawValue) invalid"
        }
        
        if(allZoneInputsValid(maxBPM)){
            validatedZones.append(createZone(maxBPM, _type: HeartRateZone.Max));
        }else{
            valid = false;
            errorMessage += "\n - Zone \(HeartRateZone.Max.rawValue) invalid"
        }
        
        //Check that the zone boundaries do not ovrelap
        let (zonesValid, errorMessageBoundary) = validateZoneBoundaries(validatedZones)
        if(!zonesValid){
            errorMessage += errorMessageBoundary;
            valid = zonesValid;
        }
        
        return (valid, validatedZones, errorMessage);
    }
    
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView;
        
        header.textLabel!.textColor = redColour;
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