//
//  PPCameraOverlayViewController.swift
//  pdf417-sample-Swift
//
//  Created by Dino on 18/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

import MicroBlink

class PPCameraOverlayViewController : PPOverlayViewController {

    var tourchOn : Bool = false;

    override func viewDidLoad() {
        self.scanningRegion=CGRectMake(0.15, 0.4, 0.7, 0.2)
    }

    @IBAction func didTapClose(sender: AnyObject) {
        (self.containerViewController as! PPOverlayContainerViewController).overlayViewControllerWillCloseCamera(self)
    }

    @IBAction func didTapTourch(sender: AnyObject) {
        self.tourchOn=(self.containerViewController as! PPOverlayContainerViewController).isTorchOn()
        self.tourchOn = !self.tourchOn
        if((self.containerViewController as! PPOverlayContainerViewController).overlayViewControllerShouldDisplayTorch(self)) {
            (self.containerViewController as! PPOverlayContainerViewController).overlayViewController(self, willSetTorch: self.tourchOn)
        }
    }
}