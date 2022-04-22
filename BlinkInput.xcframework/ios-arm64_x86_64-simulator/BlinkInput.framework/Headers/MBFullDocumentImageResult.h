//
//  MBFullDocumentImageResult.h
//  MicroblinkDev
//
//  Created by DoDo on 16/04/2018.
//

#ifndef MBFullDocumentImageResult_h
#define MBFullDocumentImageResult_h

#import "MBImage.h"

@protocol MBIFullDocumentImageResult

@required

/**
 * full document image if enabled with `MBIFullDocumentImage returnFullDocumentImage` property.
 */
@property (nonatomic, readonly, nullable) MBIImage* fullDocumentImage;

@end

#endif /* MBFullDocumentImageResult_h */
