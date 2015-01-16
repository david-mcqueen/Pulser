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

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    let HRM_DEVICE_INFO_SERVICE_UUID = CBUUID(string: "180A");
    let HRM_HEART_RATE_SERVICE_UUID = CBUUID(string: "180D");
    
    let HRM_MEASUREMENT_CHARACTERISTIC_UUID = CBUUID(string:"2A37");
    let HRM_BODY_LOCATION_CHARACTERISTIC_UUID = CBUUID(string:"2A38");
    let HRM_MANUFACTURER_NAME_CHARACTERISTIC_UUID = CBUUID(string:"2A29");
    
    var centralManager: CBCentralManager!;
    var HRMPeripheral: CBPeripheral!;

    var connected: Bool = false;
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        centralManager = CBCentralManager(delegate: self, queue: nil);
        

        
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
            
            println("connect")
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
        for service in peripheral.services{
            NSLog("Discovered service: \(service.UUID)")
            peripheral.discoverCharacteristics(nil, forService: service as CBService)
        }
    }
    
    //When you discover the characteristics of a specified service
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        if (service.UUID == HRM_HEART_RATE_SERVICE_UUID){
            for char in service.characteristics{
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
            for char in service.characteristics{
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
    
    
    
    //MARK:- CBCharacteristic helpers
    
    //Get the BPM info
    func getHeartBPMData(characteristic: CBCharacteristic!, error: NSError!){
        println("get BPM")
        var data = characteristic.value;
        var values = [UInt8](count:data.length, repeatedValue: 0)
        data.getBytes(&values, length: data.length);
        println(values);
        println("BPM: \(values[1])")
        
        self.speak("Heart rate is \(values[1]) beats per minute");
    }
    
    func getManufacturerName(characteristic: CBCharacteristic){
        
    }
    
    func getBodyLocation(characteristic: CBCharacteristic){
        
    }
    
    func speak(toSay: String){
        var mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
        var myString:String = toSay
        var mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:myString)
        
        println("\(mySpeechUtterance.speechString)")
        println("My string - \(myString)")
        mySpeechUtterance.rate = 0.2
        
        
        mySpeechSynthesizer .speakUtterance(mySpeechUtterance)

    }

}

