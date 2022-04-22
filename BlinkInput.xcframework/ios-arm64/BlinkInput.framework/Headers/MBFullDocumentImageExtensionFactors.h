//
//  MBFullDocumentImageExtensionFactors.h
//  MicroblinkDev
//
//  Created by Dino on 19/06/2018.
//

#import "MBImageExtensionFactors.h"

@protocol MBIFullDocumentImageExtensionFactors

@required

/**
 * Image extension factors for full document image.
 *
 * @see MBIImageExtensionFactors
 * Default: {0.0f, 0.0f, 0.0f, 0.0f}
 */
@property (nonatomic, assign) MBIImageExtensionFactors fullDocumentImageExtensionFactors;

@end
