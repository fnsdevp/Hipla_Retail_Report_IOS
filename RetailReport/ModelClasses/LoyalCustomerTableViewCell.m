//
//  LoyalCustomerTableViewCell.m
//  RetailReport
//
//  Created by fnspl3 on 13/01/18.
//  Copyright © 2018 fnspl3. All rights reserved.
//

#import "LoyalCustomerTableViewCell.h"

@implementation LoyalCustomerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imgView.layer.cornerRadius = _imgView.frame.size.height/2;
    _imgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
