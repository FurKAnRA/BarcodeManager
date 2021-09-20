//
//  ReadBarcodeViewController.swift
//  MiopsBarcodeManager
//
//  Created by Furkan Kara on 2.01.2021.
//

import UIKit
import AVFoundation

class ReadBarcodeViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
                captureSession = AVCaptureSession()

                guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
                let videoInput: AVCaptureDeviceInput

                do {
                    videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
                } catch {
                    return
                }

                if (captureSession.canAddInput(videoInput)) {
                    captureSession.addInput(videoInput)
                } else {
                    failed()
                    return
                }

                let metadataOutput = AVCaptureMetadataOutput()

                if (captureSession.canAddOutput(metadataOutput)) {
                    captureSession.addOutput(metadataOutput)

                    metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    metadataOutput.metadataObjectTypes = [.qr]
                } else {
                    failed()
                    return
                }

                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer.frame = view.layer.bounds
                previewLayer.videoGravity = .resizeAspectFill
                view.layer.addSublayer(previewLayer)

                captureSession.startRunning()
        
    }
    func failed() {
           let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
           ac.addAction(UIAlertAction(title: "OK", style: .default))
           present(ac, animated: true)
           captureSession = nil
       }



       func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
           
        captureSession.stopRunning()
           if let metadataObject = metadataObjects.first {
               guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
               guard let stringValue = readableObject.stringValue else { return }
               found(code: stringValue)
           
           }
        


       }

       func found(code: String) {
        let alert = UIAlertController(title: "Successful", message: code , preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
            self.captureSession.startRunning()
        }
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
       }

      
    
    
    
    
    }
    

    


