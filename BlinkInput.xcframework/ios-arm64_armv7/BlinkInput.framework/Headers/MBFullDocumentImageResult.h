//
//  MBFullDocumentImageResult.h
//  MicroblinkDev
//
//  Created by DoDo on 16/04/2018.
//

#ifndef MBFullDocumentImageResult_h
#define MBFullDocumentImageResult_h

#import "MBImage.h"

@protocol MBINFullDocumentImageResult

@required

/**
 * full document image if enabled with `MBINFullDocumentImage returnFullDocumentImage` property.
 */
@property (nonatomic, readonly, nullable) MBINImage* fullDocumentImage;

@end

#endif /* MBFullDocumentImageResult_h */
