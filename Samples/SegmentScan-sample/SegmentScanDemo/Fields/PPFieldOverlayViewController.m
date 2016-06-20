//
//  PPFieldOverlayViewController.m
//  SegmentScanDemo
//
//  Created by Dino on 08/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

#import "PPFieldOverlayViewController.h"
#import <Foundation/Foundation.h>
#import <MicroBlink/PPModernOcrResultOverlaySubview.h>

@interface PPFieldOverlayViewController ()

@property(nonatomic) int maxNumCharacters;

@property(nonatomic) int maxNumLines;

@property(strong, nonatomic) IBOutlet UIView *borderViewPlaceholder;

@property(nonatomic) NSMutableArray<NSLayoutConstraint *> *currentConstraintss;

@property(weak, nonatomic) IBOutlet UIButton *buttonLight;

@property(nonatomic) BOOL lightOn;

@end

@implementation PPFieldOverlayViewController

+ (instancetype)viewControllerFromStoryboardWithElement:(PPScanElement *)element {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PPFieldOverlayViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PPFieldOverlayViewController"];
    controller.element = element;
    controller.maxNumCharacters = 16;
    controller.maxNumLines = 0;
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lightOn = NO;
    //    self.borderView = [[UIView alloc] init];
    self.borderViewPlaceholder.layer.borderWidth = 2.0f;
    self.borderViewPlaceholder.layer.borderColor = [[UIColor colorWithWhite:1.0f alpha:1.0f] CGColor];
    self.borderViewPlaceholder.layer.cornerRadius = 5.0f;

    [self setLabelsForElement:self.element];

    self.currentConstraintss = [NSMutableArray array];
    [self updateScanningRegion];

    PPModernOcrResultOverlaySubview *resultOverlay = [[PPModernOcrResultOverlaySubview alloc] initWithFrame:self.view.frame];
    [resultOverlay setTranslatesAutoresizingMaskIntoConstraints:NO];
    resultOverlay.shouldIgnoreFastResults = YES;
    resultOverlay.backgroundColor = [UIColor clearColor];
    [self.view addSubview:resultOverlay];
    [self registerOverlaySubview:resultOverlay];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:resultOverlay
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:resultOverlay
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:resultOverlay
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:resultOverlay
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

CGRect CGRectSetCenter(CGRect rect, CGPoint center) {
    return CGRectMake(center.x - rect.size.width / 2, center.y - rect.size.height / 2, rect.size.width, rect.size.height);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.view.frame.size.height == 0)
        return;
}

- (void)setElement:(PPScanElement *)element {
    _element = element;
    [self setLabelsForElement:element];
    [self updateScanningRegion];
}

- (IBAction)buttonLightPressed:(id)sender {
    BOOL success = [self.containerViewController overlayViewController:self willSetTorch:!self.lightOn];
    self.lightOn = self.lightOn ^ success;
}

- (void)updateScanningRegion {

    [self.view layoutIfNeeded];
    for (NSLayoutConstraint *constraint in self.currentConstraintss) {
        [self.view removeConstraint:constraint];
    }
    [self.currentConstraintss removeAllObjects];

    [self.currentConstraintss addObject:[NSLayoutConstraint constraintWithItem:self.borderViewPlaceholder
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeHeight
                                                                    multiplier:self.element.scanningRegionHeight * 1.5
                                                                      constant:0.0]];
    [self.currentConstraintss addObject:[NSLayoutConstraint constraintWithItem:self.borderViewPlaceholder
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:self.element.scanningRegionWidth
                                                                      constant:0.0]];

    for (NSLayoutConstraint *constraint in self.currentConstraintss) {
        [self.view addConstraint:constraint];
    }

    [UIView animateWithDuration:0.5
                     animations:^{
                       [self.view layoutIfNeeded];
                     }];

    self.scanningRegion = CGRectMake(
        self.borderViewPlaceholder.frame.origin.x / self.view.frame.size.width, self.borderViewPlaceholder.frame.origin.y / self.view.frame.size.height,
        self.borderViewPlaceholder.frame.size.width / self.view.frame.size.width, self.borderViewPlaceholder.frame.size.height / self.view.frame.size.height);
}

- (void)setLabelsForElement:(PPScanElement *)element {
    [UIView transitionWithView:self.labelTitle
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                      self.labelTitle.text = element.localizedTooltip;
                    }
                    completion:nil];
}

@end
