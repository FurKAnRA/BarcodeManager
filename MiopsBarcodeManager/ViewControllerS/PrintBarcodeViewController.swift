//
//  PrintBarcodeViewController.swift
//  MiopsBarcodeManager
//
//  Created by Furkan Kara on 29.12.2020.
//

import UIKit
import CoreBluetooth

class PrintBarcodeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CBCentralManagerDelegate,CBPeripheralDelegate {
   
    
    

    @IBOutlet weak var tableView: UITableView!
    var names = [String]()
    var images = [UIImage]()
    
    var assetsImages = ["Remote","Smart"]
    
    
    
   
   
    var centralManager = CBCentralManager()
    var peripherals  = [CBPeripheral]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
       
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
       
        
     

    }
    
 

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return 110
        
    }
    
    
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "barcodeCell") as! CellView
            cell.cihazImage.layer.cornerRadius = 5
            cell.cihazImage.image = images[indexPath.row]
            cell.nameLabel.text = names[indexPath.row]
            cell.printBarcodeButton.addTarget(self, action: #selector(printBarcodeButton(sender:)), for: .touchUpInside)
            cell.printBarcodeButton.tag = indexPath.row
            return cell
         
        }

    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral)
        {
        
            let localName = peripheral.name
            
            
            
            if localName != nil && ((localName?.contains("MIOPS")) != nil)
            {
                peripherals.append(peripheral)
                names.append(String((localName)!))
                for i in 0 ... assetsImages.count - 1{
                    if ((localName?.contains(assetsImages[i])) != nil) {
                        images.append(UIImage(named: assetsImages[i])!)
                    }
                    
                }
                
                
            
                tableView.reloadData()
                
            }
            
           
            
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn){
            let miopsRemoteUUID  = CBUUID(string: "0000fff0-0000-1000-8000-00805f9b34fb")
            self.centralManager.scanForPeripherals(withServices:[miopsRemoteUUID], options: nil)
            
                }
    
    }

    
    @objc func printBarcodeButton(sender : UIButton){

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let PrinterViewController = storyboard.instantiateViewController(withIdentifier: "PrinterConnectView") as! PrinterConnectView
       
        
        let buttonTag = sender.tag
        

        print(names[buttonTag])
     
        PrinterViewController.valueWrite(name : names[buttonTag])
        PrinterViewController.showToast(message: "Printed")
        
        

     
    }
    
    
    
    
    

}

extension Data {

    var hexString: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }


}
