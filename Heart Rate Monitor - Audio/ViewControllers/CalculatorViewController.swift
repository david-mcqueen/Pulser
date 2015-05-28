//
//  CalculatorViewController.swift
//  Pulser
//
//  Created by DavidMcQueen on 28/05/2015.
//  Copyright (c) 2015 David McQueen. All rights reserved.
//


import Foundation


class CalculatorViewController: UITableViewController, UITableViewDelegate, UserZonesDelegate {
    
    @IBOutlet weak var inputMaxBPM: UITextField!
    @IBOutlet weak var inputRestBPM: UITextField!
    @IBOutlet weak var btnCalculate: UIButton!
    var setUserSettings: UserSettings?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
    }
    
    
    @IBAction func calculatePressed(sender: AnyObject) {
        
        let warningTitle = "Guidlines Only!";
        let warningMessage = "Pulser provides these heart rate zones for guidance only. By continuing you indicate you accept the disclaimer detailed under the calculator information";
        
        var alert = UIAlertController(title: warningTitle, message: warningMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { action in
            //Don't do anything, as the user didn't accept.
        }))
        
        alert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { action in
            println("Did press OK")
            //TODO:- Save the user acceptance. Dont want to ask again
            self.calculateUserZones();

        }));
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func calculateUserZones(){
        var zones = calculateHeartRateZones(
            (self.inputMaxBPM.text as NSString).doubleValue,
            (self.inputRestBPM.text as NSString).doubleValue
        );
        
        setUserSettings?.UserZones = zones;
        
        
        //Finished with calculator, navigate to view the zones
        let zonesViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EnterZonesViewController") as! EnterZonesViewController
        zonesViewController.userSettings = self.setUserSettings!
        zonesViewController.delegate = self;
        
        self.navigationController?.pushViewController(zonesViewController, animated: true);
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row{
        case 0:
            inputMaxBPM.becomeFirstResponder();
        case 1:
            inputRestBPM.becomeFirstResponder();
        default:
            break;
        }
    }
    
    func didUpdateUserZones(_newSettings: UserSettings) {
        setUserSettings = _newSettings;
        //Save the settings to NSUserDefaults
        saveUserSettings(setUserSettings!);
        
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView;
        
        header.textLabel.textColor = redColour;
    }
    
    
}