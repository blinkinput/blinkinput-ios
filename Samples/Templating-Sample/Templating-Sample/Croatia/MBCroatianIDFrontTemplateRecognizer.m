//
//  MBCroatianIDFrontTemplateRecognizer.m
//  Showcase
//
//  Created by Jura Skrlec on 23/03/2018.
//  Copyright © 2018 MicroBlink Ltd. All rights reserved.
//

#import "MBCroatianIDFrontTemplateRecognizer.h"
#import "MBCroatianIDTemplateUtils.h"

@interface MBCroIDNewTemplatingClassifier : NSObject<MBTemplatingClassifier>

@property (readonly, weak) MBRegexParser *documentNumberNewRegexParser;

- (instancetype)initWith:(MBRegexParser *)parser;

@end

@implementation MBCroIDNewTemplatingClassifier

- (instancetype)initWith:(MBRegexParser *)parser {
    self = [super init];
    if (self) {
        _documentNumberNewRegexParser = parser;
    }
    
    return self;
}

- (BOOL)classify {
    return  [_documentNumberNewRegexParser.result.parsedString length];
}

@end

@interface MBCroIDOldTemplatingClassifier : NSObject<MBTemplatingClassifier>

@property (readonly, weak) MBRegexParser *documentNumberOldRegexParser;

- (instancetype)initWith:(MBRegexParser *)parser;

@end

@implementation MBCroIDOldTemplatingClassifier

- (instancetype)initWith:(MBRegexParser *)parser {
    self = [super init];
    if (self) {
       _documentNumberOldRegexParser = parser;
    }
    
    return self;
}

- (BOOL)classify {
    return  [_documentNumberOldRegexParser.result.parsedString length];
}

@end

@interface MBCroatianIDFrontTemplateRecognizer()

@end

@implementation MBCroatianIDFrontTemplateRecognizer

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureParsers];
        [self configureProcessors];
        [self configureProcessorGroup];
        [self configureClasses];
        [self configureDetectorRecognizer];
    }
    
    return self;
}

/**
 * This function fill configure parsers for parsing data from OCR.
 */
- (void)configureParsers {
    
    self.firstNameParser = [[MBRegexParser alloc] initWithRegex:@"([A-ZŠĐŽČĆ]+ ?)+"];
    MBOcrEngineOptions *ocrEngineOptions = [[MBOcrEngineOptions alloc] init];
    
    ocrEngineOptions.charWhitelist = [MBCroatianIDTemplateUtils croatianCharsWhitelist];
    self.firstNameParser.ocrEngineOptions = ocrEngineOptions;
    
    self.lastNameParser = [self.firstNameParser copy];
    
    self.sexParser = [[MBRegexParser alloc] initWithRegex:@"[MŽ]/[MF]"];
    {
        MBOcrEngineOptions *sexOptions = [[MBOcrEngineOptions alloc] init];
        NSMutableSet *charWhitelist = [[NSMutableSet alloc] init];
        [charWhitelist addObject:[MBOcrCharKey keyWithCode:'M' font:MB_OCR_FONT_ANY]];
        [charWhitelist addObject:[MBOcrCharKey keyWithCode:'F' font:MB_OCR_FONT_ANY]];
        [charWhitelist addObject:[MBOcrCharKey keyWithCode:'/' font:MB_OCR_FONT_ANY]];
        [charWhitelist addObject:[MBOcrCharKey keyWithCode:L'Ž' font:MB_OCR_FONT_ANY]];
        sexOptions.charWhitelist = charWhitelist;
        self.sexParser.ocrEngineOptions = sexOptions;
    }
    self.sexParser.endWithWhitespace = YES;
    self.sexParser.startWithWhitespace = YES;
    
    self.citizenshipParser = [[MBRegexParser alloc] initWithRegex:@"[A-Z]{3}"];
    
    {
        MBOcrEngineOptions *citizenshipOptions = [[MBOcrEngineOptions alloc] init];
        NSMutableSet *charWhitelist = [[NSMutableSet alloc] init];
        [charWhitelist addObject:[MBOcrCharKey keyWithCode:'H' font:MB_OCR_FONT_ANY]];
        [charWhitelist addObject:[MBOcrCharKey keyWithCode:'R' font:MB_OCR_FONT_ANY]];
        [charWhitelist addObject:[MBOcrCharKey keyWithCode:'V' font:MB_OCR_FONT_ANY]];
        citizenshipOptions.charWhitelist = charWhitelist;
        
        citizenshipOptions.charWhitelist = charWhitelist;
        self.citizenshipParser.ocrEngineOptions = citizenshipOptions;
    }
    self.citizenshipParser.endWithWhitespace = YES;
    self.citizenshipParser.startWithWhitespace = YES;
    
    self.oldDocumentNumberParser = [[MBRegexParser alloc] initWithRegex:@"\\d{9}"];
    self.oldDocumentNumberParser.ocrEngineOptions.minimalLineHeight = 35;
    
    self.neDocumentNumberParser = [self.oldDocumentNumberParser copy];
    
    self.dateOfBirthParser = [[MBDateParser alloc] init];
}

/**
 * This function will configure processors that will be used on different processing locations.
 */
- (void)configureProcessors {
    
    // put first name parser in its own parser group
    self.firstNameParseGroupProcessor = [[MBParserGroupProcessor alloc] initWithParsers:@[self.firstNameParser]];
    
    // also do the same for last name parser
    self.lastNameParseGroupProcessor = [[MBParserGroupProcessor alloc] initWithParsers:@[self.lastNameParser]];
    
    // sex, citizenship and date of birth can be in same group
    self.sexCitizenshipDOBGroup = [[MBParserGroupProcessor alloc] initWithParsers:@[self.sexParser, self.citizenshipParser, self.dateOfBirthParser]];
    
    // document number group for old and new IDs
    self.oldDocumentNumberGroup = [[MBParserGroupProcessor alloc] initWithParsers:@[self.oldDocumentNumberParser]];
    self.neDocumentNumberGroup = [[MBParserGroupProcessor alloc] initWithParsers:@[self.neDocumentNumberParser]];
    
    // also create ImageReturnProcessors that will simply save the image that comes for processing
    self.fullDocumentImage = [[MBImageReturnProcessor alloc] init];
    self.faceImage = [[MBImageReturnProcessor alloc] init];
}

/**
 * This function will configure processor groups for each processing location in old and new
 * version of front side of Croatian ID cards.
 */
- (void)configureProcessorGroup {
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
    
    
    self.firstNameOldID = [[MBProcessorGroup alloc] initWithProcessingLocation:CGRectMake(0.282f, 0.333f, 0.306f, 0.167f)
                                                                  dewarpPolicy:[[MBFixedDewarpPolicy alloc] initWithDewarpHeight:150]
                                                                 andProcessors:@[self.firstNameParseGroupProcessor]];
    
    self.firstNameNewID = [[MBProcessorGroup alloc] initWithProcessingLocation:CGRectMake(0.282f, 0.389f, 0.353f, 0.167f)
                                                                  dewarpPolicy:[[MBFixedDewarpPolicy alloc] initWithDewarpHeight:150]
                                                                 andProcessors:@[self.firstNameParseGroupProcessor]];
    
    self.lastNameOldID = [[MBProcessorGroup alloc] initWithProcessingLocation:CGRectMake(0.271f, 0.204f, 0.318f, 0.111f)
                                                                  dewarpPolicy:[[MBFixedDewarpPolicy alloc] initWithDewarpHeight:100]
                                                                 andProcessors:@[self.lastNameParseGroupProcessor]];
    
    self.lastNameNewID = [[MBProcessorGroup alloc] initWithProcessingLocation:CGRectMake(0.282f, 0.204f, 0.353f, 0.167f)
                                                                 dewarpPolicy:[[MBFixedDewarpPolicy alloc] initWithDewarpHeight:100]
                                                                andProcessors:@[self.lastNameParseGroupProcessor]];
    
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
    self.sexCitizenshipDOBOldID = [[MBProcessorGroup alloc] initWithProcessingLocation:CGRectMake(0.412f, 0.500f, 0.259f, 0.296f)
                                                                 dewarpPolicy:[[MBFixedDewarpPolicy alloc] initWithDewarpHeight:300]
                                                                andProcessors:@[self.sexCitizenshipDOBGroup]];
    
    self.sexCitizenshipDOBNewID = [[MBProcessorGroup alloc] initWithProcessingLocation:CGRectMake(0.388f, 0.500f, 0.282f, 0.296f)
                                                                          dewarpPolicy:[[MBFixedDewarpPolicy alloc] initWithDewarpHeight:300]
                                                                         andProcessors:@[self.sexCitizenshipDOBGroup]];
    
    //------------------------------------------------------------------------------------------
    // Document number
    //------------------------------------------------------------------------------------------
    // In same way as above, we create ProcessorGroup for old and new versions of document number
    // parsers.
    //------------------------------------------------------------------------------------------

    self.documentNumberOldID = [[MBProcessorGroup alloc] initWithProcessingLocation:CGRectMake(0.047f, 0.519f, 0.224f, 0.111f)
                                                                          dewarpPolicy:[[MBFixedDewarpPolicy alloc] initWithDewarpHeight:150]
                                                                         andProcessors:@[self.oldDocumentNumberGroup]];
    
    self.documentNumberNewID = [[MBProcessorGroup alloc] initWithProcessingLocation:CGRectMake(0.047f, 0.685f, 0.224f, 0.111f)
                                                                       dewarpPolicy:[[MBFixedDewarpPolicy alloc] initWithDewarpHeight:150]
                                                                      andProcessors:@[self.neDocumentNumberGroup]];
    
    //------------------------------------------------------------------------------------------
    // Face image
    //------------------------------------------------------------------------------------------
    // In same way as above, we create ProcessorGroup for image of the face on document.
    //------------------------------------------------------------------------------------------
    self.faceOldID = [[MBProcessorGroup alloc] initWithProcessingLocation:CGRectMake(0.650f, 0.277f, 0.270f, 0.630f )
                                                                       dewarpPolicy:[[MBDPIBasedDewarpPolicy alloc] initWithDesiredDPI:200]
                                                                      andProcessors:@[self.faceImage]];
    
    self.faceNewID = [[MBProcessorGroup alloc] initWithProcessingLocation:CGRectMake(0.659f, 0.407f, 0.294f, 0.574f)
                                                             dewarpPolicy:[[MBDPIBasedDewarpPolicy alloc] initWithDesiredDPI:200]
                                                            andProcessors:@[self.faceImage]];
    
    //------------------------------------------------------------------------------------------
    // Full document image
    //------------------------------------------------------------------------------------------
    // location of full document is same regardless of document version
    //------------------------------------------------------------------------------------------
    self.fullDocument = [[MBProcessorGroup alloc] initWithProcessingLocation:CGRectMake(0.f, 0.f, 1.f, 1.f)
                                                             dewarpPolicy:[[MBDPIBasedDewarpPolicy alloc] initWithDesiredDPI:200]
                                                            andProcessors:@[self.fullDocumentImage]];
}

/**
 * This function will configure classes for old and new version of the document and classifiers
 * for each class.
 */
- (void)configureClasses {
    
    // configure old version class
    {
        self.oldID = [[MBTemplatingClass alloc] init];
        [self.oldID setClassificationProcessorGroups:@[self.documentNumberOldID]];
        [self.oldID setNonClassificationProcessorGroups:@[self.firstNameOldID, self.lastNameOldID, self.sexCitizenshipDOBOldID, self.faceOldID, self.fullDocument]];
        
        [self.oldID setTemplatingClassifier:[[MBCroIDOldTemplatingClassifier alloc] initWith:self.oldDocumentNumberParser]];
        
    }
    // configure new version class
    {
        self.neID = [[MBTemplatingClass alloc] init];
        [self.neID setClassificationProcessorGroups:@[self.documentNumberNewID]];
        [self.neID setNonClassificationProcessorGroups:@[self.firstNameNewID, self.lastNameNewID, self.sexCitizenshipDOBNewID, self.faceNewID, self.fullDocument]];
        
        [self.neID setTemplatingClassifier:[[MBCroIDNewTemplatingClassifier alloc] initWith:self.neDocumentNumberParser]];
    }
    
}

/**
 * This functions configures DetectorRecognizer with DocumentDetector that will detect ID card
 * and associates templating classes for old and new version of ID card with it.
 */
- (void)configureDetectorRecognizer {
    
    self.documentDetector = [[MBDocumentDetector alloc] init];
    [self.documentDetector setDocumentSpecifications:@[[MBDocumentSpecification createFromPreset:MBDocumentSpecificationId1Card]]];
    
    self.detectorRecognizer = [[MBDetectorRecognizer alloc] initWithDetector:self.documentDetector];
    [self.detectorRecognizer setTemplatingClasses:@[self.oldID, self.neID]];
    
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
    self.detectorRecognizer.allowFlipped = YES;
}

- (NSString *)resultDescription {
    return [NSString stringWithFormat:@"First name:'%@' \nLast name: '%@' \nSex: '%@' \nCitizenship: '%@' \nNew document number:'%@'", self.firstNameParser.result.parsedString, self.lastNameParser.result.parsedString, self.sexParser.result.parsedString, self.citizenshipParser.result.parsedString, self.neDocumentNumberParser.result.parsedString];
}

@end

