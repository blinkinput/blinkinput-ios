//
//  MBFullDocumentImageExtensionFactors.h
//  MicroblinkDev
//
//  Created by Dino on 19/06/2018.
//

#import "MBImageExtensionFactors.h"

@protocol MBINFullDocumentImageExtensionFactors

@required

/**
 * Image extension factors for full document image.
 *
 * @see MBINImageExtensionFactors
 * Default: {0.0f, 0.0f, 0.0f, 0.0f}
 */
@property (nonatomic, assign) MBINImageExtensionFactors fullDocumentImageExtensionFactors;

@end
