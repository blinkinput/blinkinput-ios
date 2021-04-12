//
//  ViewController.swift
//  pdf417-sample-Swift
//
//  Created by Dino on 17/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

import UIKit
import BlinkInput

class ViewController: UIViewController {
    
    var barcodeRecognizer : MBIBarcodeRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Valid until:2022-02-06
        MBIMicroblinkSDK.shared().setLicenseResource("license", withExtension: "txt", inSubdirectory: "", for: .main) { (_) in
        }
    }
    
    @IBAction func didTapCustomUI(_ sender: Any) {
        
        /** Create barcode recognizer */
        self.barcodeRecognizer = MBIBarcodeRecognizer()
        self.barcodeRecognizer?.scanQrCode = true
                
        /** Crate recognizer collection */
        let recognizerList = [self.barcodeRecognizer!]
        let recognizerCollection : MBIRecognizerCollection = MBIRecognizerCollection(recognizers: recognizerList)
        
        /** Create your overlay view controller */
        let customOverlayViewController : CustomOverlay = CustomOverlay.initFromStoryboardWith()
        
        /** This has to be called for custom controller */
        customOverlayViewController.reconfigureRecognizers(recognizerCollection)
        
        /** Create recognizer view controller with wanted overlay view controller */
        let recognizerRunneViewController : UIViewController = MBIViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: customOverlayViewController)!
        
        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        self.present(recognizerRunneViewController, animated: true, completion: nil)
    }
    @IBAction func didTapScan(_ sender: AnyObject) {
        
        /** Create barcode recognizer */
        self.barcodeRecognizer = MBIBarcodeRecognizer()
        self.barcodeRecognizer?.scanQrCode = true
                
        /** Create barcode settings */
        let settings : MBIBarcodeOverlaySettings = MBIBarcodeOverlaySettings()
        
        /** Crate recognizer collection */
        let recognizerList = [self.barcodeRecognizer!]
        let recognizerCollection : MBIRecognizerCollection = MBIRecognizerCollection(recognizers: recognizerList)
        
        /** Create your overlay view controller */
        let barcodeOverlayViewController : MBIBarcodeOverlayViewController = MBIBarcodeOverlayViewController(settings: settings, recognizerCollection: recognizerCollection, delegate: self)
        
        /** Create recognizer view controller with wanted overlay view controller */
        let recognizerRunneViewController : UIViewController = MBIViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: barcodeOverlayViewController)!
        
        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        self.present(recognizerRunneViewController, animated: true, completion: nil)
    }
}

extension ViewController: MBIBarcodeOverlayViewControllerDelegate {
    
    func barcodeOverlayViewControllerDidFinishScanning(_ barcodeOverlayViewController: MBIBarcodeOverlayViewController, state: MBIRecognizerResultState) {
        /** This is done on background thread */
        barcodeOverlayViewController.recognizerRunnerViewController?.pauseScanning()
        
        var message: String = ""
        var title: String = ""
        
        if (self.barcodeRecognizer!.result.resultState == MBIRecognizerResultState.valid) {
            title = "QR Code"
            
            // Save the string representation of the code
            message = self.barcodeRecognizer!.result.stringData!
        }
        
        /** Needs to be called on main thread beacuse everything prior is on background thread */
        DispatchQueue.main.async {
            // present the alert view with scanned results
            
            let alertController: UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            let okAction: UIAlertAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default,
                                                             handler: { (action) -> Void in
                                                                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(okAction)
            barcodeOverlayViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    func barcodeOverlayViewControllerDidTapClose(_ barcodeOverlayViewController: MBIBarcodeOverlayViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

