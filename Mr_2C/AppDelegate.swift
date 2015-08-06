//
//  AppDelegate.swift
//  Mr_2C
//
//  Created by Leff on 15/7/13.
//  Copyright (c) 2015年 LeffPan. All rights reserved.
//

import UIKit
import CoreBluetooth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CBPeripheralDelegate, CBCentralManagerDelegate {

    var window: UIWindow?
    
    //设备的唯一识别码 —— Set device's UUID
    let deviceUUID = UIDevice.currentDevice().identifierForVendor
    //服务的UUID —— Set service's UUID
    let kServiceUUID: String = "C4FB2349-72FE-4CA2-94D6-1F3CB16222AA"
    //特征的UUID —— Set characteristic's UUID
    let kCharacteristicUUID_1: String = "6A3E4B28-522D-4B3B-82A9-D5E2004534FA"
    let kCharacteristicUUID_2: String = "6A3E4B28-522D-4B3B-82A9-D5E2004534FB"
    let kCharacteristicUUID_3: String = "6A3E4B28-522D-4B3B-82A9-D5E2004534FC"

    var discovered = false
    var centralManager: CBCentralManager!
    var connectingPeripheral: CBPeripheral!
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        startUpCentralManager()
        
        return true
    }
    
    func startUpCentralManager() {
        self.centralManager = CBCentralManager.init(delegate: self, queue: nil, options:[CBCentralManagerOptionRestoreIdentifierKey:"centralRestoreKey"])
    }
    
    func discoverDevices() {
        
        if(connectingPeripheral != nil) {
            centralManager.cancelPeripheralConnection(connectingPeripheral)
        }
        centralManager.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        
//        centralManager.scanForPeripheralsWithServices([ transformStringToCBUUID(kServiceUUID) ], options: nil)
        var msg = ""
        switch (central.state) {
        case .PoweredOff:
            msg = "CoreBluetooth BLE hardware is powered off"
            println("\(msg)")
            
        case .PoweredOn:
            msg = "CoreBluetooth BLE hardware is powered on and ready"
            if(!discovered) {
                discovered = true
                discoverDevices()
            }
            
        case .Resetting:
            var msg = "CoreBluetooth BLE hardware is resetting"
            
        case .Unauthorized:
            var msg = "CoreBluetooth BLE state is unauthorized"
            
        case .Unknown:
            var msg = "CoreBluetooth BLE state is unknown"
            
        case .Unsupported:
            var msg = "CoreBluetooth BLE hardware is unsupported on this platform"
            
        }
        println(msg)
        
    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        
        println(peripheral.name)
        if(peripheral.name == "“Leff”的 iPad") {
            println("Connecting to Leff")
            self.connectingPeripheral = peripheral
            centralManager.stopScan()
            self.centralManager.connectPeripheral(peripheral, options: nil)
        } else {
            println("skipped " + peripheral.name )
        }
//        self.centralManager.connectPeripheral(peripheral, options: [CBConnectPeripheralOptionNotifyOnConnectionKey:"peripheralOptionNotifyOnConnectionKey"])
        
    }
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        
//        let characteristic1:CBUUID = CBUUID.init(string: kCharacteristicUUID_1)
//        let characteristic2:CBUUID = CBUUID.init(string: kCharacteristicUUID_2)
//        let characteristic3:CBUUID = CBUUID.init(string: kCharacteristicUUID_3)
//        
//        var characteristicArray:[CBUUID] = [characteristic1,characteristic2,characteristic3]
        
//        peripheral.discoverCharacteristics(characteristicArray, forService:peripheral.services.first as! CBService )
        peripheral.delegate = self
        peripheral.discoverServices([ transformStringToCBUUID(kServiceUUID) ])
        
    }
    
    func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println(error.localizedDescription)
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        let characteristic1:CBUUID = CBUUID.init(string: kCharacteristicUUID_1)
        let characteristic2:CBUUID = CBUUID.init(string: kCharacteristicUUID_2)
        let characteristic3:CBUUID = CBUUID.init(string: kCharacteristicUUID_3)
        
        var characteristicArray:[CBUUID] = [characteristic1,characteristic2,characteristic3]
        
//        CBService.init(UUID: transformStringToCBUUID(kServiceUUID), primary: true)
        
        peripheral.discoverCharacteristics(characteristicArray, forService:peripheral.services.first as! CBService )
        
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        
//        var characteristicsToBeRead: [CBCharacteristic] = service.characteristics as! [CBCharacteristic]
        
//        for characteristicItem in characteristicsToBeRead {
//            peripheral.readValueForCharacteristic(characteristicItem)
//        }
        
        if let characteristicsToBeRead = service.characteristics  as? [CBCharacteristic]
        {
            for characteristicItem in characteristicsToBeRead
            {
                peripheral.setNotifyValue(true, forCharacteristic: characteristicItem)
                
                if characteristicItem.UUID.UUIDString == kCharacteristicUUID_1{
                    println("read c1")
                    peripheral.readValueForCharacteristic(characteristicItem)
                } else if characteristicItem.UUID.UUIDString == kCharacteristicUUID_2 {
                    println("read c2")
                    peripheral.readValueForCharacteristic(characteristicItem)
                } else if characteristicItem.UUID.UUIDString == kCharacteristicUUID_3 {
                    println("read c3")
                    peripheral.readValueForCharacteristic(characteristicItem)
                }
            }
            
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        
        var datastring = NSString(data: characteristic.value!, encoding: NSUTF8StringEncoding)
        var dataToString: String = datastring as! String
        println(dataToString)
    }

    func centralManager(central: CBCentralManager!, willRestoreState dict: [NSObject : AnyObject]!) {
        
    }
    
    func transformStringToCBUUID(stringToBeTrans: String) -> CBUUID!{
        let returnCBUUID:CBUUID = CBUUID.init(string: stringToBeTrans)
        return returnCBUUID
    }

}

