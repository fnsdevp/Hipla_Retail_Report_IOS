//
//  AppDelegate.h
//  RetailReport
//
//  Created by fnspl3 on 23/11/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ScanForBillViewController.h"
#import "LoginViewController.h"
#import "LoyalCustomerViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>
{
    NSString *isLoggedIn;
    UINavigationController *nav;
    LoginViewController *loginVc;
    ScanForBillViewController *homeVc;
    LoyalCustomerViewController *LoyalCustomerVc;
}
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

