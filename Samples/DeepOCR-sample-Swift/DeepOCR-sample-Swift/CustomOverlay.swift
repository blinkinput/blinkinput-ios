//
//  CustomOverlay.swift
//  pdf417-sample-Swift
//
//  Created by Dino Gustin on 06/03/2018.
//  Copyright © 2018 Dino. All rights reserved.
//

import BlinkInput

protocol MBICustomOverlayDelegate {
    func customOverlayViewControllerDidFinishScannig(_ customOverlay: CustomOverlay, state: MBIRecognizerResultState)
}

class CustomOverlay: MBICustomOverlayViewController {
    
    var delegate: MBICustomOverlayDelegate?
    
    @IBOutlet var viewFinder: UIView!
    @IBOutlet var resultTextView: UITextView!
    
    var dotsSubview: MBIDotsResultSubview?
    
    static func initFromStoryboardWith(_ delegate: MBICustomOverlayDelegate) -> CustomOverlay {
        let customOverlay: CustomOverlay = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomOverlay") as! CustomOverlay
        customOverlay.delegate = delegate
        return customOverlay
    }
    
    override func viewDidLoad() {
        self.scanningRecognizerRunnerViewControllerDelegate = self;

        self.metadataDelegates.detectionRecognizerRunnerViewControllerDelegate = self;
        
        self.dotsSubview = MBIDotsResultSubview(frame: self.viewFinder.bounds)
        self.dotsSubview?.shouldIgnoreFastResults = true
        self.viewFinder.addSubview(self.dotsSubview!)
    }


    @IBAction func didTapClose(_ sender: Any) {
        self.recognizerRunnerViewController?.overlayViewControllerWillCloseCamera(self);
        self.dismiss(animated: true, completion: nil);    }
    
}

extension CustomOverlay: MBIScanningRecognizerRunnerViewControllerDelegate {
    func recognizerRunnerViewControllerDidFinishScanning(_ recognizerRunnerViewController: UIViewController & MBIRecognizerRunnerViewController, state: MBIRecognizerResultState) {
        self.delegate?.customOverlayViewControllerDidFinishScannig(self, state: state)
    }
}

extension CustomOverlay: MBIDetectionRecognizerRunnerViewControllerDelegate {
    func recognizerRunnerViewController(_ recognizerRunnerViewController: UIViewController & MBIRecognizerRunnerViewController, didFinishDetectionWithDisplayablePoints displayablePoints: MBIDisplayablePointsDetection) {
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.dotsSubview?.detectionFinished(withDisplayablePoints: displayablePoints)
        })
    }
}
