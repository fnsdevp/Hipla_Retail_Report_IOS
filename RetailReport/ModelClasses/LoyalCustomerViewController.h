//
//  LoyalCustomerViewController.h
//  RetailReport
//
//  Created by fnspl3 on 13/01/18.
//  Copyright © 2018 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"

@interface LoyalCustomerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    APIManager *api;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewAllinterested;
- (IBAction)btnBack:(id)sender;

@end
