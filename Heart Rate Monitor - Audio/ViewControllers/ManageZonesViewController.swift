//
//  ManageZonesViewController.swift
//  Pulser
//
//  Created by DavidMcQueen on 28/05/2015.
//  Copyright (c) 2015 David McQueen. All rights reserved.
//

import Foundation


class ManageZonesViewController: UITableViewController, UITableViewDelegate, UserZonesDelegate {

    var setUserSettings: UserSettings?;

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
    }
    
    override func viewWillAppear(animated: Bool) {
        setUserSettings = loadUserSettings();
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.ModifyUserZones.rawValue{
            
            let zonesViewController = segue.destinationViewController as! EnterZonesViewController
            zonesViewController.delegate = self;
            zonesViewController.userSettings = setUserSettings!
            
        } else if segue.identifier == SegueIdentifier.CalculateZones.rawValue{
            let zonesViewController = segue.destinationViewController as! CalculatorViewController
            zonesViewController.setUserSettings = setUserSettings!
        }
    }
    
    func didUpdateUserZones(_newSettings: UserSettings) {
        setUserSettings = _newSettings;
        //Save the settings to NSUserDefaults
        saveUserSettings(setUserSettings!);
        NSLog("didUpdateUserZones");
        NSLog("\n\(setUserSettings?.allZonesToString())!)");
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView;
        
        header.textLabel.textColor = redColour;
    }
    
}