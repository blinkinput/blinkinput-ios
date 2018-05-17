//
//  CustomOverlay.swift
//  pdf417-sample-Swift
//
//  Created by Dino Gustin on 06/03/2018.
//  Copyright © 2018 Dino. All rights reserved.
//

import MicroBlink

protocol MBCustomOverlayDelegate {
    func customOverlayViewControllerDidFinishScannig(_ customOverlay: CustomOverlay, state: MBRecognizerResultState)
}

class CustomOverlay: MBCustomOverlayViewController {
    
    var delegate: MBCustomOverlayDelegate?
    
    @IBOutlet var viewFinder: UIView!
    @IBOutlet var resultTextView: UITextView!
    
    var dotsSubview: MBDotsResultSubview?
    
    static func initFromStoryboardWith(_ delegate: MBCustomOverlayDelegate) -> CustomOverlay {
        let customOverlay: CustomOverlay = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomOverlay") as! CustomOverlay
        customOverlay.delegate = delegate
        return customOverlay
    }
    
    override func viewDidLoad() {
        self.scanningRecognizerRunnerViewControllerDelegate = self;

        self.metadataDelegates.detectionRecognizerRunnerViewControllerDelegate = self;
        
        self.dotsSubview = MBDotsResultSubview(frame: self.viewFinder.bounds)
        self.dotsSubview?.shouldIgnoreFastResults = true
        self.viewFinder.addSubview(self.dotsSubview!)
    }


    @IBAction func didTapClose(_ sender: Any) {
        self.recognizerRunnerViewController?.overlayViewControllerWillCloseCamera(self);
        self.dismiss(animated: true, completion: nil);    }
    
}

extension CustomOverlay: MBScanningRecognizerRunnerViewControllerDelegate {
    func recognizerRunnerViewController(_ recognizerRunnerViewController: UIViewController & MBRecognizerRunnerViewController, didFinishScanningWith state: MBRecognizerResultState) {
        self.delegate?.customOverlayViewControllerDidFinishScannig(self, state: state)
    }
}

extension CustomOverlay: MBDetectionRecognizerRunnerViewControllerDelegate {
    func recognizerRunnerViewController(_ recognizerRunnerViewController: UIViewController & MBRecognizerRunnerViewController, didFinishDetectionWithDisplayablePoints displayablePoints: MBDisplayablePointsDetection) {
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.dotsSubview?.detectionFinished(withDisplayablePoints: displayablePoints)
        })
    }
}
