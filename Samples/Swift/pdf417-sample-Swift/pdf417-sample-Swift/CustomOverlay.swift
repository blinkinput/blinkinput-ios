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

class CustomOverlay: MBOverlayViewController, MBOverlayViewControllerInterface, MBScanningRecognizerRunnerViewDelegate {
    
    var settings: MBSettings?
    var delegate: MBCustomOverlayViewControllerDelegate?    
    
    static func initFromStoryboardWith(settings: MBSettings, delegate: MBCustomOverlayViewControllerDelegate) -> CustomOverlay {
        let customOverlay: CustomOverlay = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomOverlay") as! CustomOverlay
        customOverlay.settings = settings
        customOverlay.delegate = delegate
        customOverlay.overlayViewControllerInterfaceDelegate = customOverlay
        return customOverlay
    }
    
    override func viewDidLoad() {
        self.recognizerRunnerViewController.scanningRecognizerRunnerViewDelegate = self
        self.scanningRegion = CGRect(origin: CGPoint(x: 0.1, y: 0.3), size: CGSize(width: 0.8, height: 0.25))
    }
    
    func recognizerRunnerViewControllerDidFinishScanning(_ recognizerRunnerViewController: UIViewController & MBRecognizerRunnerViewController, state: MBRecognizerResultState) {
        self.delegate!.customOverlayViewControllerDidFinishScanning(self, state: state)
    }
    
    public func getSettings() -> MBSettings {
        return self.settings!
    }

    @IBAction func didTapClose(_ sender: Any) {
        self.delegate!.customOverlayViewControllerDidTapClose(customOverlay: self)
    }
    
}
