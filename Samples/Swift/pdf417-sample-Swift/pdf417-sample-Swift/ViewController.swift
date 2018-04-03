//
//  ViewController.swift
//  pdf417-sample-Swift
//
//  Created by Dino on 17/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

import UIKit
import MicroBlink

class ViewController: UIViewController, MBCustomOverlayViewControllerDelegate, MBBarcodeOverlayViewControllerDelegate {
    
    var pdf417Recognizer : MBPdf417Recognizer?
    var barcodeRecognizer : MBBarcodeRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Valid until: 2018-04-29
        MBMicroblinkSDK.sharedInstance().setLicenseResource("license-pdf-swift", withExtension: "txt", inSubdirectory: "License", for: Bundle.main)
    }
    
    func createScanSettings() -> MBSettings {
        /** Create barcode recognizer */
        self.barcodeRecognizer = MBBarcodeRecognizer()
        self.barcodeRecognizer?.scanPdf417 = true
        
        self.pdf417Recognizer = MBPdf417Recognizer()
        
        /** Create barcode settings */
        let settings : MBSettings = MBSettings()
        
        /** Crate recognizer collection */
        let recognizerList : Array = [self.barcodeRecognizer!, self.pdf417Recognizer!] as! [MBRecognizer]
        let recognizerCollection : MBRecognizerCollection = MBRecognizerCollection(recognizers: recognizerList)
        
        /** Add recognizer collection to barcode settings */
        settings.uiSettings.recognizerCollection = recognizerCollection
        return settings;
    }
    
    @IBAction func didTapCustomUI(_ sender: Any) {
        
        /** Create barcode recognizer */
        self.barcodeRecognizer = MBBarcodeRecognizer()
        self.barcodeRecognizer?.scanQR = true
        
        self.pdf417Recognizer = MBPdf417Recognizer()
        
        /** Create barcode settings */
        let settings : MBSettings = MBSettings()
        
        /** Crate recognizer collection */
        let recognizerList : Array = [self.barcodeRecognizer!, self.pdf417Recognizer!] as! [MBRecognizer]
        let recognizerCollection : MBRecognizerCollection = MBRecognizerCollection(recognizers: recognizerList)
        
        /** Add recognizer collection to barcode settings */
        settings.uiSettings.recognizerCollection = recognizerCollection
        
        /** Create your overlay view controller */
        let customOverlayViewController : CustomOverlay = CustomOverlay.initFromStoryboardWith(settings: settings, delegate: self)
        
        /** Create recognizer view controller with wanted overlay view controller */
        let recognizerRunneViewController : UIViewController = MBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: customOverlayViewController)
        
        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        self.present(recognizerRunneViewController, animated: true, completion: nil)
    }
    @IBAction func didTapScan(_ sender: AnyObject) {
        
        /** Create barcode recognizer */
        self.barcodeRecognizer = MBBarcodeRecognizer()
        self.barcodeRecognizer?.scanQR = true
        
        self.pdf417Recognizer = MBPdf417Recognizer()
        
        /** Create barcode settings */
        let settings : MBBarcodeOverlaySettings = MBBarcodeOverlaySettings()
        
        /** Crate recognizer collection */
        let recognizerList : Array = [self.barcodeRecognizer!, self.pdf417Recognizer!] as! [MBRecognizer]
        let recognizerCollection : MBRecognizerCollection = MBRecognizerCollection(recognizers: recognizerList)
        
        /** Add recognizer collection to barcode settings */
        settings.uiSettings.recognizerCollection = recognizerCollection
        
        /** Create your overlay view controller */
        let barcodeOverlayViewController : MBBarcodeOverlayViewController = MBBarcodeOverlayViewController(settings: settings, andDelegate: self)
        
        /** Create recognizer view controller with wanted overlay view controller */
        let recognizerRunneViewController : UIViewController = MBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: barcodeOverlayViewController)
        
        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        self.present(recognizerRunneViewController, animated: true, completion: nil)
    }
    
    func overlayViewControllerDidFinishScanning(_ overlayViewController: MBOverlayViewController, state: MBRecognizerResultState) {
        
        let recognizerRunnerViewController = overlayViewController.recognizerRunnerViewController as MBRecognizerRunnerViewController
        /** This is done on background thread */
        recognizerRunnerViewController.pauseScanning()
        
        
        
        var message: String = ""
        var title: String = ""
        
        if (self.barcodeRecognizer!.result.resultState == MBRecognizerResultState.valid) {
            title = "QR code"
            
            // Save the string representation of the code
            message = self.barcodeRecognizer!.result.stringData()
        }
        else if (self.pdf417Recognizer!.result.resultState == MBRecognizerResultState.valid) {
            title = "PDF417"
            
            // Save the string representation of the code
            message = self.pdf417Recognizer!.result.stringData()
        }
        
        /** Needs to be called on main thread beacuse everything prior is on background thread */
        DispatchQueue.main.async {
            // present the alert view with scanned results
            
            let alertController: UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction: UIAlertAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default,
                                                             handler: { (action) -> Void in
                                                                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(okAction)
            overlayViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    func overlayViewControllerDidTapClose(_ overlayViewController: MBOverlayViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func customOverlayViewControllerDidFinishScanning(_ customOverlay: CustomOverlay, state: MBRecognizerResultState) {
        self.overlayViewControllerDidFinishScanning(customOverlay, state: state)
    }
    
    func customOverlayViewControllerDidTapClose(customOverlay: CustomOverlay) {
        self.overlayViewControllerDidTapClose(customOverlay)
    }
    
    func barcodeOverlayViewControllerDidFinishScanning(_ barcodeOverlayViewController: MBBarcodeOverlayViewController, state: MBRecognizerResultState) {
        self.overlayViewControllerDidFinishScanning(barcodeOverlayViewController, state: state)
    }
    
    func barcodeOverlayViewControllerDidTapClose(_ barcodeOverlayViewController: MBBarcodeOverlayViewController) {
        self.overlayViewControllerDidTapClose(barcodeOverlayViewController)
    }
    
}
