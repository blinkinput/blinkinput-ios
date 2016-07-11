//
//  PPResultViewController.h
//  BlinkIDScan
//
//  Created by Dino on 26/01/16.
//  Copyright © 2016 Dino. All rights reserved.
//

#import "UIKit/UIKit.h"

@protocol PPResultViewControllerDelegate;

/**
 * View Controller for presenting key-value pairs
 */
@interface PPResultViewController : UIViewController

/**
 * Text of the title shown on view
 */
@property(nonatomic) NSString *titleText;

/**
 * Dictionary which will generate labels. Keys will be labels on the left side, while values will be labels on the right side
 */
@property(nonatomic, readonly) NSDictionary *labelMap;

/**
 * Array that contains keys of shown labels. The order of shown labels will be the same as order of keys in array.
 * The view will be populated only by keys located in this array. If nil, labels will be populated randomly from labelMap property.
 *
 * Default: nil
 */
@property(nonatomic, readonly) NSArray *keyOrderList;

/**
 * Sub title of the view
 */
@property(nonatomic) NSString *subTitle;

/**
 * Text on the bottom-right button on the view
 */
@property(nonatomic) NSString *rightButtonTitle;

/**
 * Delegate for button tap events.
 */
@property(nonatomic) id<PPResultViewControllerDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title labels:(NSDictionary *)labels subTitle:(NSString *)subTitle labelOrder:(NSArray *)orderList;

@end

@protocol PPResultViewControllerDelegate <NSObject>

- (void)buttonCloseDidTap:(PPResultViewController *)viewController;

- (void)buttonRightDidTap:(PPResultViewController *)viewController;

- (void)buttonMiddleDidTap:(PPResultViewController *)viewController;

@end
