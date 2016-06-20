//
//  SelectedParsersViewController.m
//  SegmentScanDemo
//
//  Created by Dino on 03/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

#import "PPScanElement.h"
#import "PPSelectedParsersViewController.h"
#import "PPSettingsManager.h"

@interface PPSelectedParsersViewController ()

@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(weak, nonatomic) IBOutlet UIView *scrollContentView;

@end

@implementation PPSelectedParsersViewController

static float const singleParserHeight = 50;
static float const singleParserBottomMargin = 16;
static float const singleParserLeadingMargin = 16;
static float const singleParserTrailingMargin = 16;
static float const topParserTopMargin = 8;
static float const bottomParserBottomMargin = 8;

+ (instancetype)viewControllerFromStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SelectedParsersStoryboard" bundle:nil];
    PPSelectedParsersViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PPSelectedParsersViewController"];
    return controller;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLayoutYAxisAnchor *currentBottomAnchor = self.view.bottomAnchor;
    int i = 0;
    UIView *lastSingleView;
    self.scrollContentView.frame = self.scrollContentView.frame;
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
    PPParserDetailViewController *detailViewController = [PPParserDetailViewController viewControllerFromStoryboard];
    detailViewController.element = viewController.element;
    detailViewController.delegate = self;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)parserDetailController:(PPParserDetailViewController *)parserDetailController didFinishEditingElement:(PPScanElement *)element {
    [PPSettingsManager saveScanElements:self.scanElements];
}

- (void)parserDetailController:(PPParserDetailViewController *)parserDetailController didDeleteElement:(PPScanElement *)element {
    [self.scanElements removeObject:element];
    [PPSettingsManager saveScanElements:self.scanElements];
}

- (void)userDidSelectScanElement:(PPScanElement *)element {
    [self.scanElements addObject:element];
    [PPSettingsManager saveScanElements:self.scanElements];
}
- (IBAction)buttonAddParserUserDidTap:(id)sender {
    PPAvailableParsersViewController *viewController = [PPAvailableParsersViewController viewControllerFromStoryboard];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
