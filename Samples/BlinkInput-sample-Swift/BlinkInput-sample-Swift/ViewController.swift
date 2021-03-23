//
//  ViewController.swift
//  BlinkOCR-sample-Swift
//
//  Created by Dino on 15/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

import UIKit
import MobileCoreServices
import BlinkInput

class ViewController: UIViewController, MBINBarcodeOverlayViewControllerDelegate  {
    
    var rawParser: MBINRawParser?
    var parserGroupProcessor: MBINParserGroupProcessor?
    var blinkInputRecognizer: MBINBlinkInputRecognizer?

    @IBAction func didTapScan(_ sender: AnyObject) {
        
        let settings = MBINBarcodeOverlaySettings()
        rawParser = MBINRawParser()
        parserGroupProcessor = MBINParserGroupProcessor(parsers: [rawParser!])
        blinkInputRecognizer = MBINBlinkInputRecognizer(processors: [parserGroupProcessor!])
        
        /** Create recognizer collection */
        let recognizerCollection = MBINRecognizerCollection(recognizers: [blinkInputRecognizer!])
        let overlayVC = MBINBarcodeOverlayViewController(settings: settings, recognizerCollection: recognizerCollection, delegate: self)
        
        let recognizerRunnerViewController: (UIViewController & MBINRecognizerRunnerViewController)? = MBINViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: overlayVC)
        
        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        present(recognizerRunnerViewController!, animated: true, completion: nil)
    }
    
    // MARK: MBINBarcodeOverlayViewControllerDelegate delegate
    
    func barcodeOverlayViewControllerDidFinishScanning(_ barcodeOverlayViewController: MBINBarcodeOverlayViewController, state: MBINRecognizerResultState) {

        // check for valid state
        if state == MBINRecognizerResultState.valid {
            // first, pause scanning until we process all the results
            barcodeOverlayViewController.recognizerRunnerViewController?.pauseScanning()
            
            DispatchQueue.main.async(execute: {() -> Void in
                print("OCR results are:")
                print("Raw ocr: \(self.rawParser!.result.rawText)")
            })
            
            barcodeOverlayViewController.recognizerRunnerViewController?.resumeScanningAndResetState(true)
        }
    }
    
    func barcodeOverlayViewControllerDidTapClose(_ barcodeOverlayViewController: MBINBarcodeOverlayViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

