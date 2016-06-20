//
//  PPSingleParserView.m
//  SegmentScanDemo
//
//  Created by Dino on 03/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

#import "PPSingleParserViewController.h"

@interface PPSingleParserViewController ()

@end

@implementation PPSingleParserViewController

- (instancetype)initWithPPScanElement:(PPScanElement *)element {
    if (self = [[PPSingleParserViewController alloc] initWithNibName:@"PPSingleParserViewController" bundle:nil]) {
        _element = element;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.parser setTitle:self.element.localizedTitle forState:UIControlStateNormal];
}

- (IBAction)buttonParserUserDidTap:(id)sender {
    [self.delegate userDidTapViewController:self];
}

@end
