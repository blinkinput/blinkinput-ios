//
//  PPBlinkInputRecognizers.h
//  BlinkOcrFramework
//
//  Created by Dino on 27/09/16.
//  Copyright © 2016 MicroBlink Ltd. All rights reserved.
//

#ifndef PPBlinkInputRecognizers_h
#define PPBlinkInputRecognizers_h

/** MRTD Detector*/
#import "MBMrtdDetector.h"
#import "MBMrtdDetectorResult.h"

#import "MBDocumentDetector.h"
#import "MBDocumentDetectorResult.h"

/** BlinkInput */
#import "MBBlinkInputRecognizer.h"
#import "MBBlinkInputRecognizerResult.h"

// Parsers
// Vin
#import "MBVinParser.h"
#import "MBVinParserResult.h"

// TopUp
#import "MBTopUpParser.h"
#import "MBTopUpParserResult.h"

// Email
#import "MBEmailParser.h"
#import "MBEmailParserResult.h"

// License plates
#import "MBLicensePlatesParser.h"
#import "MBLicensePlatesParserResult.h"

// Amount
#import "MBAmountParser.h"
#import "MBAmountParserResult.h"

// IBAN
#import "MBIbanParser.h"
#import "MBIbanParserResult.h"

// Date
#import "MBDateParser.h"
#import "MBDateParserResult.h"

// Raw
#import "MBRawParser.h"
#import "MBRawParserResult.h"

// Regex
#import "MBRegexParser.h"
#import "MBRegexParserResult.h"

// Dewarp policies
// Fixed policy
#import "MBFixedDewarpPolicy.h"

// DPI Based policy
#import "MBDPIBasedDewarpPolicy.h"

// No Up Scaling policy
#import "MBNoUpScalingDewarpPolicy.h"

// Engine options
#import "MBDeepOcrEngineOptions.h"
#import "MBOcrEngineOptions.h"

// Processor group
#import "MBProcessorGroup.h"

// Templating class
#import "MBTemplatingClass.h"

// Detector recognizer
#import "MBDetectorRecognizer.h"
#import "MBDetectorRecognizerResult.h"

// Processors
// Parser group
#import "MBParserGroupProcessor.h"
#import "MBParserGroupProcessorResult.h"

// Image return
#import "MBImageReturnProcessor.h"
#import "MBImageReturnProcessorResult.h"

// Native result
#import "MBNativeResult.h"
#import "MBDateResult.h"

// Use all recognizers from BlinkBarcode
#import "PPBlinkBarcodeRecognizers.h"

#endif /* PPBlinkInputRecognizers_h */
