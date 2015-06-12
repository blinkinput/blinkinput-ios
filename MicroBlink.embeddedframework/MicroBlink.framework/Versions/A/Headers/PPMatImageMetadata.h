//
//  PPMatImageMetadata.h
//  PhotoPayFramework
//
//  Created by Jura on 02/03/15.
//  Copyright (c) 2015 MicroBlink Ltd. All rights reserved.
//

#import "PPImageMetadata.h"

@interface PPMatImageMetadata : PPImageMetadata

- (instancetype)initWithName:(NSString*)name
                         mat:(const cv::Mat&)mat;

@end
