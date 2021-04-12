//
//  MBICroatianIDFrontTemplateRecognizer.swift
//  Templating-sample-swift
//
//  Created by Jura Skrlec on 10/05/2018.
//  Copyright © 2018 Microblink. All rights reserved.
//

import Foundation
import BlinkInput

class MBICroIDNewTemplatingClassifier: NSObject, MBITemplatingClassifier {
    private(set) weak var documentNumberNewRegexParser: MBIRegexParser?
    
    init(_ parser: MBIRegexParser?) {
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

class MBICroIDOldTemplatingClassifier: NSObject, MBITemplatingClassifier {
    private(set) weak var documentNumberOldRegexParser: MBIRegexParser?
    
    init(_ parser: MBIRegexParser?) {
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

class MBICroatianIDFrontTemplateRecognizer : NSObject {
    
    var firstNameParser: MBIRegexParser?
    var lastNameParser: MBIRegexParser?
    var sexParser: MBIRegexParser?
    var citizenshipParser: MBIRegexParser?
    var oldDocumentNumberParser: MBIRegexParser?
    var neDocumentNumberParser: MBIRegexParser?
    var dateOfBirthParser: MBIDateParser?
    
    var firstNameParseGroupProcessor: MBIParserGroupProcessor?
    var lastNameParseGroupProcessor: MBIParserGroupProcessor?
    var sexCitizenshipDOBGroup: MBIParserGroupProcessor?
    var oldDocumentNumberGroup: MBIParserGroupProcessor?
    var neDocumentNumberGroup: MBIParserGroupProcessor?
    var fullDocumentImage: MBIImageReturnProcessor?
    var faceImage: MBIImageReturnProcessor?
    
    var firstNameOldID: MBIProcessorGroup?
    var firstNameNewID: MBIProcessorGroup?
    var lastNameOldID: MBIProcessorGroup?
    var lastNameNewID: MBIProcessorGroup?
    var sexCitizenshipDOBOldID: MBIProcessorGroup?
    var sexCitizenshipDOBNewID: MBIProcessorGroup?
    var documentNumberOldID: MBIProcessorGroup?
    var documentNumberNewID: MBIProcessorGroup?
    var faceOldID: MBIProcessorGroup?
    var faceNewID: MBIProcessorGroup?
    var fullDocument: MBIProcessorGroup?
    
    var oldID: MBITemplatingClass?
    var neID: MBITemplatingClass?
    var documentDetector: MBIDocumentDetector?
    var detectorRecognizer: MBIDetectorRecognizer?
    
    override init() {
        super.init()
        
        configureParsers()
        configureProcessors()
        configureProcessorGroup()
        configureClasses()
        configureDetectorRecognizer()
        
    }
    
    func configureParsers() {
        firstNameParser = MBIRegexParser(regex: "([A-ZŠĐŽČĆ]+ ?)+")
        let ocrEngineOptions = MBIOcrEngineOptions()
        ocrEngineOptions.charWhitelist = MBCroatianIDTemplateUtils.croatianCharsWhitelist()
        firstNameParser?.ocrEngineOptions = ocrEngineOptions
        lastNameParser = firstNameParser?.copy() as? MBIRegexParser
        sexParser = MBIRegexParser(regex: "[MŽ]/[MF]")
        do {
            let sexOptions = MBIOcrEngineOptions()
            var charWhitelist = Set<MBIOcrCharKey>()
            charWhitelist.insert(MBIOcrCharKey(code:  Int32(UnicodeScalar("M").value), font: MBIOcrFont.MB_OCR_FONT_ANY))
            charWhitelist.insert(MBIOcrCharKey(code:  Int32(UnicodeScalar("F").value), font: MBIOcrFont.MB_OCR_FONT_ANY))
            charWhitelist.insert(MBIOcrCharKey(code:  Int32(UnicodeScalar("/").value), font: MBIOcrFont.MB_OCR_FONT_ANY))
            charWhitelist.insert(MBIOcrCharKey(code:  Int32(UnicodeScalar("Ž").value), font: MBIOcrFont.MB_OCR_FONT_ANY))
            
            sexOptions.charWhitelist = charWhitelist
            sexParser?.ocrEngineOptions = sexOptions
        }
        
        sexParser?.endWithWhitespace = true
        sexParser?.startWithWhitespace = true
        
        citizenshipParser = MBIRegexParser(regex: "[A-Z]{3}")
        do {
            let citizenshipOptions = MBIOcrEngineOptions()
            var charWhitelist = Set<MBIOcrCharKey>()
            charWhitelist.insert(MBIOcrCharKey(code: Int32(UnicodeScalar("H").value), font: MBIOcrFont.MB_OCR_FONT_ANY))
            charWhitelist.insert(MBIOcrCharKey(code: Int32(UnicodeScalar("R").value), font: MBIOcrFont.MB_OCR_FONT_ANY))
            charWhitelist.insert(MBIOcrCharKey(code: Int32(UnicodeScalar("V").value), font: MBIOcrFont.MB_OCR_FONT_ANY))
            citizenshipOptions.charWhitelist = charWhitelist
            
            citizenshipParser?.ocrEngineOptions = citizenshipOptions
        }
        
        citizenshipParser?.endWithWhitespace = true
        citizenshipParser?.startWithWhitespace = true
        oldDocumentNumberParser = MBIRegexParser(regex: "\\d{9}")
        neDocumentNumberParser = oldDocumentNumberParser?.copy() as? MBIRegexParser
        
        dateOfBirthParser = MBIDateParser()
    }
    
    /**
     * This function will configure processors that will be used on different processing locations.
     */
    func configureProcessors() {
        // put first name parser in its own parser group
        firstNameParseGroupProcessor = MBIParserGroupProcessor(parsers: [firstNameParser!])
        // also do the same for last name parser
        lastNameParseGroupProcessor = MBIParserGroupProcessor(parsers: [lastNameParser!])
        // sex, citizenship and date of birth can be in same group
        sexCitizenshipDOBGroup = MBIParserGroupProcessor(parsers: [sexParser!, citizenshipParser!, dateOfBirthParser!])
        // document number group for old and new IDs
        oldDocumentNumberGroup = MBIParserGroupProcessor(parsers: [oldDocumentNumberParser!])
        neDocumentNumberGroup = MBIParserGroupProcessor(parsers: [neDocumentNumberParser!])
        
        fullDocumentImage = MBIImageReturnProcessor()
        faceImage = MBIImageReturnProcessor()
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
        
        firstNameOldID = MBIProcessorGroup(processingLocation: CGRect(x: 0.282, y: 0.333, width: 0.306, height: 0.167), dewarpPolicy: MBIFixedDewarpPolicy(dewarpHeight: 150), andProcessors: [firstNameParseGroupProcessor!])
        firstNameNewID = MBIProcessorGroup(processingLocation: CGRect(x: 0.282, y: 0.389, width: 0.353, height: 0.167), dewarpPolicy: MBIFixedDewarpPolicy(dewarpHeight: 150), andProcessors: [firstNameParseGroupProcessor!])
        lastNameOldID = MBIProcessorGroup(processingLocation: CGRect(x: 0.271, y: 0.204, width: 0.318, height: 0.111), dewarpPolicy: MBIFixedDewarpPolicy(dewarpHeight: 100), andProcessors: [lastNameParseGroupProcessor!])
        lastNameNewID = MBIProcessorGroup(processingLocation: CGRect(x: 0.282, y: 0.204, width: 0.353, height: 0.167), dewarpPolicy: MBIFixedDewarpPolicy(dewarpHeight: 100), andProcessors: [lastNameParseGroupProcessor!])
        
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
        sexCitizenshipDOBOldID = MBIProcessorGroup(processingLocation: CGRect(x: 0.412, y: 0.500, width: 0.259, height: 0.296), dewarpPolicy: MBIFixedDewarpPolicy(dewarpHeight: 300), andProcessors: [sexCitizenshipDOBGroup!])
        sexCitizenshipDOBNewID = MBIProcessorGroup(processingLocation: CGRect(x: 0.388, y: 0.500, width: 0.282, height: 0.296), dewarpPolicy: MBIFixedDewarpPolicy(dewarpHeight: 300), andProcessors: [sexCitizenshipDOBGroup!])
        
        //------------------------------------------------------------------------------------------
        // Document number
        //------------------------------------------------------------------------------------------
        // In same way as above, we create ProcessorGroup for old and new versions of document number
        // parsers.
        //------------------------------------------------------------------------------------------
        documentNumberOldID = MBIProcessorGroup(processingLocation: CGRect(x: 0.047, y: 0.519, width: 0.224, height: 0.111), dewarpPolicy: MBIFixedDewarpPolicy(dewarpHeight: 150), andProcessors: [oldDocumentNumberGroup!])
        documentNumberNewID = MBIProcessorGroup(processingLocation: CGRect(x: 0.047, y: 0.685, width: 0.224, height: 0.111), dewarpPolicy: MBIFixedDewarpPolicy(dewarpHeight: 150), andProcessors: [neDocumentNumberGroup!])
        
        //------------------------------------------------------------------------------------------
        // Face image
        //------------------------------------------------------------------------------------------
        // In same way as above, we create ProcessorGroup for image of the face on document.
        //------------------------------------------------------------------------------------------
        faceOldID = MBIProcessorGroup(processingLocation: CGRect(x: 0.650, y: 0.277, width: 0.270, height: 0.630), dewarpPolicy: MBIDPIBasedDewarpPolicy(desiredDPI: 200), andProcessors: [faceImage!])
        faceNewID = MBIProcessorGroup(processingLocation: CGRect(x: 0.659, y: 0.407, width: 0.294, height: 0.574), dewarpPolicy: MBIDPIBasedDewarpPolicy(desiredDPI: 200), andProcessors: [faceImage!])
        
        //------------------------------------------------------------------------------------------
        // Full document image
        //------------------------------------------------------------------------------------------
        // location of full document is same regardless of document version
        //------------------------------------------------------------------------------------------
        fullDocument = MBIProcessorGroup(processingLocation: CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0), dewarpPolicy: MBIDPIBasedDewarpPolicy(desiredDPI: 200), andProcessors: [fullDocumentImage!])
    }
    
    /**
     * This function will configure classes for old and new version of the document and classifiers
     * for each class.
     */
    func configureClasses() {
        // configure old version class
        do {
            oldID = MBITemplatingClass()
            oldID?.setClassificationProcessorGroups([documentNumberOldID!])
            oldID?.setNonClassificationProcessorGroups([firstNameOldID!, lastNameOldID!, sexCitizenshipDOBOldID!, faceOldID!, fullDocument!])
            oldID?.setTemplatingClassifier(MBICroIDOldTemplatingClassifier(oldDocumentNumberParser))
        }
        // configure new version class
        do {
            neID = MBITemplatingClass()
            neID?.setClassificationProcessorGroups([documentNumberNewID!])
            neID?.setNonClassificationProcessorGroups([firstNameNewID!, lastNameNewID!, sexCitizenshipDOBNewID!, faceNewID!, fullDocument!])
            neID?.setTemplatingClassifier(MBICroIDNewTemplatingClassifier(neDocumentNumberParser))
        }
    }
    
    /**
     * This functions configures DetectorRecognizer with DocumentDetector that will detect ID card
     * and associates templating classes for old and new version of ID card with it.
     */
    
    func configureDetectorRecognizer() {
        documentDetector = MBIDocumentDetector(documentSpecifications: [MBIDocumentSpecification.create(from: MBIDocumentSpecificationPreset.id1Card)])
        detectorRecognizer = MBIDetectorRecognizer(quadWithSizeDetector: documentDetector!)
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
