//
//  ViewController.swift
//  BlinkOCR-sample-Swift
//
//  Created by Dino on 15/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

import UIKit
import BlinkInput

class ViewController: UIViewController, MBIBarcodeOverlayViewControllerDelegate  {
    
    var rawParser: MBIRawParser?
    var parserGroupProcessor: MBIParserGroupProcessor?
    var blinkInputRecognizer: MBIBlinkInputRecognizer?

    @IBAction func didTapScan(_ sender: AnyObject) {
        
        let settings = MBIBarcodeOverlaySettings()
        rawParser = MBIRawParser()
        parserGroupProcessor = MBIParserGroupProcessor(parsers: [rawParser!])
        blinkInputRecognizer = MBIBlinkInputRecognizer(processors: [parserGroupProcessor!])
        
        /** Create recognizer collection */
        let recognizerCollection = MBIRecognizerCollection(recognizers: [blinkInputRecognizer!])
        let overlayVC = MBIBarcodeOverlayViewController(settings: settings, recognizerCollection: recognizerCollection, delegate: self)
        
        let recognizerRunnerViewController: (UIViewController & MBIRecognizerRunnerViewController)? = MBIViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: overlayVC)
        
        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        present(recognizerRunnerViewController!, animated: true, completion: nil)
    }
    
    // MARK: MBIBarcodeOverlayViewControllerDelegate delegate
    
    func barcodeOverlayViewControllerDidFinishScanning(_ barcodeOverlayViewController: MBIBarcodeOverlayViewController, state: MBIRecognizerResultState) {

        // check for valid state
        if state == MBIRecognizerResultState.valid {
            // first, pause scanning until we process all the results
            barcodeOverlayViewController.recognizerRunnerViewController?.pauseScanning()
            
            DispatchQueue.main.async(execute: {() -> Void in
                print("OCR results are:")
                print("Raw ocr: \(self.rawParser!.result.rawText)")
            })
            
            barcodeOverlayViewController.recognizerRunnerViewController?.resumeScanningAndResetState(true)
        }
    }
    
    func barcodeOverlayViewControllerDidTapClose(_ barcodeOverlayViewController: MBIBarcodeOverlayViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

