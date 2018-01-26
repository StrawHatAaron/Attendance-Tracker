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
    
    
    @IBOutlet weak var labelCount: UILabel!
    
    let tCheck_NAME = "t2_proto"
    let tCheck_SCRATCH_UUID         = CBUUID(string: "a495ff21-c5b1-4b44-b512-1370f02d74de")
    let tCheck_SERVICE_UUID         = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
    let tCheck_TX_CHARACTERISTIC    = CBUUID(string:"6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
    let tCheck_RX_CHARACTERISTIC    = CBUUID(string:"6E400003-B5A3-F393-E0A9-E50E24DCCA9E")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager(delegate: self, queue: nil)

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
    
    
    private func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String: AnyObject], RSSI: NSNumber) {
        print("centralManager BluetoothVC")
        let device = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey)
            as? NSString
        if device?.contains(tCheck_NAME) == true {
            self.manager.stopScan()
            self.peripheral = peripheral
            self.peripheral.delegate = self
            manager.connect(peripheral, options: nil)
            print("connection")
        }
    }
    
    func centralManager(
        central: CBCentralManager,
        didConnectPeripheral peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        for service in peripheral.services! {
            let thisService = service as CBService
            if service.uuid == tCheck_SERVICE_UUID {
                peripheral.discoverCharacteristics(nil, for: thisService)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        for characteristic in service.characteristics! {
            let thisCharacteristic = characteristic as CBCharacteristic
            if thisCharacteristic.uuid == tCheck_SCRATCH_UUID {
                self.peripheral.setNotifyValue(true, for: thisCharacteristic)
            }
        }
    }
    
    func peripheral(
        peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        var count:UInt32 = 0;
        if characteristic.uuid == tCheck_SCRATCH_UUID {
            //characteristic.value!.getBytes(&count, length: sizeof(UInt32))
            labelCount.text = NSString(format: "%llu", count) as String
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        central.scanForPeripherals(withServices: nil, options: nil)
    }
    
}
