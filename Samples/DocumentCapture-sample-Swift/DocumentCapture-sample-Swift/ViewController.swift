//
//  ViewController.swift
//  DocumentCapture-sample-Swift
//
//  Created by Jura Skrlec on 04/02/2020.
//  Copyright © 2020 Jura Skrlec. All rights reserved.
//

import UIKit
import Microblink

class ViewController: UIViewController {
    
    var documentCaptureRecognizer: MBDocumentCaptureRecognizer?
    var highResolutionImage: MBImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Valid until: 2020-10-23
        MBMicroblinkSDK.sharedInstance().setLicenseKey("sRwAAAEgY29tLm1pY3JvYmxpbmsuYmxpbmtpbnB1dC5zYW1wbGXNuwRkLIVmR6BuBdHkHccH8zSdhfRxjqp6D6XsKp7QSpQgLZcOyb6QL/Ni0zkXhVvfR52Y0pbhInYUwSzDlCXQ0O41dDb02wykOH3uwtyAXlpeH4LsQxxUVrpWI35yn9ZAcyyYvW+DZBQacHCj64v2uuzWhtAStJ+9hvBzwYvbB70tICKwcZnclRNTp66c")
    }
    
    @IBAction func didTapScan(_ sender: AnyObject) {
        
        /** Create document capture recognizer */
        documentCaptureRecognizer = MBDocumentCaptureRecognizer()
        documentCaptureRecognizer?.returnFullDocumentImage = true
        
        /** Create settings */
        let settings : MBDocumentCaptureOverlaySettings = MBDocumentCaptureOverlaySettings()
        
        /** Create your overlay view controller */
        let documentCatpureOverlayViewController : MBDocumentCaptureOverlayViewController = MBDocumentCaptureOverlayViewController(settings: settings, recognizer: documentCaptureRecognizer!, delegate: self)
        
        /** Create recognizer view controller with wanted overlay view controller */
        let recognizerRunneViewController : UIViewController = MBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: documentCatpureOverlayViewController)
        recognizerRunneViewController.modalPresentationStyle = .fullScreen
        
        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        self.present(recognizerRunneViewController, animated: true, completion: nil)
    }
}

extension ViewController: MBDocumentCaptureOverlayViewControllerDelegate {
    
    func documentCaptureOverlayViewControllerDidFinishScanning(_ documentCaptureOverlayViewController: MBDocumentCaptureOverlayViewController, state: MBRecognizerResultState) {
        
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
    
    func documentCaptureOverlayViewControllerDidTapClose(_ documentCaptureOverlayViewController: MBDocumentCaptureOverlayViewController) {
        documentCaptureOverlayViewController.dismiss(animated: true, completion: nil)
    }
    
    func documentCaptureOverlayViewControllerDidCaptureHighResolutionImage(_ documentCaptureOverlayViewController: MBDocumentCaptureOverlayViewController, highResImage: MBImage, state: MBRecognizerResultState) {
        
        highResolutionImage = highResImage
    }
    
}
