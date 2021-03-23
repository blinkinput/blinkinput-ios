//
//  ViewController.swift
//  DocumentCapture-sample-Swift
//
//  Created by Jura Skrlec on 04/02/2020.
//  Copyright © 2020 Jura Skrlec. All rights reserved.
//

import UIKit
import BlinkInput

class ViewController: UIViewController {
    
    var documentCaptureRecognizer: MBINDocumentCaptureRecognizer?
    var highResolutionImage: MBINImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Valid until: 2021-08-23
        MBINMicroblinkSDK.shared().setLicenseKey("sRwAAAEgY29tLm1pY3JvYmxpbmsuYmxpbmtpbnB1dC5zYW1wbGXNuwRk7IVmR6BuBdHkZcEDM7VDwRalPqDrnFfevvHOKokY2yLcwi8x/DWj0pylEr87X1WxtZFlWP+0ieo0LgGEPKMtij0IIe45Jf2AybGfbPMc8ryXOFHLvJI55I3c+d/aWMK1C5f/jkn5zj1tO2MnCJGiU//Kp+g76/e0zGM/KjQfEeQtBCC0fcpT8d8X") { (error) in
            print("License error: \(error)")
        }
    }
    
    @IBAction func didTapScan(_ sender: AnyObject) {
        
        /** Create document capture recognizer */
        documentCaptureRecognizer = MBINDocumentCaptureRecognizer()
        documentCaptureRecognizer?.returnFullDocumentImage = true
        
        /** Create settings */
        let settings : MBINDocumentCaptureOverlaySettings = MBINDocumentCaptureOverlaySettings()
        
        /** Create your overlay view controller */
        let documentCatpureOverlayViewController : MBINDocumentCaptureOverlayViewController = MBINDocumentCaptureOverlayViewController(settings: settings, recognizer: documentCaptureRecognizer!, delegate: self)
        
        /** Create recognizer view controller with wanted overlay view controller */
        let recognizerRunneViewController : UIViewController = MBINViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: documentCatpureOverlayViewController)!
        recognizerRunneViewController.modalPresentationStyle = .fullScreen
        
        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        self.present(recognizerRunneViewController, animated: true, completion: nil)
    }
}

extension ViewController: MBINDocumentCaptureOverlayViewControllerDelegate {
    
    func documentCaptureOverlayViewControllerDidFinishScanning(_ documentCaptureOverlayViewController: MBINDocumentCaptureOverlayViewController, state: MBINRecognizerResultState) {
        
        if (state == .valid) {
            
            // This needs to be done on this, background thread
            documentCaptureOverlayViewController.recognizerRunnerViewController?.pauseScanning()
            
            DispatchQueue.main.async {
                documentCaptureOverlayViewController.dismiss(animated: true, completion: nil)
                
                let scannedDocument = ScannedDocument(scannedDocumentImage: self.documentCaptureRecognizer?.result.fullDocumentImage?.image, highResolutionDocumentImage: self.highResolutionImage?.image)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "DocumentCaptureTableViewController") as! DocumentCaptureTableViewController
                controller.scannedDocument = scannedDocument
                
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    func documentCaptureOverlayViewControllerDidTapClose(_ documentCaptureOverlayViewController: MBINDocumentCaptureOverlayViewController) {
        documentCaptureOverlayViewController.dismiss(animated: true, completion: nil)
    }
    
    func documentCaptureOverlayViewControllerDidCaptureHighResolutionImage(_ documentCaptureOverlayViewController: MBINDocumentCaptureOverlayViewController, highResImage: MBINImage, state: MBINRecognizerResultState) {
        
        highResolutionImage = highResImage
    }
    
}
