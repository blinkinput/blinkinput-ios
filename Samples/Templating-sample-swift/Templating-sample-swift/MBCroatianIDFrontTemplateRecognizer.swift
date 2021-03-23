//
//  MBINCroatianIDFrontTemplateRecognizer.swift
//  Templating-sample-swift
//
//  Created by Jura Skrlec on 10/05/2018.
//  Copyright © 2018 Microblink. All rights reserved.
//

import Foundation
import BlinkInput

class MBCroIDNewTemplatingClassifier: NSObject, MBINTemplatingClassifier {
    private(set) weak var documentNumberNewRegexParser: MBINRegexParser?
    
    init(_ parser: MBINRegexParser?) {
        super.init()
        
        documentNumberNewRegexParser = parser
        
    }
    
    func classify() -> Bool {
        if ((documentNumberNewRegexParser?.result.parsedString.count)! > 0) {
            return true
        }
        else {
            return false
        }
    }
}

class MBINCroIDOldTemplatingClassifier: NSObject, MBINTemplatingClassifier {
    private(set) weak var documentNumberOldRegexParser: MBINRegexParser?
    
    init(_ parser: MBINRegexParser?) {
        super.init()
        
        documentNumberOldRegexParser = parser
        
    }
    
    func classify() -> Bool {
        if ((documentNumberOldRegexParser?.result.parsedString.count)! > 0) {
            return true
        }
        else {
            return false
        }
    }
}

class MBINCroatianIDFrontTemplateRecognizer : NSObject {
    
    var firstNameParser: MBINRegexParser?
    var lastNameParser: MBINRegexParser?
    var sexParser: MBINRegexParser?
    var citizenshipParser: MBINRegexParser?
    var oldDocumentNumberParser: MBINRegexParser?
    var neDocumentNumberParser: MBINRegexParser?
    var dateOfBirthParser: MBINDateParser?
    
    var firstNameParseGroupProcessor: MBINParserGroupProcessor?
    var lastNameParseGroupProcessor: MBINParserGroupProcessor?
    var sexCitizenshipDOBGroup: MBINParserGroupProcessor?
    var oldDocumentNumberGroup: MBINParserGroupProcessor?
    var neDocumentNumberGroup: MBINParserGroupProcessor?
    var fullDocumentImage: MBINImageReturnProcessor?
    var faceImage: MBINImageReturnProcessor?
    
    var firstNameOldID: MBINProcessorGroup?
    var firstNameNewID: MBINProcessorGroup?
    var lastNameOldID: MBINProcessorGroup?
    var lastNameNewID: MBINProcessorGroup?
    var sexCitizenshipDOBOldID: MBINProcessorGroup?
    var sexCitizenshipDOBNewID: MBINProcessorGroup?
    var documentNumberOldID: MBINProcessorGroup?
    var documentNumberNewID: MBINProcessorGroup?
    var faceOldID: MBINProcessorGroup?
    var faceNewID: MBINProcessorGroup?
    var fullDocument: MBINProcessorGroup?
    
    var oldID: MBINTemplatingClass?
    var neID: MBINTemplatingClass?
    var documentDetector: MBINDocumentDetector?
    var detectorRecognizer: MBINDetectorRecognizer?
    
    override init() {
        super.init()
        
        configureParsers()
        configureProcessors()
        configureProcessorGroup()
        configureClasses()
        configureDetectorRecognizer()
        
    }
    
    func configureParsers() {
        firstNameParser = MBINRegexParser(regex: "([A-ZŠĐŽČĆ]+ ?)+")
        let ocrEngineOptions = MBINOcrEngineOptions()
        ocrEngineOptions.charWhitelist = MBCroatianIDTemplateUtils.croatianCharsWhitelist()
        firstNameParser?.ocrEngineOptions = ocrEngineOptions
        lastNameParser = firstNameParser?.copy() as? MBINRegexParser
        sexParser = MBINRegexParser(regex: "[MŽ]/[MF]")
        do {
            let sexOptions = MBINOcrEngineOptions()
            var charWhitelist = Set<MBINOcrCharKey>()
            charWhitelist.insert(MBINOcrCharKey(code:  Int32(UnicodeScalar("M").value), font: MBINOcrFont.MB_OCR_FONT_ANY))
            charWhitelist.insert(MBINOcrCharKey(code:  Int32(UnicodeScalar("F").value), font: MBINOcrFont.MB_OCR_FONT_ANY))
            charWhitelist.insert(MBINOcrCharKey(code:  Int32(UnicodeScalar("/").value), font: MBINOcrFont.MB_OCR_FONT_ANY))
            charWhitelist.insert(MBINOcrCharKey(code:  Int32(UnicodeScalar("Ž").value), font: MBINOcrFont.MB_OCR_FONT_ANY))
            
            sexOptions.charWhitelist = charWhitelist
            sexParser?.ocrEngineOptions = sexOptions
        }
        
        sexParser?.endWithWhitespace = true
        sexParser?.startWithWhitespace = true
        
        citizenshipParser = MBINRegexParser(regex: "[A-Z]{3}")
        do {
            let citizenshipOptions = MBINOcrEngineOptions()
            var charWhitelist = Set<MBINOcrCharKey>()
            charWhitelist.insert(MBINOcrCharKey(code: Int32(UnicodeScalar("H").value), font: MBINOcrFont.MB_OCR_FONT_ANY))
            charWhitelist.insert(MBINOcrCharKey(code: Int32(UnicodeScalar("R").value), font: MBINOcrFont.MB_OCR_FONT_ANY))
            charWhitelist.insert(MBINOcrCharKey(code: Int32(UnicodeScalar("V").value), font: MBINOcrFont.MB_OCR_FONT_ANY))
            citizenshipOptions.charWhitelist = charWhitelist
            
            citizenshipParser?.ocrEngineOptions = citizenshipOptions
        }
        
        citizenshipParser?.endWithWhitespace = true
        citizenshipParser?.startWithWhitespace = true
        oldDocumentNumberParser = MBINRegexParser(regex: "\\d{9}")
        neDocumentNumberParser = oldDocumentNumberParser?.copy() as? MBINRegexParser
        
        dateOfBirthParser = MBINDateParser()
    }
    
    /**
     * This function will configure processors that will be used on different processing locations.
     */
    func configureProcessors() {
        // put first name parser in its own parser group
        firstNameParseGroupProcessor = MBINParserGroupProcessor(parsers: [firstNameParser!])
        // also do the same for last name parser
        lastNameParseGroupProcessor = MBINParserGroupProcessor(parsers: [lastNameParser!])
        // sex, citizenship and date of birth can be in same group
        sexCitizenshipDOBGroup = MBINParserGroupProcessor(parsers: [sexParser!, citizenshipParser!, dateOfBirthParser!])
        // document number group for old and new IDs
        oldDocumentNumberGroup = MBINParserGroupProcessor(parsers: [oldDocumentNumberParser!])
        neDocumentNumberGroup = MBINParserGroupProcessor(parsers: [neDocumentNumberParser!])
        
        fullDocumentImage = MBINImageReturnProcessor()
        faceImage = MBINImageReturnProcessor()
    }
    
    func configureProcessorGroup() {
        
        //------------------------------------------------------------------------------------------
        // First and Last name
        //------------------------------------------------------------------------------------------
        //
        // The Croatian ID card has width of 85mm and height of 54mm. If we take a ruler and measure
        // the locations of address field, we get the following measurements:
        //
        // on old croatian ID card, last name is located in following rectangle:
        //
        // left = 23 mm
        // right = 50 mm
        // top = 11 mm
        // bottom = 17 mm
        //
        // ProcessorGroup requires converting this into relative coordinates, so we
        // get the following:
        //
        // x = 23mm / 85mm = 0.271
        // y = 11mm / 54mm = 0.204
        // width = (50mm - 23mm) / 85mm = 0.318
        // height = (17mm - 11mm) / 54mm = 0.111
        //
        // on new croatian ID card, last name is located in following rectangle:
        //
        // left = 23 mm
        // right = 54 mm
        // top = 11 mm
        // bottom = 20 mm
        //
        // ProcessorGroup requires converting this into relative coordinates, so we
        // get the following:
        //
        // x = 23mm / 85mm = 0.271
        // y = 11mm / 54mm = 0.204
        // w = (54mm - 23mm) / 85mm = 0.365
        // h = (20mm - 11mm) / 54mm = 0.167
        //
        // In the same manner we can measure the locations of first name on both old and new ID cards.
        //
        // Both first and last name can hold a single line of text, but both on new and old ID card
        // first name is printed with smaller font than last name. Therefore, we will require that
        // dewarped image for last names will be of height 100 pixels and for first names of height 150
        // pixels.
        // The width of the image will be automatically determined to keep the original aspect ratio.
        //------------------------------------------------------------------------------------------
        
        firstNameOldID = MBINProcessorGroup(processingLocation: CGRect(x: 0.282, y: 0.333, width: 0.306, height: 0.167), dewarpPolicy: MBINFixedDewarpPolicy(dewarpHeight: 150), andProcessors: [firstNameParseGroupProcessor!])
        firstNameNewID = MBINProcessorGroup(processingLocation: CGRect(x: 0.282, y: 0.389, width: 0.353, height: 0.167), dewarpPolicy: MBINFixedDewarpPolicy(dewarpHeight: 150), andProcessors: [firstNameParseGroupProcessor!])
        lastNameOldID = MBINProcessorGroup(processingLocation: CGRect(x: 0.271, y: 0.204, width: 0.318, height: 0.111), dewarpPolicy: MBINFixedDewarpPolicy(dewarpHeight: 100), andProcessors: [lastNameParseGroupProcessor!])
        lastNameNewID = MBINProcessorGroup(processingLocation: CGRect(x: 0.282, y: 0.204, width: 0.353, height: 0.167), dewarpPolicy: MBINFixedDewarpPolicy(dewarpHeight: 100), andProcessors: [lastNameParseGroupProcessor!])
        
        //------------------------------------------------------------------------------------------
        // Sex, citizenship and date of birth
        //------------------------------------------------------------------------------------------
        // Sex, citizenship and date of birth parsers are bundled together into single parser group
        // processor. Now let's define a processor group for new and old ID version for that
        // processor.
        //
        // Firstly, we need to take a ruler and measure the location from which all these fields
        // will be extracted.
        // On old croatian ID cards, the location containing both sex, citizenship and date of birth
        // is in following rectangle:
        //
        // left = 35 mm
        // right = 57 mm
        // top = 27 mm
        // bottom = 43 mm
        //
        // ProcessorGroup requires converting this into relative coordinates, so we
        // get the following:
        //
        // x = 35mm / 85mm = 0.412
        // y = 27 mm / 54mm = 0.500
        // w = (57mm - 35mm) / 85mm = 0.259
        // h = (43mm - 27mm) / 54mm = 0.296
        //
        // Similarly, on new croatian ID card, rectangle holding same information is the following:
        //
        // left = 33 mm
        // right = 57 mm
        // top = 27 mm
        // bottom = 43 mm
        //
        // ProcessorGroup requires converting this into relative coordinates, so we
        // get the following:
        //
        // x = 33mm / 85mm = 0.388
        // y = 27mm / 54mm = 0.556
        // w = (57mm - 33mm) / 85mm = 0.282
        // h = (43mm - 27mm) / 54mm = 0.296
        //
        // This location contains three fields in three lines of text. So we will set the height of
        // dewarped image to 300 pixels.
        // The width of the image will be automatically determined to keep the original aspect ratio.
        //------------------------------------------------------------------------------------------
        sexCitizenshipDOBOldID = MBINProcessorGroup(processingLocation: CGRect(x: 0.412, y: 0.500, width: 0.259, height: 0.296), dewarpPolicy: MBINFixedDewarpPolicy(dewarpHeight: 300), andProcessors: [sexCitizenshipDOBGroup!])
        sexCitizenshipDOBNewID = MBINProcessorGroup(processingLocation: CGRect(x: 0.388, y: 0.500, width: 0.282, height: 0.296), dewarpPolicy: MBINFixedDewarpPolicy(dewarpHeight: 300), andProcessors: [sexCitizenshipDOBGroup!])
        
        //------------------------------------------------------------------------------------------
        // Document number
        //------------------------------------------------------------------------------------------
        // In same way as above, we create ProcessorGroup for old and new versions of document number
        // parsers.
        //------------------------------------------------------------------------------------------
        documentNumberOldID = MBINProcessorGroup(processingLocation: CGRect(x: 0.047, y: 0.519, width: 0.224, height: 0.111), dewarpPolicy: MBINFixedDewarpPolicy(dewarpHeight: 150), andProcessors: [oldDocumentNumberGroup!])
        documentNumberNewID = MBINProcessorGroup(processingLocation: CGRect(x: 0.047, y: 0.685, width: 0.224, height: 0.111), dewarpPolicy: MBINFixedDewarpPolicy(dewarpHeight: 150), andProcessors: [neDocumentNumberGroup!])
        
        //------------------------------------------------------------------------------------------
        // Face image
        //------------------------------------------------------------------------------------------
        // In same way as above, we create ProcessorGroup for image of the face on document.
        //------------------------------------------------------------------------------------------
        faceOldID = MBINProcessorGroup(processingLocation: CGRect(x: 0.650, y: 0.277, width: 0.270, height: 0.630), dewarpPolicy: MBINDPIBasedDewarpPolicy(desiredDPI: 200), andProcessors: [faceImage!])
        faceNewID = MBINProcessorGroup(processingLocation: CGRect(x: 0.659, y: 0.407, width: 0.294, height: 0.574), dewarpPolicy: MBINDPIBasedDewarpPolicy(desiredDPI: 200), andProcessors: [faceImage!])
        
        //------------------------------------------------------------------------------------------
        // Full document image
        //------------------------------------------------------------------------------------------
        // location of full document is same regardless of document version
        //------------------------------------------------------------------------------------------
        fullDocument = MBINProcessorGroup(processingLocation: CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0), dewarpPolicy: MBINDPIBasedDewarpPolicy(desiredDPI: 200), andProcessors: [fullDocumentImage!])
    }
    
    /**
     * This function will configure classes for old and new version of the document and classifiers
     * for each class.
     */
    func configureClasses() {
        // configure old version class
        do {
            oldID = MBINTemplatingClass()
            oldID?.setClassificationProcessorGroups([documentNumberOldID!])
            oldID?.setNonClassificationProcessorGroups([firstNameOldID!, lastNameOldID!, sexCitizenshipDOBOldID!, faceOldID!, fullDocument!])
            oldID?.setTemplatingClassifier(MBINCroIDOldTemplatingClassifier(oldDocumentNumberParser))
        }
        // configure new version class
        do {
            neID = MBINTemplatingClass()
            neID?.setClassificationProcessorGroups([documentNumberNewID!])
            neID?.setNonClassificationProcessorGroups([firstNameNewID!, lastNameNewID!, sexCitizenshipDOBNewID!, faceNewID!, fullDocument!])
            neID?.setTemplatingClassifier(MBCroIDNewTemplatingClassifier(neDocumentNumberParser))
        }
    }
    
    /**
     * This functions configures DetectorRecognizer with DocumentDetector that will detect ID card
     * and associates templating classes for old and new version of ID card with it.
     */
    
    func configureDetectorRecognizer() {
        documentDetector = MBINDocumentDetector(documentSpecifications: [MBINDocumentSpecification.create(from: MBINDocumentSpecificationPreset.id1Card)])
        detectorRecognizer = MBINDetectorRecognizer(quadWithSizeDetector: documentDetector!)
        detectorRecognizer?.setTemplatingClasses([oldID!, neID!])
        
        /*
         * If detector which cannot determine orientation is used, like in this case*, allow
         * flipped recognition. This will ensure that after detection has been performed and nothing
         * was extracted from any of the decoding locations inherent to the detector, the detection
         * will be flipped and process will be repeated. This is slower, but enables scanning of
         * Croatian IDs which are held upside down.
         *
         * * DocumentDetector performs detection based on document edges. Since documents are symmetric,
         *   it cannot know the correct orientation of the text. Some other detectors, like
         *   MRTDDetector, have the ability to know the correct orientation of the text on document.
         */
        detectorRecognizer?.allowFlipped = true
    }
    
    func resultDescription() -> String? {
        return "First name:'\(String(describing: firstNameParser?.result.parsedString))' \nLast name: '\(String(describing: lastNameParser?.result.parsedString))' \nSex: '\(String(describing: sexParser?.result.parsedString))' \nCitizenship: '\(String(describing: citizenshipParser?.result.parsedString))' \n)'"
    }
}
