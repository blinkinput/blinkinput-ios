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
        
        // Create MBINFieldByFieldOverlaySettings
        let settings = MBINFieldByFieldOverlaySettings(scanElements: MBGenericPreset.getPreset()!)
        
        // Create field by field VC
        let fieldByFieldVC = MBINFieldByFieldOverlayViewController(settings: settings, delegate: self)
        
        // Create scanning VC
        let recognizerRunnerViewController: (UIViewController & MBINRecognizerRunnerViewController)? = MBINViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: fieldByFieldVC)
        
        // Present VC
        self.present(recognizerRunnerViewController!, animated: true, completion: nil)
    }
}

extension ViewController : MBINFieldByFieldOverlayViewControllerDelegate {
    
    func field(_ fieldByFieldOverlayViewController: MBINFieldByFieldOverlayViewController, didFinishScanningWith scanElements: [MBINScanElement]) {
        
        fieldByFieldOverlayViewController.recognizerRunnerViewController?.pauseScanning()
        
        var dict = [String: String]()
        for element: MBINScanElement in scanElements {
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
    
    func field(byFieldOverlayViewControllerWillClose fieldByFieldOverlayViewController: MBINFieldByFieldOverlayViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

