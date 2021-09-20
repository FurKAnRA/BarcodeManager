//
//  ViewController.swift
//  MiopsBarcodeManager
//
//  Created by Furkan Kara on 29.12.2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var printBarcodeButton: UIButton!
    @IBOutlet weak var readBarcodeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     

    
        customizeButton(buttonName: printBarcodeButton)
        customizeButton(buttonName: readBarcodeButton)
        
     
       
    
        
    }
    
    func customizeButton(buttonName : UIButton){
        buttonName.layer.cornerRadius = 9
        buttonName.layer.borderWidth = 0.8
    }
    
    

   
    



}


