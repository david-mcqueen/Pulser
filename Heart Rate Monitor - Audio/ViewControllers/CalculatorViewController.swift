//
//  CalculatorViewController.swift
//  Pulser
//
//  Created by DavidMcQueen on 28/05/2015.
//  Copyright (c) 2015 David McQueen. All rights reserved.
//


import Foundation


class CalculatorViewController: UITableViewController, UITableViewDelegate {
    
    @IBOutlet weak var inputMaxBPM: UITextField!
    @IBOutlet weak var inputRestBPM: UITextField!
    @IBOutlet weak var btnCalculate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
    }
    
    
    @IBAction func calculatePressed(sender: AnyObject) {
        
        let warningTitle = "Guidance Only!";
        let warningMessage = "Pulser provides these heart rate zones for guidance only. By continuing you indicate you accept the disclaimer detailed under the calculator information";
        
        var alert = UIAlertController(title: warningTitle, message: warningMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { action in
            //Don't do anything, as the user didn't accept.
        }))
        
        alert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { action in
            println("Did press OK")
            //TODO:- Save the user acceptance. Dont want to ask again
            calculateUserZones();
        }));
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func calculateUserZones(){
        var zones = calculateHeartRateZones(
            (self.inputMaxBPM.text as NSString).doubleValue,
            (self.inputRestBPM.text as NSString).doubleValue
        );
        
        //Finished with calculator, navigate to view the zones
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section{
        case 0:
            inputMaxBPM.becomeFirstResponder();
        case 1:
            inputRestBPM.becomeFirstResponder()
        default:
            break;
        }
    }
    
    
}