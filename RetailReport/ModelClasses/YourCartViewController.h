//
//  YourCartViewController.h
//  Jing
//
//  Created by fnspl3 on 11/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YourCartViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
     APIManager *api;
}
@property (weak, nonatomic) IBOutlet UIView *continueView;
@property (weak, nonatomic) IBOutlet UIView *checkoutview;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtotal;
@property (weak, nonatomic) IBOutlet UILabel *lblItems;
@property (weak, nonatomic) IBOutlet UITableView *tableViewYourCart;
@property NSDictionary *productInfoDict;

@property NSMutableArray *ProductInfoDetails;

@property (strong, nonatomic) NSMutableArray *ProductInfo;
@property NSString *totalAmountStr;
@property NSString *totalQuantityStr;
@property (weak, nonatomic) IBOutlet UIButton *checkoutBtnOutlet;

- (IBAction)crossBtn:(id)sender;
- (IBAction)continueBtn:(id)sender;
- (IBAction)checkoutBtn:(id)sender;

@end
