//
//  PPAvailableParsersViewController.m
//  SegmentScanDemo
//
//  Created by Dino on 03/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

#import "PPAvailableParsersViewController.h"
#import "PPParsers.h"

@interface PPAvailableParsersViewController ()

@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(weak, nonatomic) IBOutlet UIView *scrollContentView;
@property(nonatomic) NSArray *scanElements;

@end

@implementation PPAvailableParsersViewController

static float const singleParserHeight = 50;
static float const singleParserBottomMargin = 16;
static float const singleParserLeadingMargin = 16;
static float const singleParserTrailingMargin = 16;
static float const topParserTopMargin = 8;
static float const bottomParserBottomMargin = 8;

+ (instancetype)viewControllerFromStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SelectedParsersStoryboard" bundle:nil];
    PPAvailableParsersViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PPAvailableParsersViewController"];
    return controller;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.scanElements = [PPParsers getAvailableParsers];
    self.scrollContentView.frame = self.scrollView.frame;
    NSLayoutYAxisAnchor *currentBottomAnchor = self.view.bottomAnchor;
    int i = 0;
    UIView *lastSingleView;
    for (UIView *child in [self.scrollContentView subviews]) {
        [child removeConstraints:child.constraints];
        [child removeFromSuperview];
    }
    for (PPScanElement *element in self.scanElements) {
        PPSingleParserViewController *parser = [[PPSingleParserViewController alloc] initWithPPScanElement:element];
        parser.delegate = self;
        parser.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addChildViewController:parser];
        [self.scrollContentView addSubview:parser.view];
        [parser didMoveToParentViewController:self];
        [parser.view.trailingAnchor constraintEqualToAnchor:self.scrollContentView.trailingAnchor constant:-singleParserTrailingMargin].active = true;
        [parser.view.leadingAnchor constraintEqualToAnchor:self.scrollContentView.leadingAnchor constant:singleParserLeadingMargin].active = true;
        if (i == 0) {
            [parser.view.topAnchor constraintEqualToAnchor:self.scrollContentView.topAnchor constant:topParserTopMargin].active = true;
        } else {
            [parser.view.topAnchor constraintEqualToAnchor:currentBottomAnchor constant:singleParserBottomMargin].active = true;
        }
        currentBottomAnchor = parser.view.bottomAnchor;
        [parser.view.heightAnchor constraintEqualToConstant:singleParserHeight];
        i++;
        lastSingleView = parser.view;
    }
    if (self.scrollView.bounds.size.height < i * (singleParserHeight + singleParserBottomMargin) + topParserTopMargin + bottomParserBottomMargin) {
        [lastSingleView.bottomAnchor constraintEqualToAnchor:self.scrollContentView.bottomAnchor constant:-bottomParserBottomMargin].active = true;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

- (void)userDidTapViewController:(PPSingleParserViewController *)viewController {
    [self.delegate userDidSelectScanElement:viewController.element];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
