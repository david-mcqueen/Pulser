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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO:- Add a zone caluclator
        
        //TODO:- Add a save button and functinality
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