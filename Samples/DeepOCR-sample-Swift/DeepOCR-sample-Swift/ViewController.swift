//
//  ViewController.swift
//  DeepOCR-sample-Swift
//
//  Created by Jura Skrlec on 09/04/2018.
//  Copyright © 2018 Jura Skrlec. All rights reserved.
//

import UIKit
import MicroBlink

class ViewController: UIViewController {
    
    var rawOcrParser : MBRawParser?
    var parserGroupProcessor : MBParserGroupProcessor?
    var blinkInputRecognizer : MBBlinkInputRecognizer?
    
    var customOverlayVC : CustomOverlay?

    @IBAction func didTapScan(_ sender: Any) {
        
        /** Create parsers and groups and recognizer */
        self.rawOcrParser = MBRawParser()
        
        /** Use DeepOCR engine */
        let deepOcrEngine : MBDeepOcrEngineOptions = MBDeepOcrEngineOptions()
        deepOcrEngine.deepOcrModel = MBDeepOcrModel.blinkInput;
        self.rawOcrParser?.ocrEngineOptions = deepOcrEngine
        
        self.parserGroupProcessor = MBParserGroupProcessor(parsers: [self.rawOcrParser!])
        self.blinkInputRecognizer = MBBlinkInputRecognizer(processors: [self.parserGroupProcessor!])
        
        /** Crate recognizer collection */
        let recognizerList : Array = [self.blinkInputRecognizer!]
        let recognizerCollection : MBRecognizerCollection = MBRecognizerCollection(recognizers: recognizerList)
        
        /** Create your overlay view controller */
        self.customOverlayVC = CustomOverlay.initFromStoryboardWith(self)
        self.customOverlayVC?.reconfigureRecognizers(recognizerCollection)
        
        /** Create recognizer view controller with wanted overlay view controller */
        let recognizerRunneViewController : UIViewController = MBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: self.customOverlayVC!)
        
        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        self.present(recognizerRunneViewController, animated: true, completion: nil)
    }
    
}

extension ViewController: MBCustomOverlayDelegate {
    
    func customOverlayViewControllerDidFinishScannig(_ customOverlay: CustomOverlay, state: MBRecognizerResultState) {
        if (state == MBRecognizerResultState.valid) {
            DispatchQueue.main.async {
                self.customOverlayVC?.resultTextView.text = self.rawOcrParser?.result.rawText;
            }
        }
    }
}

