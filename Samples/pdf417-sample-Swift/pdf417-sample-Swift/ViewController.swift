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
    
    var pdf417Recognizer : MBINPdf417Recognizer?
    var barcodeRecognizer : MBINBarcodeRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Valid until: 2021-08-23
        MBINMicroblinkSDK.shared().setLicenseResource("license", withExtension: "txt", inSubdirectory: "", for: Bundle.main) { (error) in
            print("License error: \(error)")
        }
    }
    
    @IBAction func didTapCustomUI(_ sender: Any) {
        
        /** Create barcode recognizer */
        self.barcodeRecognizer = MBINBarcodeRecognizer()
        self.barcodeRecognizer?.scanQrCode = true
        
        self.pdf417Recognizer = MBINPdf417Recognizer()
        
        /** Crate recognizer collection */
        let recognizerList = [self.barcodeRecognizer!, self.pdf417Recognizer!]
        let recognizerCollection : MBINRecognizerCollection = MBINRecognizerCollection(recognizers: recognizerList)
        
        /** Create your overlay view controller */
        let customOverlayViewController : CustomOverlay = CustomOverlay.initFromStoryboardWith()
        
        /** This has to be called for custom controller */
        customOverlayViewController.reconfigureRecognizers(recognizerCollection)
        
        /** Create recognizer view controller with wanted overlay view controller */
        let recognizerRunneViewController : UIViewController = MBINViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: customOverlayViewController)!
        
        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        self.present(recognizerRunneViewController, animated: true, completion: nil)
    }
    @IBAction func didTapScan(_ sender: AnyObject) {
        
        /** Create barcode recognizer */
        self.barcodeRecognizer = MBINBarcodeRecognizer()
        self.barcodeRecognizer?.scanQrCode = true
        
        self.pdf417Recognizer = MBINPdf417Recognizer()
        
        /** Create barcode settings */
        let settings : MBINBarcodeOverlaySettings = MBINBarcodeOverlaySettings()
        
        /** Crate recognizer collection */
        let recognizerList = [self.barcodeRecognizer!, self.pdf417Recognizer!]
        let recognizerCollection : MBINRecognizerCollection = MBINRecognizerCollection(recognizers: recognizerList)
        
        /** Create your overlay view controller */
        let barcodeOverlayViewController : MBINBarcodeOverlayViewController = MBINBarcodeOverlayViewController(settings: settings, recognizerCollection: recognizerCollection, delegate: self)
        
        /** Create recognizer view controller with wanted overlay view controller */
        let recognizerRunneViewController : UIViewController = MBINViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: barcodeOverlayViewController)!
        
        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        self.present(recognizerRunneViewController, animated: true, completion: nil)
    }
}

extension ViewController: MBINBarcodeOverlayViewControllerDelegate {
    
    func barcodeOverlayViewControllerDidFinishScanning(_ barcodeOverlayViewController: MBINBarcodeOverlayViewController, state: MBINRecognizerResultState) {
        /** This is done on background thread */
        barcodeOverlayViewController.recognizerRunnerViewController?.pauseScanning()
        
        var message: String = ""
        var title: String = ""
        
        if (self.barcodeRecognizer!.result.resultState == MBINRecognizerResultState.valid) {
            title = "QR Code"
            
            // Save the string representation of the code
            message = self.barcodeRecognizer!.result.stringData!
        }
        else if (self.pdf417Recognizer!.result.resultState == MBINRecognizerResultState.valid) {
            title = "PDF417"
            
            // Save the string representation of the code
            message = self.pdf417Recognizer!.result.stringData!
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
    
    func barcodeOverlayViewControllerDidTapClose(_ barcodeOverlayViewController: MBINBarcodeOverlayViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

