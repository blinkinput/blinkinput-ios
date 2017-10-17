//
//  MBResultTableViewController.h
//  RentenversicherungDemo
//
//  Created by Jura Skrlec on 16/10/2017.
//  Copyright © 2017 Dino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBResultTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *scanElements;

+(instancetype)viewControllerFromStoryBoard;

@end
