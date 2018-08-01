//
//  LoyalCustomerDetailsTableViewCell.h
//  RetailReport
//
//  Created by fnspl3 on 15/01/18.
//  Copyright © 2018 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoyalCustomerDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImgView;
@property (weak, nonatomic) IBOutlet UILabel *productTitle;
@property (weak, nonatomic) IBOutlet UILabel *ProductPrice;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end
