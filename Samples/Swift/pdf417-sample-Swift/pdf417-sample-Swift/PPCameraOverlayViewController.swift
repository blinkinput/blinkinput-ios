//
//  PPCameraOverlayViewController.swift
//  pdf417-sample-Swift
//
//  Created by Dino on 18/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

import MicroBlink

class PPCameraOverlayViewController : PPOverlayViewController {

    var torchOn: Bool = false;

    override func viewDidLoad() {
        self.scanningRegion = CGRect(origin: CGPoint(x: 0.15, y: 0.4), size: CGSize(width: 0.7, height: 0.2))
    }
    
    @IBAction func didTapClose(_ sender: AnyObject) {
        (self.containerViewController)?.overlayViewControllerWillCloseCamera(self)
    }

    @IBAction func didTapTorch(_ sender: AnyObject) {
        self.torchOn = ((self.containerViewController)?.isTorchOn())!
        self.torchOn = !self.torchOn
        if((self.containerViewController)?.overlayViewControllerShouldDisplayTorch(self))! {
            (self.containerViewController)?.overlayViewController(self, willSetTorch: self.torchOn)
        }
    }
}
