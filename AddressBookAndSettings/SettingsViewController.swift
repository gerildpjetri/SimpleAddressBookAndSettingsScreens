//
//  SettingsViewController.swift
//  AddressBookAndSettings
//
//  Created by Gerild Pjetri on 20.11.20.
//

import UIKit



var menuController: UIMenuController?


class SettingsViewController: UIViewController , ScanProtocol {
    
    

    
    
    
    
    
    
    @IBOutlet weak var containerViewScan: UIView!
    
    
    @IBOutlet weak var imageViewQR: UIImageView!
    
    
    
    @IBOutlet weak var AppInfoLabel: UILabel!
    
    @IBOutlet weak var WalletIDLabel: UILabel!
    
    @IBOutlet weak var WalletIDCopyableShareable: UILabel!
    
    @IBOutlet weak var VersionLabel: UILabel!
    
    var childQRKodVC : ScanViewController!
    
    var scanResult : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        AppInfoLabel.isHidden = false
        WalletIDLabel.isHidden = false
        WalletIDCopyableShareable.isHidden = false
        VersionLabel.isHidden = false
        
        
        childQRKodVC = ScanViewController(nibName: "CameraScan", bundle: nil)
        
        
        childQRKodVC.containerViewDelegate = self
        
    }
    

    
    func generateQRCode(from string: String) -> UIImage?
        {
            let data = string.data(using: String.Encoding.ascii)

            if let filter = CIFilter(name: "CIQRCodeGenerator")
            {
                filter.setValue(data, forKey: "inputMessage")

                guard let qrImage = filter.outputImage else {return nil}
                let scaleX = self.imageViewQR.frame.size.width / qrImage.extent.size.width
                let scaleY = self.imageViewQR.frame.size.height / qrImage.extent.size.height
                let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)

                if let output = filter.outputImage?.transformed(by: transform)
                {
                    return UIImage(ciImage: output)
                }
            }
            return nil
        }
    
    
    
    
    @IBAction func goToAddressBook(_ sender: Any) {
        
        let vc = AddressBookViewController(nibName: "AddressBookScreen", bundle: nil)
        
        //let viewController = Settings()
        vc.modalPresentationStyle = .fullScreen
        
        self.present(vc,animated:false)
        
        
        
        
        
    }
    
    func showResult(result: String) {
        
        
//        childQRKodVC.willMove(toParent: nil)
//        childQRKodVC.view.removeFromSuperview()
//        childQRKodVC.removeFromParent()
        
        scanResult = result
        
        
        let alert = UIAlertController(title: "Information!", message: "Scan is OK!", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: {  action in

            self.imageViewQR.isHidden = true
            self.AppInfoLabel.isHidden = false
            self.WalletIDLabel.isHidden = false
            self.WalletIDCopyableShareable.isHidden = false
            self.VersionLabel.isHidden = false
         
         self.childQRKodVC.willMove(toParent: nil)
         self.childQRKodVC.view.removeFromSuperview()
         self.childQRKodVC.removeFromParent()
            
            
        }))

        self.present(alert, animated: true)
        
    }
    
    @IBAction func scanQRCode(_ sender: Any) {
        
        
        imageViewQR.isHidden = true
        AppInfoLabel.isHidden = true
        WalletIDLabel.isHidden = true
        WalletIDCopyableShareable.isHidden = true
        VersionLabel.isHidden = true
        scanResult=""
        
        addChild(childQRKodVC)
        //Or, you could add auto layout constraint instead of relying on AutoResizing contraints
        childQRKodVC.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        childQRKodVC.view.frame = containerViewScan.bounds
        
        containerViewScan.addSubview(childQRKodVC.view)
        childQRKodVC.didMove(toParent: self)
        
        
        _ = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(checkResultQRScanning), userInfo: nil, repeats: false)

        
        
        
    }
    
    
    @objc func checkResultQRScanning()
    {
        if (scanResult == ""){
            
            imageViewQR.isHidden = true
            AppInfoLabel.isHidden = false
            WalletIDLabel.isHidden = false
            WalletIDCopyableShareable.isHidden = false
            VersionLabel.isHidden = false
            
            childQRKodVC.willMove(toParent: nil)
            childQRKodVC.view.removeFromSuperview()
            childQRKodVC.removeFromParent()
        }
    }
    
    
    @IBAction func addQRCode(_ sender: Any) {
        
        imageViewQR.isHidden = false
        
        imageViewQR.image = generateQRCode(from: "https://bitly.com/" )
        
        childQRKodVC.willMove(toParent: nil)
        childQRKodVC.view.removeFromSuperview()
        childQRKodVC.removeFromParent()
        
        imageViewQR.isHidden = false
        AppInfoLabel.isHidden = true
        WalletIDLabel.isHidden = true
        WalletIDCopyableShareable.isHidden = true
        VersionLabel.isHidden = true
        
    }
    
    
    @IBAction func help(_ sender: Any) {
        
        UIApplication.shared.open(NSURL(string: "https://bitly.com/")! as URL)
        
        
    }
    
}





class JDLabel : UILabel {
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("required init")
        sharedInit()
        showLabelMenu()
    }
    
    func showLabelMenu()
    {
        menuController = UIMenuController.shared
        menuController?.isMenuVisible = true
        menuController?.arrowDirection = UIMenuController.ArrowDirection.down
        
        menuController?.setTargetRect(CGRect.zero, in: self)
        
        let menuItem_1: UIMenuItem = UIMenuItem(title: "Share", action: #selector(JDLabel.onMenu1(sender:)))
//        let menuItem_2: UIMenuItem = UIMenuItem(title: "Menu 2", action: #selector(JDLabel.onMenu2(sender:)))
//        let menuItem_3: UIMenuItem = UIMenuItem(title: "Menu 3", action: #selector(JDLabel.onMenu3(sender:)))
        
        //let myMenuItems: [UIMenuItem] = [menuItem_1, menuItem_2, menuItem_3]
        
        let myMenuItems: [UIMenuItem] = [menuItem_1]
        menuController?.menuItems = myMenuItems
    }
    
    func sharedInit() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer(
            target: self,
            action: #selector(firstResponder(sender:))
        ))
    }
    
    @objc func firstResponder(sender: Any?) {
        becomeFirstResponder()
        menuController?.setTargetRect(bounds, in: self)
        menuController?.setMenuVisible(true, animated: true)
        menuController?.update()
    }
    
    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
        UIMenuController.shared.setMenuVisible(false, animated: true)
    }
    
    
//    override func share(_ sender: Any?) {
//
//        UIPasteboard.general.string = text
//        UIMenuController.shared.setMenuVisible(false, animated: true)
//    }
    
    @objc public func onMenu1(sender: UIMenuItem) {
        print("onMenu1 label")
        
            let text = self.text
       
            let textShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textShare as [Any] , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = UIApplication.shared.keyWindow!.rootViewController!.view
            UIApplication.shared.keyWindow!.rootViewController!.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc public func onMenu2(sender: UIMenuItem) {
        print("onMenu2 label")
    }
    
    @objc public func onMenu3(sender: UIMenuItem) {
        print("onMenu3 label")
        
        let menuItem4: UIMenuItem = UIMenuItem(title: "Menu 4", action: #selector(onMenu4(sender:)))
        let myIndex = menuController?.menuItems?.firstIndex(where: {$0.title == "Menu 3"})
        menuController?.menuItems?.remove(at: myIndex!)
        menuController?.menuItems?.insert(menuItem4, at:  myIndex!)
        
        menuController?.update()
        
    }
    
    @objc public func onMenu4(sender: UIMenuItem) {
        let menuItem3: UIMenuItem = UIMenuItem(title: "Menu 3", action: #selector(onMenu3(sender:)))
        let myIndex = menuController?.menuItems?.firstIndex(where: {$0.title == "Menu 4"})
        menuController?.menuItems?.remove(at: myIndex!)
        menuController?.menuItems?.insert(menuItem3, at:  myIndex!)
        menuController?.update()
        print("onMenu4 label")
    }
    
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        //return true
        
        if action == #selector(copy(_:)){
            return true
        }

//        if [#selector(onMenu1(sender:)), #selector(onMenu2(sender:)),#selector(onMenu3(sender:)),#selector(onMenu4(sender:))].contains(action) {
//            return true
//        } else {
//            return false
//        }
        
        
        if [#selector(onMenu1(sender:))].contains(action) {
            return true
        } else {
            return false
        }
    }
    
}
