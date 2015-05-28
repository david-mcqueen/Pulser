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

class ViewController: GAITrackedViewController, CBCentralManagerDelegate, CBPeripheralDelegate, AVSpeechSynthesizerDelegate, UserSettingsDelegate {

    
    //MARK:- View Variables
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var BPMLabel: UILabel!
    @IBOutlet weak var zoneLabel: UILabel!
    @IBOutlet weak var currentDisplayView: UIView!
    
    @IBOutlet weak var connectingLabel: UILabel!
    @IBOutlet weak var connectedLabel: UILabel!
    @IBOutlet weak var tickDisplayView: UIView!
    @IBOutlet weak var HKTick: UIImageView!
    @IBOutlet weak var AudioTick: UIImageView!
   
    //MARK:- Bluetooth Constants
    let HRM_DEVICE_INFO_SERVICE_UUID = CBUUID(string: "180A");
    let HRM_HEART_RATE_SERVICE_UUID = CBUUID(string: "180D");
    let HRM_MEASUREMENT_CHARACTERISTIC_UUID = CBUUID(string:"2A37");
    let HRM_BODY_LOCATION_CHARACTERISTIC_UUID = CBUUID(string:"2A38");
    let HRM_MANUFACTURER_NAME_CHARACTERISTIC_UUID = CBUUID(string:"2A29");
    
    //MARK:- Variables
    var centralManager: CBCentralManager!;
    var HRMPeripheral: CBPeripheral!;
    
    var services = [];

    var connected: Bool = false;
    var running: Bool = false;
    var attemptReconnect: Bool = false;
    var currentUserSettings: UserSettings = UserSettings();
    var CurrentBPM:Int = 0;
    
    var speechArray:[String] = [];
    
    var audioTimer: NSTimer?;
    var healthkitTimer :NSTimer?
    var connectTimer: NSTimer?
    
    var uttenenceCounter = 0;
    
    var mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    var error: NSError?;
    var session =  AVAudioSession.sharedInstance();
    
    //MARK:- View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //The screen name for Google Analytics
        self.screenName = "Main";
        
        mySpeechSynthesizer.delegate = self;
        currentUserSettings = loadUserSettings()
        connectedToHRM(false);
        runningHRM(running);
        updateDisplaySettings();
        
        self.connectingLabel.hidden = true;
        
        //Setup the Speech Synthesizer to annouce over the top of other playing audio (reduces other volume whilst uttering)
        session.setCategory(AVAudioSessionCategoryPlayback, withOptions: AVAudioSessionCategoryOptions.DuckOthers, error: &error)
        
        services = [HRM_HEART_RATE_SERVICE_UUID, HRM_DEVICE_INFO_SERVICE_UUID];
    }
    
    override func viewWillAppear(animated: Bool) {
        //Load user settings
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
        connectedToHRM(self.connected);
        if (attemptReconnect){
            runningHRM(attemptReconnect);
            running = true;
            speechArray.append("Pulser regained connection to heart rate monitor")
            speakAllUtterences()
            
        }
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
    
    func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("Failed to connect")
        self.running = false;
        connectedToHRM(false);
        runningHRM(false);
        displayAlert("Error", "Failed to connect to Heart Rate Monitor")
    }
    
    
    func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("Lost Connection");

        
        if (running){
            speechArray.append("Pulser lost connection to heart rate monitor")
            speakAllUtterences()
            
            //Attempt to reconnect to HRM
            attemptReconnect = true;
            centralManager.scanForPeripheralsWithServices(services as [AnyObject], options: nil)
        }else{
            displayAlert("Error", "Lost connection to Heart Rate Monitor")
        }
        
        HRMPeripheral = nil;
        running = false;
        connectedToHRM(false);
        runningHRM(false);
    }
    
    
    //Called whenever the device state changes
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        //Determine the state of the peripheral
        switch(central.state){
        case .PoweredOff:
            NSLog("CoreBluetooth BLE hardware is powered off");
            self.running = false;
            connectedToHRM(false);
            runningHRM(false);
            connectingLabel.hidden = true;
            
        case .PoweredOn:
            NSLog("CoreBluetooth BLE hardware is powered on and ready");
            
            
            //Add a peripheral that has connected via another app
            if (!alreadyConnectedDevice()){
                centralManager.scanForPeripheralsWithServices(services as [AnyObject], options: nil);
                connectingLabel.hidden = false;
            }
            
        case .Unauthorized:
            NSLog("CoreBluetooth BLE state is unauthorized");
            self.running = false;
            connectedToHRM(false);
            runningHRM(false);
            connectingLabel.hidden = true;
            
        case .Unknown:
            NSLog("CoreBluetooth BLE state is unknown");
            self.running = false;
            connectedToHRM(false);
            runningHRM(false);
            connectingLabel.hidden = true;

        case .Unsupported:
            displayAlert("Error", "CoreBluetooth BLE hardware is unsupported on this platform");
            self.running = false;
            connectedToHRM(false);
            runningHRM(false);
            connectingLabel.hidden = true;
            
        default:
            self.running = false;
            connectedToHRM(false);
            runningHRM(false);
            connectingLabel.hidden = true;
            break;
        }
        
    }
    
    
    
    //MARK:- CBPeripheralDelegate
    //Called when you discover the peripherals available services
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        for service  in peripheral.services as! [CBService] {
            NSLog("Discovered service: \(service.UUID)")
            peripheral.discoverCharacteristics(nil, forService: service as CBService)
        }
    }
    
    //When you discover the characteristics of a specified service
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        if (service.UUID == HRM_HEART_RATE_SERVICE_UUID){
            for char in service.characteristics as! [CBCharacteristic] {
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
            for char in service.characteristics as! [CBCharacteristic]{
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
            if(running){
                self.getHeartBPMData(characteristic, error: error)
            }
            
        }
    }
    
    
    func speakData(){
        if(self.CurrentBPM > 0 && connected){
            speechArray.append("Heart rate is \(self.CurrentBPM) beats per minute");
            
            speechArray.append("Currently in zone \(currentUserSettings.CurrentZone.rawValue)")
        }else{
            speechArray.append("Unable to get Heart Rate")
        }
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
        var newZone = getZoneforBPM(self.CurrentBPM, self.currentUserSettings.UserZones)
        
        if (newZone != currentUserSettings.CurrentZone && connected){
            speechArray.append("Zones Changed from \(currentUserSettings.CurrentZone.rawValue) to \(newZone.rawValue)")
            currentUserSettings.CurrentZone = newZone
            speakAllUtterences();
        }
        displayCurrentHeartRate(self.CurrentBPM, _zone: currentUserSettings.CurrentZone);
        
    }
    
    func displayCurrentHeartRate(_bpm: Int, _zone: HeartRateZone){
        BPMLabel.text = String(_bpm);
        zoneLabel.text = _zone.rawValue
    }
    
    
    //MARK:- Methods
    
    func connectedToHRM(connected:Bool){
        self.connectButton.hidden = connected;
        self.startStopButton.hidden = !connected;
        connectedLabel.hidden = !connected;
        self.connected = connected;
        updateDisplaySettings();
        
        if(connected){
            connectingLabel.hidden = true;
        }
    }
    
    
    func updateDisplaySettings(){
        let activeImage: UIImage = UIImage(named: "TickCircle_Active.png")!
        let notActiveImage: UIImage = UIImage(named: "TickCircle.png")!;
        if (currentUserSettings.AnnounceAudio){
            AudioTick.image = activeImage;
        }else{
            AudioTick.image = notActiveImage;
        }
        
        if (currentUserSettings.SaveHealthkit){
            HKTick.image = activeImage;
        }else{
            HKTick.image = notActiveImage;
        }
        
        
        tickDisplayView.hidden = !connected;
        
    }
    
    func runningHRM(isRunning:Bool){
        self.currentDisplayView.hidden = !isRunning;
        
        if(connected){
            self.connectedLabel.hidden = isRunning;
        }
        
        if(isRunning){
            //Start a timer
            if (currentUserSettings.AnnounceAudio){
                //Start a repeating timer for X seconds, to announce BPM changes
                audioTimer = NSTimer.scheduledTimerWithTimeInterval(currentUserSettings.getAudioIntervalSeconds(), target: self, selector: Selector("speakData"), userInfo: nil, repeats: true);
            }
            
            if(currentUserSettings.SaveHealthkit){
                //Start a repeating timer for X seconds, to save BPM to healthkit
                healthkitTimer = NSTimer.scheduledTimerWithTimeInterval(currentUserSettings.getHealthkitIntervalSeconds(), target: self, selector: Selector("saveData"), userInfo: nil, repeats: true);
            }
            
            changeButtonText(self.startStopButton, _buttonText: "Stop");
            
        }else{
            //End the timers
            if(audioTimer != nil){
                audioTimer?.invalidate()
            }
            
            if(healthkitTimer != nil){
                healthkitTimer?.invalidate()
            }
            
            changeButtonText(self.startStopButton, _buttonText: "Start");
        }
    }
    
    
    @IBAction func startStopPressed(sender: AnyObject) {
        if(currentUserSettings.UserZones.count > 0){
            running = !running;
            attemptReconnect = !running;
            runningHRM(running);
            var action = running ? "Starting" : "Stopping"
            speechArray.append("\(action) Pulser");
            speakAllUtterences();
        }else{
            displayAlert("Error", "Please setup heart rate zones first");
        }
        
        
    }
    
    func changeButtonText(_button: UIButton, _buttonText: String){
        _button.setTitle(_buttonText, forState: UIControlState.Normal);
    }
    
    @IBAction func connectPressed(sender: AnyObject) {
        attemptReconnect = false; //Manually connect
        centralManager = CBCentralManager(delegate: self, queue: nil);
        //Check every 2 seconds if the device is connected via another app
        centralManager.scanForPeripheralsWithServices(services as [AnyObject], options: nil);
        connectTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("alreadyConnectedDevice"), userInfo: nil, repeats: true);
       
    }
    
    func alreadyConnectedDevice()->Bool{
        if(self.HRMPeripheral != nil){
            connectTimer?.invalidate();
            return true
        }
        
        var services = [HRM_HEART_RATE_SERVICE_UUID, HRM_DEVICE_INFO_SERVICE_UUID];
        var connectedDevice = centralManager.retrieveConnectedPeripheralsWithServices(services);
        
        //Add a peripheral that has connected via another app
        if (connectedDevice.count > 0){
            let device = connectedDevice.last as! CBPeripheral;
            self.HRMPeripheral = device;
            device.delegate = self;
            centralManager.connectPeripheral(device, options: nil)
            connectedToHRM(true)
            return true;
        }
        return false;
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
            if(self.currentUserSettings.shouldAnnounceAudio()){
                self.mySpeechSynthesizer.speakUtterance(nextUtterence);
            }
        }
    }
    
    func speakAllUtterences(){
        while((speechArray.count > 0)){
            speakNextUtterence();
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.ShowSettings.rawValue{
            let settingsViewController = segue.destinationViewController as! SettingsViewController
            settingsViewController.delegate = self;
            settingsViewController.isRunning = running;
            settingsViewController.setUserSettings = currentUserSettings
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
        updateDisplaySettings();
        
        //Save the settings to NSUserDefaults
        saveUserSettings(newSettings);
    }
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}



