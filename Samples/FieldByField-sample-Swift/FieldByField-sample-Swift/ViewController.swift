//
//  ViewController.swift
//  FieldByField-sample-Swift
//
//  Created by Jura Skrlec on 10/05/2018.
//  Copyright © 2018 Jura Skrlec. All rights reserved.
//

import UIKit
import BlinkInput

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startScanTapped(_ sender: Any) {
        
        // Create MBIFieldByFieldOverlaySettings
        let settings = MBIFieldByFieldOverlaySettings(scanElements: MBGenericPreset.getPreset()!)
        
        // Create field by field VC
        let fieldByFieldVC = MBIFieldByFieldOverlayViewController(settings: settings, delegate: self)
        
        // Create scanning VC
        let recognizerRunnerViewController: (UIViewController & MBIRecognizerRunnerViewController)? = MBIViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: fieldByFieldVC)
        
        // Present VC
        self.present(recognizerRunnerViewController!, animated: true, completion: nil)
    }
}

extension ViewController : MBIFieldByFieldOverlayViewControllerDelegate {
    
    func field(_ fieldByFieldOverlayViewController: MBIFieldByFieldOverlayViewController, didFinishScanningWith scanElements: [MBIScanElement]) {
        
        fieldByFieldOverlayViewController.recognizerRunnerViewController?.pauseScanning()
        
        var dict = [String: String]()
        for element: MBIScanElement in scanElements {
            if (element.scanned) {
                dict[element.identifier] = element.value
            }
        }
        
        var description : String = ""
        for (key, value) in dict {
            description += "\(key): \(value)\n"
        }
        
        let alert = UIAlertController(title: "Field by field Result", message: "\(description)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        
        fieldByFieldOverlayViewController.present(alert, animated: true, completion: nil)
    }
    
    func field(byFieldOverlayViewControllerWillClose fieldByFieldOverlayViewController: MBIFieldByFieldOverlayViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

