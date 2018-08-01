//
//  LoyalCustomerDetailsViewController.h
//  RetailReport
//
//  Created by fnspl3 on 15/01/18.
//  Copyright © 2018 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoyalCustomerDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    APIManager *api;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewProductShow;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblCusType;

@property NSString *userIdStr;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property NSString *nameStr;
@property NSString *phoneStr;
@property NSString *usertypeStr;
@property NSString *imageURL;
- (IBAction)btnBack:(id)sender;

@end
