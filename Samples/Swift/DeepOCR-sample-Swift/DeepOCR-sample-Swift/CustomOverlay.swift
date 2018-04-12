//
//  CustomOverlay.swift
//  pdf417-sample-Swift
//
//  Created by Dino Gustin on 06/03/2018.
//  Copyright © 2018 Dino. All rights reserved.
//

import MicroBlink

protocol MBCustomOverlayViewControllerDelegate {
    
    func customOverlayViewControllerDidTapClose(customOverlay: CustomOverlay)
    func customOverlayViewControllerDidFinishScanning(_ customOverlay: CustomOverlay, state: MBRecognizerResultState)
}

class CustomOverlay: MBOverlayViewController, MBOverlayViewControllerInterface {
    
    @IBOutlet var viewFinder: UIView!
    @IBOutlet var resultTextView: UITextView!
    
    var settings: MBSettings?
    var delegate: MBCustomOverlayViewControllerDelegate?
    var dotsSubview: MBDotsResultOverlaySubview?
    
    static func initFromStoryboardWith(settings: MBSettings, delegate: MBCustomOverlayViewControllerDelegate) -> CustomOverlay {
        let customOverlay: CustomOverlay = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomOverlay") as! CustomOverlay
        customOverlay.settings = settings
        customOverlay.delegate = delegate
        customOverlay.overlayViewControllerInterfaceDelegate = customOverlay
        return customOverlay
    }
    
    override func viewDidLoad() {
        self.recognizerRunnerViewController.scanningRecognizerRunnerViewDelegate = self
        self.recognizerRunnerViewController.metadataDelegates.detectionRecognizerRunnerViewDelegate = self
        self.scanningRegion = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0.8, height: 0.3))
        
        self.dotsSubview = MBDotsResultOverlaySubview(frame: self.viewFinder.bounds)
        self.dotsSubview?.shouldIgnoreFastResults = true
        self.viewFinder.addSubview(self.dotsSubview!)
    }
    
    public func getSettings() -> MBSettings {
        return self.settings!
    }

    @IBAction func didTapClose(_ sender: Any) {
        self.delegate!.customOverlayViewControllerDidTapClose(customOverlay: self)
    }
    
}

extension CustomOverlay: MBScanningRecognizerRunnerViewDelegate {
    func recognizerRunnerViewControllerDidFinishScanning(_ recognizerRunnerViewController: UIViewController & MBRecognizerRunnerViewController, state: MBRecognizerResultState) {
        self.delegate!.customOverlayViewControllerDidFinishScanning(self, state: state)
    }
}

extension CustomOverlay: MBDetectionRecognizerRunnerViewDelegate {
    
    func recognizerRunnerViewController(_ recognizerRunnerViewController: UIViewController & MBRecognizerRunnerViewController, didFinishDetectionWithDisplayableQuad displayableQuad: MBDisplayableQuadDetection) {
        // Nothing to see here. Move along
    }
    
    func recognizerRunnerViewController(_ recognizerRunnerViewController: UIViewController & MBRecognizerRunnerViewController, didFinishDetectionWithDisplayablePoints displayablePoints: MBDisplayablePointsDetection) {
        
        // Displayable points
        self.dotsSubview?.overlayDidFinishDetection(withDisplayablePoints: displayablePoints)
    }
}
