//
//  ScanForBillViewController.h
//  RetailReport
//
//  Created by fnspl3 on 23/11/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface ScanForBillViewController: ViewController

@property (weak, nonatomic) IBOutlet UIButton *btnScanForBillOutlet;
- (IBAction)btnScanForBill:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnLoyalCustomerOutlet;
- (IBAction)btnLoyalCustomer:(id)sender;

@end
