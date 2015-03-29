//
//  ViewController.swift
//  Heart Rate Monitor - Audio
//
//  Created by DavidMcQueen on 15/01/2015.
//  Copyright (c) 2015 David McQueen. All rights reserved.
//

import UIKit
import CoreBluetooth;
import QuartzCore;
import AVFoundation;
import CoreLocation;
import HealthKit;

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, AVSpeechSynthesizerDelegate, UserSettingsDelegate {

    
    let HRM_DEVICE_INFO_SERVICE_UUID = CBUUID(string: "180A");
    let HRM_HEART_RATE_SERVICE_UUID = CBUUID(string: "180D");
    
    let HRM_MEASUREMENT_CHARACTERISTIC_UUID = CBUUID(string:"2A37");
    let HRM_BODY_LOCATION_CHARACTERISTIC_UUID = CBUUID(string:"2A38");
    let HRM_MANUFACTURER_NAME_CHARACTERISTIC_UUID = CBUUID(string:"2A29");
    
    var centralManager: CBCentralManager!;
    var HRMPeripheral: CBPeripheral!;

    var connected: Bool = false;
    var healthStore: HKHealthStore? = nil;
    
    var user = UserHeartRate();
    var currentUserSettings: UserSettings?;
    
    var CurrentBPM:Int = 0;
    
    var speechArray:[String] = [];
    
    var uttenenceCounter = 0;
    
    var mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    var error: NSError?;
    var session =  AVAudioSession.sharedInstance();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Default user settings values
        currentUserSettings = UserSettings(
            _audio: true,
            _audioInterval: Int(1),
            _healthkit: true,
            _healthkitInterval: Int(1)
        );
        
        
        mySpeechSynthesizer.delegate = self;
        
        //Setup the Speech Synthesizer to annouce over the top of other playing audio (reduces other volume whilst uttering)
        session.setCategory(AVAudioSessionCategoryPlayback, withOptions: AVAudioSessionCategoryOptions.DuckOthers, error: &error)
        
        
        //Get all the users zones
        var rest = Zone(_lower: nil, _upper: 99, _zone: HeartRateZone.Rest);
        var zone1 = Zone(_lower: 100, _upper: 119, _zone: HeartRateZone.ZoneOne);
        let zone2 = Zone(_lower: 120, _upper: 139, _zone: HeartRateZone.ZoneTwo);
        let zone3 = Zone(_lower: 140, _upper: 159, _zone: HeartRateZone.ZoneThree);
        let zone4 = Zone(_lower: 160, _upper: 179, _zone: HeartRateZone.ZoneFour);
        let zone5 = Zone(_lower: 180, _upper: 199, _zone: HeartRateZone.ZoneFive);
        let max = Zone(_lower: 200, _upper: nil, _zone: HeartRateZone.Max);
        

        user.Zones.append(rest);
        user.Zones.append(zone1);
        user.Zones.append(zone2);
        user.Zones.append(zone3);
        user.Zones.append(zone4);
        user.Zones.append(zone5);
        user.Zones.append(max);
        
        centralManager = CBCentralManager(delegate: self, queue: nil);
        
        
        //TODO:- Get the switch values from the user settings.
        var announceAudio = true;
        var saveHealthkit = true;
        
        
        if (announceAudio){
            //Start a repeating timer for X seconds, to announce BPM changes
            var audioIntervalTimer = 120.0;
            //TODO:- get the interval time from the user settings
            var audioTimer = NSTimer.scheduledTimerWithTimeInterval(audioIntervalTimer, target: self, selector: Selector("speakData"), userInfo: nil, repeats: true);
        }
       
        if(saveHealthkit){
            //Start a repeating timer for X seconds, to save BPM to healthkit
            var healthkitIntervalTimer = 120.0;
            //TODO:- get the interval time from the user settings
            var healthkitTimer = NSTimer.scheduledTimerWithTimeInterval(healthkitIntervalTimer, target: self, selector: Selector("saveData"), userInfo: nil, repeats: true);
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- CBCentralManagerDelegate
    //Called when a peripheral is successfully connected
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        peripheral.delegate = self;
        peripheral.discoverServices(nil);
        self.connected = (peripheral.state == CBPeripheralState.Connected ? true : false);
        NSLog("Connected: \(self.connected)");
    }

    //called with the CBPeripheral class as its main input parameter. This contains most of the information there is to know about a BLE peripheral.
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        println("Discovered \(peripheral.name)")
        var localName = advertisementData;
        if localName.count > 0 {
            println("stop scan")
            self.centralManager.stopScan();
            println("assign peripheral")
            self.HRMPeripheral = peripheral;
            println("delegate")
            peripheral.delegate = self;
            
            println("connect");
            self.centralManager.connectPeripheral(peripheral, options: nil);
        }
        
        
    }
    
    //Called whenever the device state changes
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        //Determine the state of the peripheral
        switch(central.state){
        case .PoweredOff:
            NSLog("CoreBluetooth BLE hardware is powered off");
            
        case .PoweredOn:
            NSLog("CoreBluetooth BLE hardware is powered on and ready");
            var services = [HRM_HEART_RATE_SERVICE_UUID, HRM_DEVICE_INFO_SERVICE_UUID];
            centralManager.scanForPeripheralsWithServices(services, options: nil);
            
        case .Unauthorized:
            NSLog("CoreBluetooth BLE state is unauthorized");
            
        case .Unknown:
            NSLog("CoreBluetooth BLE state is unknown");

        case .Unsupported:
            NSLog("CoreBluetooth BLE hardware is unsupported on this platform");
            
        default:
            NSLog("Fuck knows mate")
        }
        
    }
    
    func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("Failed to connect")
    }
    
    //MARK:- CBPeripheralDelegate
    //Called when you discover the peripherals available services
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        for service  in peripheral.services as [CBService] {
            NSLog("Discovered service: \(service.UUID)")
            peripheral.discoverCharacteristics(nil, forService: service as CBService)
        }
    }
    
    //When you discover the characteristics of a specified service
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        if (service.UUID == HRM_HEART_RATE_SERVICE_UUID){
            for char in service.characteristics as [CBCharacteristic] {
                if (char.UUID == HRM_MEASUREMENT_CHARACTERISTIC_UUID){
                    self.HRMPeripheral.setNotifyValue(true, forCharacteristic: char as CBCharacteristic);
                    NSLog("Found heart rate measurement characteristic");
                }else if (char.UUID == HRM_BODY_LOCATION_CHARACTERISTIC_UUID){
                    self.HRMPeripheral.readValueForCharacteristic(char as CBCharacteristic);
                    NSLog("Found body sensor location characteristic");
                }
            }
        }
        
        if (service.UUID == HRM_DEVICE_INFO_SERVICE_UUID){
            for char in service.characteristics as [CBCharacteristic]{
                print(char.UUID)
                if (char.UUID == HRM_MANUFACTURER_NAME_CHARACTERISTIC_UUID){
                    self.HRMPeripheral.readValueForCharacteristic(char as CBCharacteristic);
                    NSLog("Found a device manufacturer name characteristic");
                }
            }
        }
    }
    
    // Invoked when you retrieve a specified characteristic's value, or when the peripheral device notifies your app that the characteristic's value has changed.
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        println("didUpdateValueForCharacteristic")
        if (characteristic!.UUID == HRM_MEASUREMENT_CHARACTERISTIC_UUID){
            println("BPM")
            self.getHeartBPMData(characteristic, error: error)
        }
        if (characteristic!.UUID == HRM_MANUFACTURER_NAME_CHARACTERISTIC_UUID){
            println("name")
            self.getManufacturerName(characteristic!);
        }
        if (characteristic!.UUID == HRM_BODY_LOCATION_CHARACTERISTIC_UUID){
            println("location")
            self.getBodyLocation(characteristic!);
        }
    }
    
    func speakData(){
            
        speechArray.append("Heart rate is \(self.CurrentBPM) beats per minute");
        
        speechArray.append("Currently in zone \(user.CurrentZone.rawValue)")

        speakAllUtterences();
        
    }
    
    func saveData(){
        writeBPM(Double(self.CurrentBPM));
    }
    
    
    //MARK:- CBCharacteristic helpers
    //Get the BPM info
    func getHeartBPMData(characteristic: CBCharacteristic!, error: NSError!){
        var data = characteristic.value;
        var values = [UInt8](count:data.length, repeatedValue: 0)
        data.getBytes(&values, length: data.length);
        
        self.CurrentBPM = Int(values[1]);
        
        var newZone = user.getZoneforBPM(self.CurrentBPM)
        
        if (newZone != user.CurrentZone){
            speechArray.append("Zones Changed from \(user.CurrentZone.rawValue) to \(newZone.rawValue)")
            user.CurrentZone = newZone
            speakAllUtterences();
        }
        println(user.CurrentZone.rawValue)
        
    }
    
    func getManufacturerName(characteristic: CBCharacteristic){
        
    }
    
    func getBodyLocation(characteristic: CBCharacteristic){
        
    }
    
    
 
    func startSpeaking(){
        self.speakNextUtterence();
    }
    
    func speakNextUtterence(){
        if((speechArray.count > 0)){
            var nextUtterence: AVSpeechUtterance = AVSpeechUtterance(string:speechArray[0]);
            speechArray.removeAtIndex(0);
            nextUtterence.rate = 0.15;
//            nextUtterence.voice(AVSpeechSynthesisVoice(language:"en-GB"))
            self.mySpeechSynthesizer.speakUtterance(nextUtterence);
        }
    }
    
    func speakAllUtterences(){
        while((speechArray.count > 0)){
            speakNextUtterence();
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        //Check we are able to access healthkit
        if(!HKHealthStore.isHealthDataAvailable()){
            dispatch_async(dispatch_get_main_queue(), {
                var alert = UIAlertController(title: "Alert", message: "Healthkit is not supported on this device", preferredStyle: UIAlertControllerStyle.Alert);
                self.presentViewController(alert, animated: true, completion: nil);
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil));
                NSLog("Temp was saved OK");
                NSLog("Healthkit is not supported on this device");
            })
            return;
        }
        
        self.healthStore = HKHealthStore();
        
        let dataTypesToWrite = [
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        ]
        let dataTypesToRead = [
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        ]
        
        self.healthStore?.requestAuthorizationToShareTypes(NSSet(array: dataTypesToWrite), readTypes: NSSet(array: dataTypesToRead), completion: {
            (success, error) in
            if success {
                NSLog("User completed authorisation request");
                dispatch_async(dispatch_get_main_queue(), {
                    //Call to write information
                    //self.writeBodyTemperature();
                    //self.writeBMI();
                    NSLog("Ready to go!");
                })
            }else{
                dispatch_async(dispatch_get_main_queue(), {
                    var alert = UIAlertController(title: "Alert", message: "You cancelled the authorisation request", preferredStyle: UIAlertControllerStyle.Alert);
                    self.presentViewController(alert, animated: true, completion: nil);
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil));
                    NSLog("The user cancelled the authorisation request \(error)");
                    
                })
            }
        })
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.ShowSettings.rawValue{
            let settingsViewController = segue.destinationViewController as SettingsViewController
            settingsViewController.delegate = self;
            //TODO:- Pass the current values
            settingsViewController.setUserSettings = currentUserSettings!
        }
    }
    
    
    //MARK:- AVSpeechSynthesizerDelegate
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didStartSpeechUtterance utterance: AVSpeechUtterance!) {
        session.setActive(true, error: &error)
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didFinishSpeechUtterance utterance: AVSpeechUtterance!) {
        session.setActive(false, error: &error)
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didPauseSpeechUtterance utterance: AVSpeechUtterance!) {
        session.setActive(false, error: &error)
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didContinueSpeechUtterance utterance: AVSpeechUtterance!) {
        session.setActive(true, error: &error)
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didCancelSpeechUtterance utterance: AVSpeechUtterance!) {
        session.setActive(false, error: &error)
    }
    
    //MARK:- UpdateSettingsDelegate
     func didUpdateUserSettings(newSettings: UserSettings) {
        currentUserSettings = newSettings;
    }
   
}

