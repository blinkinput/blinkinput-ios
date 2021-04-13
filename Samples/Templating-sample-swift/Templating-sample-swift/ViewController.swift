//
//  ViewController.swift
//  Templating-sample-swift
//
//  Created by Jura Skrlec on 10/05/2018.
//  Copyright © 2018 Microblink. All rights reserved.
//

import UIKit
import BlinkInput

class ViewController: UIViewController {
    
    var croatianIDFrontTemplateRecognizer: MBICroatianIDFrontTemplateRecognizer?

    @IBAction func scanButtonTapped(_ sender: Any) {
        
        croatianIDFrontTemplateRecognizer = MBICroatianIDFrontTemplateRecognizer()
        let settings = MBIBarcodeOverlaySettings()
        var recognizers = [MBIRecognizer]()
        recognizers.append((croatianIDFrontTemplateRecognizer?.detectorRecognizer)!)
        /** Create recognizer collection */
        let recognizerCollection = MBIRecognizerCollection(recognizers: recognizers)
        let overlayVC = MBIBarcodeOverlayViewController(settings: settings, recognizerCollection: recognizerCollection, delegate: self)
        let recognizerRunnerViewController: (UIViewController & MBIRecognizerRunnerViewController)? = MBIViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: overlayVC)
        
        self.present(recognizerRunnerViewController!, animated: true, completion: nil)
    }
}

extension ViewController: MBIBarcodeOverlayViewControllerDelegate {
    
    func barcodeOverlayViewControllerDidFinishScanning(_ barcodeOverlayViewController: MBIBarcodeOverlayViewController, state: MBIRecognizerResultState) {
        
        if state == MBIRecognizerResultState.valid {
            barcodeOverlayViewController.recognizerRunnerViewController?.pauseScanning()
            
            DispatchQueue.main.async(execute: {() -> Void in
                let alert = UIAlertController(title: "Croatian ID Front", message: self.croatianIDFrontTemplateRecognizer?.resultDescription(), preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction?) -> Void in
                    barcodeOverlayViewController.dismiss(animated: true) {() -> Void in }
                })
                alert.addAction(defaultAction)
                barcodeOverlayViewController.present(alert, animated: true) {() -> Void in }
            })
        }
    }
    
    func barcodeOverlayViewControllerDidTapClose(_ barcodeOverlayViewController: MBIBarcodeOverlayViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

