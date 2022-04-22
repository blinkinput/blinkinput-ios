//
//  MBEncodedFullDocumentImageResult.h
//  MicroblinkDev
//
//  Created by DoDo on 17/05/2018.
//

#ifndef MBEncodedFullDocumentImageResult_h
#define MBEncodedFullDocumentImageResult_h

@protocol MBIEncodedFullDocumentImageResult

@required

/**
 * JPEG-encoded full document image if enabled with `MBIEncodeFullDocumentImage encodeFullDocumentImage` property.
 */
@property (nonatomic, readonly, nullable) NSData* encodedFullDocumentImage;

@end

#endif /* MBEncodedFullDocumentImageResult_h */
