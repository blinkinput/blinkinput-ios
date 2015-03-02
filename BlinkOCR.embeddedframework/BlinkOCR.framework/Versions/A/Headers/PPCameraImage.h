//
//  PPCameraImage.h
//  PhotoPayFramework
//
//  Created by Marko Mihovilić on 02/12/14.
//  Copyright (c) 2014 Racuni.hr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PPCameraImage <NSObject>

@property (nonatomic, assign) UIImageOrientation orientation;

- (UIImage*)image;
- (UIImage*)rotatedImage;

@end
