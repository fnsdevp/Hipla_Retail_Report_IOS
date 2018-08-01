//
//  CartDetails.h
//  Jing
//
//  Created by fnspl3 on 15/11/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartDetails : NSObject

+(CartDetails *)sharedInstanceCartDetails;

@property (nonatomic, strong) NSMutableArray* addToCartItems;

@end
