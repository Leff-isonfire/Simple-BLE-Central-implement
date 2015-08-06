//
//  ViewController.swift
//  Mr_2C
//
//  Created by Leff on 15/7/13.
//  Copyright (c) 2015年 LeffPan. All rights reserved.
//

import UIKit
import CoreBluetooth

let userName:String = "Leff's"
//设备的唯一识别码
let deviceUUID = UIDevice.currentDevice().identifierForVendor
//服务的UUID
let kServiceUUID:String = "C4FB2349-72FE-4CA2-94D6-1F3CB16222AA"
//特征的UUID
let kCharacteristicUUID_1:String = "6A3E4B28-522D-4B3B-82A9-D5E2004534FA"
let kCharacteristicUUID_2:String = "6A3E4B28-522D-4B3B-82A9-D5E2004534FB"
let kCharacteristicUUID_3:String = "6A3E4B28-522D-4B3B-82A9-D5E2004534FC"

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}