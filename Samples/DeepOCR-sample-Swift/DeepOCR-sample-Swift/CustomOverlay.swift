//
//  CustomOverlay.swift
//  pdf417-sample-Swift
//
//  Created by Dino Gustin on 06/03/2018.
//  Copyright © 2018 Dino. All rights reserved.
//

import BlinkInput

protocol MBINCustomOverlayDelegate {
    func customOverlayViewControllerDidFinishScannig(_ customOverlay: CustomOverlay, state: MBINRecognizerResultState)
}

class CustomOverlay: MBINCustomOverlayViewController {
    
    var delegate: MBINCustomOverlayDelegate?
    
    @IBOutlet var viewFinder: UIView!
    @IBOutlet var resultTextView: UITextView!
    
    var dotsSubview: MBINDotsResultSubview?
    
    static func initFromStoryboardWith(_ delegate: MBINCustomOverlayDelegate) -> CustomOverlay {
        let customOverlay: CustomOverlay = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomOverlay") as! CustomOverlay
        customOverlay.delegate = delegate
        return customOverlay
    }
    
    override func viewDidLoad() {
        self.scanningRecognizerRunnerViewControllerDelegate = self;

        self.metadataDelegates.detectionRecognizerRunnerViewControllerDelegate = self;
        
        self.dotsSubview = MBINDotsResultSubview(frame: self.viewFinder.bounds)
        self.dotsSubview?.shouldIgnoreFastResults = true
        self.viewFinder.addSubview(self.dotsSubview!)
    }


    @IBAction func didTapClose(_ sender: Any) {
        self.recognizerRunnerViewController?.overlayViewControllerWillCloseCamera(self);
        self.dismiss(animated: true, completion: nil);    }
    
}

extension CustomOverlay: MBINScanningRecognizerRunnerViewControllerDelegate {
    func recognizerRunnerViewControllerDidFinishScanning(_ recognizerRunnerViewController: UIViewController & MBINRecognizerRunnerViewController, state: MBINRecognizerResultState) {
        self.delegate?.customOverlayViewControllerDidFinishScannig(self, state: state)
    }
}

extension CustomOverlay: MBINDetectionRecognizerRunnerViewControllerDelegate {
    func recognizerRunnerViewController(_ recognizerRunnerViewController: UIViewController & MBINRecognizerRunnerViewController, didFinishDetectionWithDisplayablePoints displayablePoints: MBINDisplayablePointsDetection) {
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.dotsSubview?.detectionFinished(withDisplayablePoints: displayablePoints)
        })
    }
}
