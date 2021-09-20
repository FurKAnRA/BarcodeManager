
import UIKit
import CoreBluetooth

class PrinterConnectView: UIViewController,UITableViewDelegate,UITableViewDataSource,CBCentralManagerDelegate,CBPeripheralDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var names = [String]()
    var images = [UIImage]()
    var peripheralName = String()
    
    var centralManager = CBCentralManager()
    var peripherals	  = [CBPeripheral]()
    static var printer : CBPeripheral? = nil
    static var characteristicUUID : CBCharacteristic? = nil
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
       
      centralManager = CBCentralManager(delegate: self, queue: nil)

    }
    
 
    static let sendCommandIdentifier = CBUUID(string: "00000003-710E-4A5B-8D75-3E5B444BC3CF")
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return 110
        
    }
    
    
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "printerBarcodeCell") as! printerCellView

            cell.cihazImage.image = images[indexPath.row]
            cell.cihazName.text = names[indexPath.row]
            cell.connectButton.addTarget(self, action: #selector(connectButton(sender:)), for: .touchUpInside)
            cell.connectButton.tag = indexPath.row
            return cell
         
        }

    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
         
       
        if (!peripherals.contains(peripheral) && peripheral.name != nil  && peripheral.name?.contains("MQR") == true)
        {
            let localName = peripheral.name
    
                peripherals.append(peripheral)
                    
                names.append(String((localName)!))
                
                images.append(UIImage(named: "printer")!)
                    
                tableView.reloadData()
            
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn)
        {
            
            self.centralManager.scanForPeripherals(withServices: nil, options: nil)
            
        }
    
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        
        PrinterConnectView.printer = peripheral
        
        let printerServicesUUID  = CBUUID(string: "00000001-710E-4A5B-8D75-3E5B444BC3CF")
    
        peripheral.delegate = self
        peripheral.discoverServices([printerServicesUUID])
        
        showToast(message: "CONNECTED")
       
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?)
    {
    
        if let services = peripheral.services
        {
            for service in services
            {
                           
            peripheral.discoverCharacteristics(nil, for: service)
                
            }
                      
               
        }

    }
           

    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)
    {
        
        
        if let characteristics = service.characteristics
        {
            for characteristic in characteristics
        
            {
                print(characteristic)
                if characteristic.uuid == PrinterConnectView.sendCommandIdentifier
                {
                   
                    DispatchQueue.main.async
                    {
                        PrinterConnectView.characteristicUUID = characteristic
                    }

                }
              
                
        
            }
            
            
        }
        
       
    }
    
    
    @objc func connectButton(sender : UIButton){
        
        let buttonTag = sender.tag
        centralManager.connect(peripherals[buttonTag])

        print(peripherals[buttonTag])
     
    }
    
    
    func valueWrite(name : String){
        let str =  name
  
         let size = str.utf8.count
         let hexaSize = String(format:"%02X", size)
         let hexString = str.data(using: .ascii)!.hexString
         
        
         
        var splitString = [String]()
         var i = 0
         var temp = ""
         for ch in hexString
         {
             if(i > 1)
             {
                i  = 0
                 temp = ""
             }
             if(i <= 1)
             {
                 temp.append(ch)
                 if(i == 1)
                 {
                     splitString.append(temp)
                 }
             }
             i = i + 1
         }
        
        
         var packetCount = 0
        
        
         		if( splitString.count % 19 == 0)
         {
             packetCount = splitString.count/19
         }
         else
         {
             packetCount = splitString.count/19 + 1
         }
        
         var firstPacket = ["1\(packetCount)","01","\(hexaSize)"]
        
         for i  in 0 ... 17
         {
             
             if (i < 17 && splitString.count > 0)
             {
                 firstPacket.append(splitString[0])
                 splitString.remove(at: 0)
                 
             }
         }
         
        
        
        let firstPacketData = NSMutableData()
        for a in firstPacket {
            let string = a
            let data = string.hexaData
            firstPacketData.append(data)

        }
       
        
        
        PrinterConnectView.printer!.writeValue(firstPacketData as Data, for: PrinterConnectView.characteristicUUID!, type: .withResponse)
        
         
        
         for a in 2 ... packetCount {
             var otherPackets = ["\(a)\(packetCount)"]
            for _  in 0 ... splitString.count-1{
                 if( otherPackets.count <  20 ){
                     otherPackets.append(splitString[0])
                     splitString.remove(at: 0)
                    
                 }
                 else{
                     continue
                 }
                 
                 
                 
             }
            
             
            let otherPacketsData = NSMutableData()
            for a in otherPackets {
                let string = a
                let data = string.hexaData
                otherPacketsData.append(data)

            }
            
           
            PrinterConnectView.printer!.writeValue(otherPacketsData as Data, for: PrinterConnectView.characteristicUUID!, type: .withResponse)
            
         }
         showToast(message: "PRİNTED")
    }
   
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
    

   
}

extension StringProtocol {
    var hexaData: Data { .init(hexa) }
    var hexaBytes: [UInt8] { .init(hexa) }
    private var hexa: UnfoldSequence<UInt8, Index> {
        sequence(state: startIndex) { startIndex in
            guard startIndex < self.endIndex else { return nil }
            let endIndex = self.index(startIndex, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
            defer { startIndex = endIndex }
            return UInt8(self[startIndex..<endIndex], radix: 16)
        }
    }
}
