//
//  MBCroatianIDFrontTemplateRecognizer.h
//  Showcase
//
//  Created by Jura Skrlec on 23/03/2018.
//  Copyright © 2018 MicroBlink Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MicroBlink/MicroBlink.h>

@interface MBCroatianIDFrontTemplateRecognizer : NSObject

@property (nonatomic, strong) MBRegexParser *firstNameParser;
@property (nonatomic, strong) MBRegexParser *lastNameParser;
@property (nonatomic, strong) MBRegexParser *sexParser;
@property (nonatomic, strong) MBRegexParser *citizenshipParser;
@property (nonatomic, strong) MBRegexParser *oldDocumentNumberParser;
@property (nonatomic, strong) MBRegexParser *neDocumentNumberParser;
@property (nonatomic, strong) MBDateParser *dateOfBirthParser;

@property (nonatomic, strong) MBParserGroupProcessor *firstNameParseGroupProcessor;
@property (nonatomic, strong) MBParserGroupProcessor *lastNameParseGroupProcessor;
@property (nonatomic, strong) MBParserGroupProcessor *sexCitizenshipDOBGroup;
@property (nonatomic, strong) MBParserGroupProcessor *oldDocumentNumberGroup;
@property (nonatomic, strong) MBParserGroupProcessor *neDocumentNumberGroup;
@property (nonatomic, strong) MBImageReturnProcessor *fullDocumentImage;
@property (nonatomic, strong) MBImageReturnProcessor *faceImage;

@property (nonatomic, strong) MBProcessorGroup *firstNameOldID;
@property (nonatomic, strong) MBProcessorGroup *firstNameNewID;
@property (nonatomic, strong) MBProcessorGroup *lastNameOldID;
@property (nonatomic, strong) MBProcessorGroup *lastNameNewID;
@property (nonatomic, strong) MBProcessorGroup *sexCitizenshipDOBOldID;
@property (nonatomic, strong) MBProcessorGroup *sexCitizenshipDOBNewID;
@property (nonatomic, strong) MBProcessorGroup *documentNumberOldID;
@property (nonatomic, strong) MBProcessorGroup *documentNumberNewID;
@property (nonatomic, strong) MBProcessorGroup *faceOldID;
@property (nonatomic, strong) MBProcessorGroup *faceNewID;
@property (nonatomic, strong) MBProcessorGroup *fullDocument;

@property (nonatomic, strong) MBTemplatingClass *oldID;
@property (nonatomic, strong) MBTemplatingClass *neID;

@property (nonatomic, strong) MBDocumentDetector *documentDetector;
@property (nonatomic, strong) MBDetectorRecognizer *detectorRecognizer;

- (NSString *)resultDescription;

@end
