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
    
    var documentCaptureRecognizer: MBIDocumentCaptureRecognizer?
    var highResolutionImage: MBIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Valid until:2022-02-06
        MBIMicroblinkSDK.shared().setLicenseResource("license", withExtension: "txt", inSubdirectory: "", for: .main) { (_) in
        }
    }
    
    @IBAction func didTapScan(_ sender: AnyObject) {
        
        /** Create document capture recognizer */
        documentCaptureRecognizer = MBIDocumentCaptureRecognizer()
        documentCaptureRecognizer?.returnFullDocumentImage = true
        
        /** Create settings */
        let settings : MBIDocumentCaptureOverlaySettings = MBIDocumentCaptureOverlaySettings()
        
        /** Create your overlay view controller */
        let documentCatpureOverlayViewController : MBIDocumentCaptureOverlayViewController = MBIDocumentCaptureOverlayViewController(settings: settings, recognizer: documentCaptureRecognizer!, delegate: self)
        
        /** Create recognizer view controller with wanted overlay view controller */
        let recognizerRunneViewController : UIViewController = MBIViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: documentCatpureOverlayViewController)!
        recognizerRunneViewController.modalPresentationStyle = .fullScreen
        
        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        self.present(recognizerRunneViewController, animated: true, completion: nil)
    }
}

extension ViewController: MBIDocumentCaptureOverlayViewControllerDelegate {
    
    func documentCaptureOverlayViewControllerDidFinishScanning(_ documentCaptureOverlayViewController: MBIDocumentCaptureOverlayViewController, state: MBIRecognizerResultState) {
        
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
    
    func documentCaptureOverlayViewControllerDidTapClose(_ documentCaptureOverlayViewController: MBIDocumentCaptureOverlayViewController) {
        documentCaptureOverlayViewController.dismiss(animated: true, completion: nil)
    }
    
    func documentCaptureOverlayViewControllerDidCaptureHighResolutionImage(_ documentCaptureOverlayViewController: MBIDocumentCaptureOverlayViewController, highResImage: MBIImage, state: MBIRecognizerResultState) {
        
        highResolutionImage = highResImage
    }
    
}
