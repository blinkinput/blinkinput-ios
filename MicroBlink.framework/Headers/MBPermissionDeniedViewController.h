//
//  MBPermissionDeniedViewController.h
//  PhotoPayFramework
//
//  Created by Dino on 16/08/16.
//  Copyright © 2016 MicroBlink Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPMicroBlinkDefines.h"

@protocol MBPermissionDeniedDelegate;

PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBPermissionDeniedViewController : UIViewController

@property (nonatomic) id<MBPermissionDeniedDelegate> delegate;

@property (nonatomic, assign) BOOL hideCancelButton;

@end

@protocol MBPermissionDeniedDelegate <NSObject>

- (void)userDidTapCancel:(MBPermissionDeniedViewController *)viewController;

@end
