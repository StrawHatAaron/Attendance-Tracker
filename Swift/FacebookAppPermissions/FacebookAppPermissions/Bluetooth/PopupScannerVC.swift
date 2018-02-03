//
//  PopupScannerVC.swift
//  FacebookAppPermissions
//
//  Created by Aaron Miller on 1/29/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//
//  PopupVC.swift
//  FacebookAppPermissions
//
//  Created by Aaron Miller on 1/29/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit
import CoreBluetooth

class PopupScannerVC: UIViewController, CBCentralManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let tCheck_NAME = "Nordic_UART"
    let tCheck_SCRATCH_UUID         = CBUUID(string: "a495ff21-c5b1-4b44-b512-1370f02d74de")
    let tCheck_SERVICE_UUID         = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
    let tCheck_TX_CHARACTERISTIC    = CBUUID(string:"6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
    let tCheck_RX_CHARACTERISTIC    = CBUUID(string:"6E400003-B5A3-F393-E0A9-E50E24DCCA9E")
    
    let dfuServiceUUIDString  = "00001530-1212-EFDE-1523-785FEABCD123"
    let ANCSServiceUUIDString = "7905F431-B5CE-4E99-A40F-4B1E122D00D0"
    
    //ViewController Props
    var bluetoothManager:CBCentralManager?
    var delegate         : ScannerDelegate?
    var filterUUID       : CBUUID?
    var peripherals      : [ScannedPeripheral] = []
    var timer            : Timer?
    
    var peripheral:CBPeripheral?
    
    @IBOutlet weak var devicesTable: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    @objc
    func timerFire() {
        if peripherals.count > 0 {
            emptyView.isHidden = true
            devicesTable.reloadData()
        }
    }
    
    func getRSSIImage(RSSI anRSSIValue: Int32) -> UIImage {
        var image: UIImage
        if (anRSSIValue < -90) {
            image = UIImage(named: "Signal_0")!
        } else if (anRSSIValue < -70) {
            image = UIImage(named: "Signal_1")!
        } else if (anRSSIValue < -50) {
            image = UIImage(named: "Signal_2")!
        } else {
            image = UIImage(named: "Signal_3")!
        }
        return image
    }
    
    func getConnectedPeripherals() -> [CBPeripheral] {
        guard let bluetoothManager = bluetoothManager else {
            return []
        }
        var retreivedPeripherals : [CBPeripheral]
        if filterUUID == nil {
            let dfuServiceUUID       = CBUUID(string: dfuServiceUUIDString)
            let ancsServiceUUID      = CBUUID(string: ANCSServiceUUIDString)
            retreivedPeripherals     = bluetoothManager.retrieveConnectedPeripherals(withServices: [dfuServiceUUID, ancsServiceUUID])
        } else {
            retreivedPeripherals     = bluetoothManager.retrieveConnectedPeripherals(withServices: [filterUUID!])
        }
        return retreivedPeripherals
    }
    
    /**
     * Starts scanning for peripherals with rscServiceUUID.
     * - parameter enable: If YES, this method will enable scanning for bridge devices, if NO it will stop scanning
     * - returns: true if success, false if Bluetooth Manager is not in CBCentralManagerStatePoweredOn state.
     */
    func scanForPeripherals(_ enable:Bool) -> Bool {
        guard bluetoothManager?.state == .poweredOn //
            else {
                return false
        }
        DispatchQueue.main.async {
            if enable == true {
                let options: NSDictionary = NSDictionary(objects: [NSNumber(value: true as Bool)], forKeys: [CBCentralManagerScanOptionAllowDuplicatesKey as NSCopying])
                if self.filterUUID != nil {
                    self.bluetoothManager?.scanForPeripherals(withServices: [self.filterUUID!], options: options as? [String : AnyObject])
                }
                else {
                    self.bluetoothManager?.scanForPeripherals(withServices: nil, options: options as? [String : AnyObject])
                }
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerFire), userInfo: nil, repeats: true)
            }
            else {
                self.timer?.invalidate()
                self.timer = nil
                self.bluetoothManager?.stopScan()
                //print("This is when the scanning has stopped -- Aaron Miller")
            }
        }
        return true
    }
    
    override func viewDidLoad() {
        devicesTable.tableFooterView = UIView()
        super.viewDidLoad()
        devicesTable.delegate = self
        devicesTable.dataSource = self
        
        let activityIndicatorView              = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicatorView.hidesWhenStopped = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
        
        activityIndicatorView.startAnimating()
        
        let centralQueue = DispatchQueue(label: "no.nordicsemi.nRFToolBox--Aaron Miller", attributes: [])
        bluetoothManager = CBCentralManager(delegate: self, queue: centralQueue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let success = self.scanForPeripherals(false)
        if success == true{
            //print("everytime I hit Cancel")
        }
        if !success {
            print("Bluetooth is powered off!")
        }
        
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        super.viewWillDisappear(animated)
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(peripherals.count)
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Update cell content
        let scannedPeripheral = peripherals[indexPath.row]
        if scannedPeripheral.name() == "Nordic_UART"{
            let aCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            aCell.textLabel?.text = scannedPeripheral.name()
            if scannedPeripheral.isConnected == true {
                aCell.imageView!.image = UIImage(named: "Connected")
            } else {
                let RSSIImage = self.getRSSIImage(RSSI: scannedPeripheral.RSSI)
                aCell.imageView!.image = RSSIImage
            }
            return aCell
        }
        else{
            return tableView.dequeueReusableCell(withIdentifier: "Cell")!
        }
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bluetoothManager!.stopScan()
        // Call delegate method
        let peripheral = peripherals[indexPath.row].peripheral
        if peripheral.name != nil{
            print("\(peripheral.name!) was the choosen device name")
        }
        self.delegate?.centralManagerDidSelectPeripheral(withManager: bluetoothManager!, andPeripheral: peripheral)
        self.dismiss(animated: true, completion: nil)
    }
    
    //after manager is made in view did load this is automagically called
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        guard central.state == .poweredOn else{
            print("Bluetooth is most likely off")
            return
        }
        print("Bluetooth is on")
        let connectedPeripherals = self.getConnectedPeripherals()
        var newScannedPeripherals: [ScannedPeripheral] = []
        connectedPeripherals.forEach { (connectedPeripheral: CBPeripheral) in
            let connected = connectedPeripheral.state == .connected
            let scannedPeripheral = ScannedPeripheral(withPeripheral: connectedPeripheral, andIsConnected: connected )
            newScannedPeripherals.append(scannedPeripheral)
        }
        peripherals = newScannedPeripherals
        let success = self.scanForPeripherals(true)
        if !success {
            print("Bluetooth is powered off!")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Scanner uses other queue to send events. We must edit UI in the main queue
        DispatchQueue.main.async(execute: {
            var sensor = ScannedPeripheral(withPeripheral: peripheral, andRSSI: RSSI.int32Value, andIsConnected: false)
            if ((self.peripherals.contains(sensor)) == false) {
                self.peripherals.append(sensor)
            }else{
                sensor = self.peripherals[self.peripherals.index(of: sensor)!]
                sensor.RSSI = RSSI.int32Value
            }
        })
    }
    
}


