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
    
    var rawOcrParser : MBINRawParser?
    var parserGroupProcessor : MBINParserGroupProcessor?
    var blinkInputRecognizer : MBINBlinkInputRecognizer?
    
    var customOverlayVC : CustomOverlay?

    @IBAction func didTapScan(_ sender: Any) {
        
        /** Create parsers and groups and recognizer */
        self.rawOcrParser = MBINRawParser()
        
        /** Use DeepOCR engine */
        let deepOcrEngine : MBINDeepOcrEngineOptions = MBINDeepOcrEngineOptions()
        deepOcrEngine.deepOcrModel = MBINDeepOcrModel.blinkInput;
        self.rawOcrParser?.ocrEngineOptions = deepOcrEngine
        
        self.parserGroupProcessor = MBINParserGroupProcessor(parsers: [self.rawOcrParser!])
        self.blinkInputRecognizer = MBINBlinkInputRecognizer(processors: [self.parserGroupProcessor!])
        
        /** Crate recognizer collection */
        let recognizerList : Array = [self.blinkInputRecognizer!]
        let recognizerCollection : MBINRecognizerCollection = MBINRecognizerCollection(recognizers: recognizerList)
        
        /** Create your overlay view controller */
        self.customOverlayVC = CustomOverlay.initFromStoryboardWith(self)
        self.customOverlayVC?.reconfigureRecognizers(recognizerCollection)
        
        /** Create recognizer view controller with wanted overlay view controller */
        let recognizerRunneViewController : UIViewController = MBINViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: self.customOverlayVC!)!
        
        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        self.present(recognizerRunneViewController, animated: true, completion: nil)
    }
    
}

extension ViewController: MBINCustomOverlayDelegate {
    
    func customOverlayViewControllerDidFinishScannig(_ customOverlay: CustomOverlay, state: MBINRecognizerResultState) {
        if (state == MBINRecognizerResultState.valid) {
            DispatchQueue.main.async {
                self.customOverlayVC?.resultTextView.text = self.rawOcrParser?.result.rawText;
            }
        }
    }
}

