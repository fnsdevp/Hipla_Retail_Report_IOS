//
//  CartDetails.m
//  Jing
//
//  Created by fnspl3 on 15/11/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "CartDetails.h"

static CartDetails *sharedInstanceCartDetails;

@implementation CartDetails

+(CartDetails *)sharedInstanceCartDetails
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstanceCartDetails=[[CartDetails alloc] init];
    });
    
    return sharedInstanceCartDetails;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
