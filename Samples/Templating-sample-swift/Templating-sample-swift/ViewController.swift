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
    
    var croatianIDFrontTemplateRecognizer: MBINCroatianIDFrontTemplateRecognizer?

    @IBAction func scanButtonTapped(_ sender: Any) {
        
        croatianIDFrontTemplateRecognizer = MBINCroatianIDFrontTemplateRecognizer()
        let settings = MBINBarcodeOverlaySettings()
        var recognizers = [MBINRecognizer]()
        recognizers.append((croatianIDFrontTemplateRecognizer?.detectorRecognizer)!)
        /** Create recognizer collection */
        let recognizerCollection = MBINRecognizerCollection(recognizers: recognizers)
        let overlayVC = MBINBarcodeOverlayViewController(settings: settings, recognizerCollection: recognizerCollection, delegate: self)
        let recognizerRunnerViewController: (UIViewController & MBINRecognizerRunnerViewController)? = MBINViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: overlayVC)
        
        self.present(recognizerRunnerViewController!, animated: true, completion: nil)
    }
}

extension ViewController: MBINBarcodeOverlayViewControllerDelegate {
    
    func barcodeOverlayViewControllerDidFinishScanning(_ barcodeOverlayViewController: MBINBarcodeOverlayViewController, state: MBINRecognizerResultState) {
        
        if state == MBINRecognizerResultState.valid {
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
    
    func barcodeOverlayViewControllerDidTapClose(_ barcodeOverlayViewController: MBINBarcodeOverlayViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

