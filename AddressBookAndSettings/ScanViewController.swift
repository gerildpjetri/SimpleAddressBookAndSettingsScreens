//
//  ScanViewController.swift
//  AddressBookAndSettings
//
//  Created by Gerild Pjetri on 20.11.20.
//

import AVFoundation
import UIKit


protocol ScanProtocol {
    
    
    //var resultCode:String? { get set }
    
    func showResult(result: String)
        
}

class ScanViewController: UIViewController , AVCaptureMetadataOutputObjectsDelegate{

    
    
    var containerViewDelegate: ScanProtocol?
    
    @IBOutlet weak var logoImageInCodeReader: UIImageView!
    
    @IBOutlet weak var focusViewScan: UIView!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    
    
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var content: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        contentLabel.text = "Content QR"
        
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
            metadataOutput.metadataObjectTypes = [.qr,
                                                  .code128,
                                                  .code39,
                                                  .code39Mod43,
                                                  .code93,
                                                  .ean8,
                                                  .interleaved2of5,
                                                  .itf14,
                                                  .pdf417,
                                                  .upce ]
            
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(previewLayer)
        self.view.bringSubviewToFront(contentLabel)
        self.view.bringSubviewToFront(content)
        captureSession.startRunning()

        
    }
    
    
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            contentLabel.text = stringValue
            
            found(code: stringValue)
        }

        //dismiss(animated: true)
    }

    func found(code: String) {
        
        print(code)
        containerViewDelegate?.showResult(result: code)
        
        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    

    

}
