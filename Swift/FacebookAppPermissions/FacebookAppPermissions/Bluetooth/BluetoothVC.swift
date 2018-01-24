//
//  BluetoothVC.swift
//  FacebookAppPermissions
//
//  Created by Aaron Miller on 1/24/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothVC: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var manager:CBCentralManager!
    var peripheral:CBPeripheral!
    
    let tCheck_NAME = "Robu"
    let tCheck_SCRATCH_UUID = CBUUID(string: "a495ff21-c5b1-4b44-b512-1370f02d74de")
    let tCheck_SERVICE_UUID = CBUUID(string: "a495ff20-c5b1-4b44-b512-1370f02d74de")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager(delegate: self, queue: nil)
        print("manager")
        
    }

    //after manager is made in view did load this is automagically called
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
            print("Bluetooth available")
        } else {
            print("Bluetooth NOT available.")
        }
    }
    
    
    //LEFT OFF HERE ON STEP 7
    private func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        let device = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey)
            as? NSString
        
        if device?.contains(tCheck_NAME) == true {
            self.manager.stopScan()
            self.peripheral = peripheral
            self.peripheral.delegate = self
            
            manager.connect(peripheral, options: nil)
        }
    }
}
