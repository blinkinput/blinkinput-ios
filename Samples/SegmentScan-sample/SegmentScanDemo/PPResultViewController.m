//
//  PPResultViewController.m
//  BlinkIDScan
//
//  Created by Dino on 26/01/16.
//  Copyright © 2016 Dino. All rights reserved.
//

#import "PPResultViewController.h"

@interface PPResultViewController ()

@property(nonatomic) UILabel *labelTitle;

@property(nonatomic) UILabel *labelSubTitle;

@property(nonatomic) NSMutableDictionary *allLabels;

@property(nonatomic) UIButton *rightButton;

/* Constraints for each key-value label combination */

// Constraints when labels are bottom aligned - when key-value distance is greater than minimumLabelDistance
@property(nonatomic) NSMutableArray<NSLayoutConstraint *> *labelValueAligned;

// Constraints when labels are seperated by labelTopMargin - when key-value distance is less than minimumLabelDistance
@property(nonatomic) NSMutableArray<NSLayoutConstraint *> *labelValueDropped;

// Constraints for maximum width of labelValue - when key-value distance is less than minimumLabelDistance
@property(nonatomic) NSMutableArray<NSLayoutConstraint *> *labelValueDroppedWidth;

// Main Scroll View containting key-value labels
@property(nonatomic) UIScrollView *scrollView;

@end

@implementation PPResultViewController

/* Graphical attributes */

// Thickness of graphical lines
static float lineHeight = 0.5f;

// Vertical distance between labels
static float labelTopMargin = 10.0f;

// Horizontal distance between labels and scrollView - leading
static float labelLeadingMargin = 14.0f;

// Horizontal distance between labels and scrollView - trailing
static float labelTrailingMargin = -14.0f;

// Alpha property of the view and it's top and bottom foregrounds
static float viewAlpha = 0.95f;

// Border radius of the view
static float viewBorderRadius = 15.0f;

// Border thickness of the view
static float viewBorderWidth = 1.0f;

// Height of the top foreground, the one containing title
static float topForegroundHeight = 50.0f;

// Height of the bottom foreground, the one containing buttons
static float bottomForegroundHeight = 55.0f;

// Maximum allowed width of labelKey
static float labelMaxWidth = 0.6f;

// Maximum allowed width of labelValue when it's dropped
static float labelValueLongMaxWidth = 0.8f;

// Minimum distance between labelKey and labelValue. If distance becomes less, labelValue becomes dropped
static float minimumLabelDistance = 24.0f;

// Margin between fullName and first labelKey
static float labelFullNameBottomMargin = 24.0f;

// Margin between fullName and top foregrounds
static float labelFullNameTopMargin = 24.0f;

// Horizontal Margin between buttons and self.view
static float buttonHorizontalMargin = 18.0f;

- (instancetype)initWithTitle:(NSString *)title labels:(NSDictionary *)labels subTitle:(NSString *)subTitle labelOrder:(NSArray *)orderList {

    self = [super init];
    if (self) {
        _subTitle = subTitle;
        _titleText = title;
        _labelMap = labels;
        _keyOrderList = orderList;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.labelValueAligned = [NSMutableArray array];
    self.labelValueDropped = [NSMutableArray array];
    self.labelValueDroppedWidth = [NSMutableArray array];

    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];

    UIColor *lighterGrey = [UIColor colorWithRed:237.0f / 255.0f green:237.0f / 255.0f blue:237.0f / 255.0f alpha:1.0f];
    UIColor *buttonTextColor = [UIColor colorWithRed:187.0f / 255.0f green:0.0f blue:47.0f / 255.0f alpha:1.0f];
    UIColor *titleFontColor = [UIColor colorWithRed:133.0f / 255.0f green:139.0f / 255.0f blue:149.0f / 255.0f alpha:1.0f];

    UIFont *titleFont = [UIFont systemFontOfSize:23.0f weight:UIFontWeightLight];
    UIFont *fullNameFont = [UIFont systemFontOfSize:22.0f weight:UIFontWeightBold];
    UIFont *buttonFont = [UIFont systemFontOfSize:22.0f weight:UIFontWeightLight];
    UIFont *labelValueFont = [UIFont systemFontOfSize:16.0f weight:UIFontWeightBold];
    UIFont *labelKeyFont = [UIFont systemFontOfSize:16.0f];

    UIEdgeInsets buttonInsets = UIEdgeInsetsMake(15.0, 15.0, 15.0, 15.0);

    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.view.backgroundColor = [UIColor whiteColor];
    self.view.alpha = viewAlpha;
    [self.view.layer setCornerRadius:viewBorderRadius];
    [self.view.layer setBorderWidth:viewBorderWidth];
    [self.view.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    self.view.layer.masksToBounds = YES;

    UIView *titleBackground = [[UIView alloc] init];
    [titleBackground setTranslatesAutoresizingMaskIntoConstraints:NO];
    titleBackground.backgroundColor = lighterGrey;
    titleBackground.alpha = viewAlpha;
    [self.view addSubview:titleBackground];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleBackground
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleBackground
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleBackground
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0]];
    [titleBackground addConstraint:[NSLayoutConstraint constraintWithItem:titleBackground
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:topForegroundHeight]];

    self.labelTitle = [[UILabel alloc] init];
    [self.labelTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.labelTitle.font = titleFont;
    self.labelTitle.textColor = titleFontColor;
    self.labelTitle.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.labelTitle];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.labelTitle
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:titleBackground
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.labelTitle
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:titleBackground
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];

    self.labelTitle.text = self.titleText;

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    scrollView.contentInset = UIEdgeInsetsMake(topForegroundHeight, 0.0f, bottomForegroundHeight, 0.0f);
    scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(topForegroundHeight, 0.0f, bottomForegroundHeight, 0.0f);
    [self.view insertSubview:scrollView atIndex:0];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0.0]];

    UIView *widthView = [[UIView alloc] init];
    [widthView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView addSubview:widthView];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:widthView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0.0]];
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:widthView
                                                           attribute:NSLayoutAttributeLeading
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:scrollView
                                                           attribute:NSLayoutAttributeLeading
                                                          multiplier:1.0
                                                            constant:0.0]];
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:widthView
                                                           attribute:NSLayoutAttributeTrailing
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:scrollView
                                                           attribute:NSLayoutAttributeTrailing
                                                          multiplier:1.0
                                                            constant:0.0]];
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:widthView
                                                           attribute:NSLayoutAttributeBottom
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:scrollView
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.0
                                                            constant:0.0]];

    UIView *lastElement = nil;

    if (self.subTitle != nil && ![self.subTitle isEqualToString:@""]) {

        self.labelSubTitle = [[UILabel alloc] init];
        [self.labelSubTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.labelSubTitle.text = self.subTitle;
        self.labelSubTitle.font = fullNameFont;
        self.labelSubTitle.textAlignment = NSTextAlignmentLeft;
        self.labelSubTitle.numberOfLines = 0;
        [scrollView addSubview:self.labelSubTitle];

        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.labelSubTitle
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:scrollView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0
                                                                constant:labelFullNameTopMargin]];
        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.labelSubTitle
                                                               attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:scrollView
                                                               attribute:NSLayoutAttributeLeading
                                                              multiplier:1.0
                                                                constant:labelLeadingMargin]];
        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.labelSubTitle
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:scrollView
                                                               attribute:NSLayoutAttributeWidth
                                                              multiplier:1.0
                                                                constant:-labelLeadingMargin * 2]];

    } else {
        self.labelSubTitle = [[UILabel alloc] init];
        [self.labelSubTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.labelSubTitle.text = self.subTitle;
        self.labelSubTitle.font = fullNameFont;
        self.labelSubTitle.textAlignment = NSTextAlignmentLeft;
        self.labelSubTitle.numberOfLines = 0;
        [scrollView addSubview:self.labelSubTitle];

        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.labelSubTitle
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:scrollView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0
                                                                constant:0]];
        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.labelSubTitle
                                                               attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:scrollView
                                                               attribute:NSLayoutAttributeLeading
                                                              multiplier:1.0
                                                                constant:labelLeadingMargin]];
        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.labelSubTitle
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:scrollView
                                                               attribute:NSLayoutAttributeWidth
                                                              multiplier:1.0
                                                                constant:-labelLeadingMargin * 2]];
    }

    lastElement = self.labelSubTitle;

    NSArray *keyArray;

    if (self.keyOrderList == nil) {
        keyArray = [self.labelMap allKeys];
    } else {
        keyArray = self.keyOrderList;
    }

    int i = 0;
    for (NSString *key in keyArray) {
        NSString *value = [self.labelMap objectForKey:key];

        UILabel *labelKey = [[UILabel alloc] init];
        [labelKey setTranslatesAutoresizingMaskIntoConstraints:NO];
        labelKey.text = key;
        labelKey.font = labelKeyFont;
        labelKey.textAlignment = NSTextAlignmentLeft;
        labelKey.numberOfLines = 0;
        labelKey.textColor = [UIColor lightGrayColor];
        [scrollView addSubview:labelKey];

        UILabel *labelValue = [[UILabel alloc] init];
        [labelValue setTranslatesAutoresizingMaskIntoConstraints:NO];
        labelValue.font = labelValueFont;
        labelValue.text = value;
        labelValue.textAlignment = NSTextAlignmentRight;
        labelValue.numberOfLines = 0;
        [scrollView addSubview:labelValue];

        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:labelKey
                                                               attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:scrollView
                                                               attribute:NSLayoutAttributeLeading
                                                              multiplier:1.0
                                                                constant:labelLeadingMargin]];
        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:labelValue
                                                               attribute:NSLayoutAttributeTrailing
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:scrollView
                                                               attribute:NSLayoutAttributeTrailing
                                                              multiplier:1.0
                                                                constant:labelTrailingMargin]];
        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:labelKey
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationLessThanOrEqual
                                                                  toItem:scrollView
                                                               attribute:NSLayoutAttributeWidth
                                                              multiplier:labelMaxWidth
                                                                constant:0.0]];

        NSLayoutConstraint *bottomAlign = [NSLayoutConstraint constraintWithItem:labelValue
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:labelKey
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:0.0];
        [scrollView addConstraint:bottomAlign];
        [self.labelValueAligned addObject:bottomAlign];

        [self.labelValueDropped addObject:[NSLayoutConstraint constraintWithItem:labelValue
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:labelKey
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:labelTopMargin]];

        [self.labelValueDroppedWidth addObject:[NSLayoutConstraint constraintWithItem:labelValue
                                                                            attribute:NSLayoutAttributeWidth
                                                                            relatedBy:NSLayoutRelationLessThanOrEqual
                                                                               toItem:scrollView
                                                                            attribute:NSLayoutAttributeWidth
                                                                           multiplier:labelValueLongMaxWidth
                                                                             constant:0.0]];

        float verticalMargin = labelTopMargin;
        if (i == 0) {
            verticalMargin = labelFullNameBottomMargin;
        }

        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:labelKey
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:lastElement
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0
                                                                constant:verticalMargin]];

        UIView *line = [[UIView alloc] init];
        [line setTranslatesAutoresizingMaskIntoConstraints:NO];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.6f;
        [scrollView addSubview:line];

        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                               attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:labelKey
                                                               attribute:NSLayoutAttributeLeading
                                                              multiplier:1.0
                                                                constant:0.0]];
        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                               attribute:NSLayoutAttributeTrailing
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:labelValue
                                                               attribute:NSLayoutAttributeTrailing
                                                              multiplier:1.0
                                                                constant:0.0]];
        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:labelValue
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0
                                                                constant:labelTopMargin]];
        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:lineHeight]];

        lastElement = line;

        i++;
    }

    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:lastElement
                                                           attribute:NSLayoutAttributeBottom
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:scrollView
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.0
                                                            constant:0.0]];

    UIView *bottomView = [[UIView alloc] init];
    [bottomView setTranslatesAutoresizingMaskIntoConstraints:NO];
    bottomView.backgroundColor = lighterGrey;
    bottomView.alpha = viewAlpha;
    [self.view addSubview:bottomView];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bottomView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bottomView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bottomView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bottomView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:bottomForegroundHeight]];

    UIView *bottomViewBorder = [[UIView alloc] init];
    [bottomViewBorder setTranslatesAutoresizingMaskIntoConstraints:NO];
    bottomViewBorder.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:bottomViewBorder];

    [bottomView addConstraint:[NSLayoutConstraint constraintWithItem:bottomViewBorder
                                                           attribute:NSLayoutAttributeBottom
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:bottomView
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0
                                                            constant:0.0]];
    [bottomView addConstraint:[NSLayoutConstraint constraintWithItem:bottomViewBorder
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:bottomView
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.0
                                                            constant:0.0]];
    [bottomView addConstraint:[NSLayoutConstraint constraintWithItem:bottomViewBorder
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:bottomView
                                                           attribute:NSLayoutAttributeWidth
                                                          multiplier:1.0
                                                            constant:0.0]];
    [bottomView addConstraint:[NSLayoutConstraint constraintWithItem:bottomViewBorder
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1.0
                                                            constant:lineHeight]];

    UIView *titleBackgroundBorder = [[UIView alloc] init];
    [titleBackgroundBorder setTranslatesAutoresizingMaskIntoConstraints:NO];
    titleBackgroundBorder.backgroundColor = [UIColor lightGrayColor];
    [titleBackground addSubview:titleBackgroundBorder];

    [titleBackground addConstraint:[NSLayoutConstraint constraintWithItem:titleBackgroundBorder
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:titleBackground
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:0.0]];
    [titleBackground addConstraint:[NSLayoutConstraint constraintWithItem:titleBackgroundBorder
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:titleBackground
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1.0
                                                                 constant:0.0]];
    [titleBackground addConstraint:[NSLayoutConstraint constraintWithItem:titleBackgroundBorder
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:titleBackground
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1.0
                                                                 constant:0.0]];
    [titleBackground addConstraint:[NSLayoutConstraint constraintWithItem:titleBackgroundBorder
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:lineHeight]];

    UIButton *buttonClose = [[UIButton alloc] init];
    [buttonClose setTranslatesAutoresizingMaskIntoConstraints:NO];
    [buttonClose setTitle:@"Close" forState:UIControlStateNormal];
    [buttonClose setTitleColor:buttonTextColor forState:UIControlStateNormal];
    [buttonClose setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    buttonClose.titleLabel.font = buttonFont;
    buttonClose.contentEdgeInsets = buttonInsets;
    [self.view addSubview:buttonClose];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:buttonClose
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:bottomView
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:buttonClose
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:buttonHorizontalMargin]];
    [buttonClose addTarget:self action:@selector(buttonCloseDidTap:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *buttonCopy = [[UIButton alloc] init];
    [buttonCopy setTranslatesAutoresizingMaskIntoConstraints:NO];
    [buttonCopy setTitle:@"Copy" forState:UIControlStateNormal];
    [buttonCopy setTitleColor:buttonTextColor forState:UIControlStateNormal];
    [buttonCopy setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    buttonCopy.titleLabel.font = buttonFont;
    buttonCopy.contentEdgeInsets = buttonInsets;
    [self.view addSubview:buttonCopy];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:buttonCopy
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:bottomView
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:buttonCopy
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:-buttonHorizontalMargin]];
    [buttonCopy addTarget:self action:@selector(buttonCopyDidTap:) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton = buttonCopy;

    [scrollView setContentOffset:CGPointMake(0, -topForegroundHeight) animated:NO];
    self.scrollView = scrollView;
}

- (void)buttonCloseDidTap:(UIButton *)sender {
    [self.delegate buttonCloseDidTap:self];
}

- (void)buttonCopyDidTap:(UIButton *)sender {
    [self.delegate buttonRightDidTap:self];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    // For each labelValue, check if it needs to be dropped
    for (int i = 0; i < self.labelValueAligned.count; i++) {
        UILabel *labelValue = [self.labelValueAligned objectAtIndex:i].firstItem;
        UILabel *labelKey = [self.labelValueAligned objectAtIndex:i].secondItem;

        CGSize sizeKey = [labelKey.text sizeWithAttributes:@{NSFontAttributeName : labelKey.font}];
        CGSize sizeValue = [labelValue.text sizeWithAttributes:@{NSFontAttributeName : labelValue.font}];

        if ((sizeKey.width + sizeValue.width + labelLeadingMargin + labelTrailingMargin + minimumLabelDistance) > self.view.bounds.size.width ||
            [labelValue.text containsString:@"\n"]) {
            [self.scrollView removeConstraint:[self.labelValueAligned objectAtIndex:i]];
            [self.scrollView addConstraint:[self.labelValueDropped objectAtIndex:i]];
            [self.scrollView addConstraint:[self.labelValueDroppedWidth objectAtIndex:i]];
        } else if ([self.scrollView.constraints containsObject:[self.labelValueDropped objectAtIndex:i]]) {
            [self.scrollView removeConstraint:[self.labelValueDropped objectAtIndex:i]];
            [self.scrollView removeConstraint:[self.labelValueDroppedWidth objectAtIndex:i]];
            [self.scrollView addConstraint:[self.labelValueAligned objectAtIndex:i]];
        }
    }
    [self.view layoutIfNeeded];
}

- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    self.labelTitle.text = titleText;
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    self.labelSubTitle.text = subTitle;
}

- (void)setRightButtonTitle:(NSString *)rightButtonTitle {
    _rightButtonTitle = rightButtonTitle;
    self.rightButton.titleLabel.text = rightButtonTitle;
}

@end
