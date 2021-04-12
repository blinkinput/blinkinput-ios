//
//  ViewController.swift
//  DeepOCR-sample-Swift
//
//  Created by Jura Skrlec on 09/04/2018.
//  Copyright © 2018 Jura Skrlec. All rights reserved.
//

import UIKit
import BlinkInput

class ViewController: UIViewController {
    
    var rawOcrParser : MBIRawParser?
    var parserGroupProcessor : MBIParserGroupProcessor?
    var blinkInputRecognizer : MBIBlinkInputRecognizer?
    
    var customOverlayVC : CustomOverlay?

    @IBAction func didTapScan(_ sender: Any) {
        
        /** Create parsers and groups and recognizer */
        self.rawOcrParser = MBIRawParser()
        
        /** Use DeepOCR engine */
        let deepOcrEngine : MBIDeepOcrEngineOptions = MBIDeepOcrEngineOptions()
        deepOcrEngine.deepOcrModel = MBIDeepOcrModel.blinkInput;
        self.rawOcrParser?.ocrEngineOptions = deepOcrEngine
        
        self.parserGroupProcessor = MBIParserGroupProcessor(parsers: [self.rawOcrParser!])
        self.blinkInputRecognizer = MBIBlinkInputRecognizer(processors: [self.parserGroupProcessor!])
        
        /** Crate recognizer collection */
        let recognizerList : Array = [self.blinkInputRecognizer!]
        let recognizerCollection : MBIRecognizerCollection = MBIRecognizerCollection(recognizers: recognizerList)
        
        /** Create your overlay view controller */
        self.customOverlayVC = CustomOverlay.initFromStoryboardWith(self)
        self.customOverlayVC?.reconfigureRecognizers(recognizerCollection)
        
        /** Create recognizer view controller with wanted overlay view controller */
        let recognizerRunneViewController : UIViewController = MBIViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: self.customOverlayVC!)!
        
        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        self.present(recognizerRunneViewController, animated: true, completion: nil)
    }
    
}

extension ViewController: MBICustomOverlayDelegate {
    
    func customOverlayViewControllerDidFinishScannig(_ customOverlay: CustomOverlay, state: MBIRecognizerResultState) {
        if (state == MBIRecognizerResultState.valid) {
            DispatchQueue.main.async {
                self.customOverlayVC?.resultTextView.text = self.rawOcrParser?.result.rawText;
            }
        }
    }
}

