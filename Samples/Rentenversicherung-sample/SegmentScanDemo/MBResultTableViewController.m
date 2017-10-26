//
//  MBResultTableViewController.m
//  RentenversicherungDemo
//
//  Created by Jura Skrlec on 16/10/2017.
//  Copyright © 2017 Dino. All rights reserved.
//

#import "MBResultTableViewController.h"
#import "PPScanElement.h"

@interface MBResultTableViewController ()

@property (nonatomic, strong) PPScanElement *versicherungsNummerScanElement;
@property (nonatomic, strong) PPScanElement *datumScanElement;
@property (nonatomic, strong) PPScanElement *renteScanElement;


@end

@implementation MBResultTableViewController

+ (instancetype)viewControllerFromStoryBoard {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MBResultTableViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Results";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(dismissVC)];
    
    for (PPScanElement *scanElement in self.scanElements) {
        if ([scanElement.identifier isEqualToString:kVersicherungsnummer]) {
            self.versicherungsNummerScanElement = scanElement;
        }
        else if ([scanElement.identifier isEqualToString:kDatum]) {
            self.datumScanElement = scanElement;
        }
        else if ([scanElement.identifier isEqualToString:kRente]) {
            self.renteScanElement = scanElement;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Versicherungsnummer";
            break;
        case 1:
            return @"Datum";
            break;
        case 2:
            return @"Rente wegen voller Erwebsminderung";
            break;
        case 3:
            return @"Höhe Ihrer künftigen Regelaltersrente";
            break;
        default:
            return nil;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultTableCell"];
 
    cell.detailTextLabel.text = @"";
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = self.versicherungsNummerScanElement.value;
            break;
        case 1:
            cell.textLabel.text = self.datumScanElement.value;
            
            break;
        case 2:
            cell.textLabel.text = self.renteScanElement.multipleValues ? self.renteScanElement.multipleValues[0] : @"";
            cell.detailTextLabel.text = @"EUR";
            break;
         case 3:
            if (indexPath.row == 0) {
                cell.textLabel.text = self.renteScanElement.multipleValues ? self.renteScanElement.multipleValues[1] : @"";
                cell.detailTextLabel.text = @"EUR";
            }
            else if (indexPath.row == 1) {
                cell.textLabel.text = self.renteScanElement.multipleValues ? self.renteScanElement.multipleValues[2] : @"";
                cell.detailTextLabel.text = @"EUR";
            }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)dismissVC {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
