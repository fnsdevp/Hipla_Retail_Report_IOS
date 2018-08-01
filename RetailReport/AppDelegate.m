//
//  AppDelegate.m
//  RetailReport
//
//  Created by fnspl3 on 23/11/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    isLoggedIn = [Userdefaults objectForKey:@"isLoggedIn"];
    
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    [[NSUserDefaults standardUserDefaults] setObject:uniqueIdentifier forKey:@"device_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //-- Set Notification
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    [application setApplicationIconBadgeNumber:0];
    
    [self registerForRemoteNotifications:application];
    
    if([isLoggedIn isEqualToString:@"YES"]){
        
        homeVc = [[ScanForBillViewController alloc]initWithNibName:@"ScanForBillViewController" bundle:nil];
        
        nav = [[UINavigationController alloc]initWithRootViewController:homeVc];
    }
    else
    {
        loginVc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        
        nav = [[UINavigationController alloc]initWithRootViewController:loginVc];
    }
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


// This code block is invoked when application is in foreground (active-mode)
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    //    NSLog(@"didReceiveLocalNotification");
    NSLog(@"Object = %@", notification);
    
    NSDictionary* userInfo = [notification userInfo];
    NSLog(@"UserInfo = %@", userInfo);
    
    isLoggedIn = [Userdefaults objectForKey:@"isLoggedIn"];
    
    if([isLoggedIn isEqualToString:@"YES"]){
    /*
        homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        
        nav = [[UINavigationController alloc]initWithRootViewController:homeVc];
     */
    }
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    NSLog(@"didReceiveLocalNotification");
    
}

-(void)localNotif
{
    if (@available(iOS 10.0, *)) {
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        UNAuthorizationOptions options = UNAuthorizationOptionBadge + UNAuthorizationOptionSound;
        
        [center requestAuthorizationWithOptions:options
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if (!granted) {
                                      NSLog(@"Something went wrong");
                                  }
                              }];
        
    } else {
        // Fallback on earlier versions
    }
}

- (void)registerForRemoteNotifications:(UIApplication *)application
{
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"8.0")){
        
        if (@available(iOS 10.0, *)) {
            
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            
            center.delegate = self;
            
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                    
                });
                
                if(!error){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [[UIApplication sharedApplication] registerForRemoteNotifications];
                        
                    });
                    
                }
                
            }];
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    
}


//Called when a notification is delivered to a foreground app.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    
    NSLog(@"notification body : %@",notification.request.content.body);
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive||[UIApplication sharedApplication].applicationState == UIApplicationStateInactive||[UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        NSDictionary* userInfo = notification.request.content.userInfo;
        
        NSString *strMsg = notification.request.content.body;
        
        NSLog(@"UserInfo = %@", userInfo);
        
        isLoggedIn = [Userdefaults objectForKey:@"isLoggedIn"];
        
        if([isLoggedIn isEqualToString:@"YES"]){
            
            if ([[userInfo allKeys] containsObject:@"aps"]) {
                
                NSString *status = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
                
             /*   if ([status containsString:@""]) {
                    
                    homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                    
                    nav = [[UINavigationController alloc]initWithRootViewController:homeVc];
                    
                }
                else {
                    
                    homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                    
                    nav = [[UINavigationController alloc]initWithRootViewController:homeVc];
                    
                }
              */
                
            }
            
            self.window.rootViewController = nav;
            [self.window makeKeyAndVisible];
            
        }
        
    }
    
    if (@available(iOS 10.0, *)) {
        
        completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
        
    } else {
        
        // Fallback on earlier versions
        
    }
    
}


//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    
    NSLog(@"notification body : %@",response.notification.request.content.body);
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive||[UIApplication sharedApplication].applicationState == UIApplicationStateInactive||[UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        NSDictionary* userInfo = response.notification.request.content.userInfo;
        
        NSString *strMsg = response.notification.request.content.body;
        
        NSLog(@"UserInfo = %@", userInfo);
        
        isLoggedIn = [Userdefaults objectForKey:@"isLoggedIn"];
        
        if([isLoggedIn isEqualToString:@"YES"]){
            
            if ([[userInfo allKeys] containsObject:@"aps"]) {
                
                NSString *status = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
               
                
                if ([status containsString:@"I need some assistants"]) {
                 
                    LoyalCustomerVc = [[LoyalCustomerViewController alloc]initWithNibName:@"LoyalCustomerViewController" bundle:nil];
                 
                    nav = [[UINavigationController alloc]initWithRootViewController:LoyalCustomerVc];
                 
                }
                 /*
                else {
                    
                    homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                    
                    nav = [[UINavigationController alloc]initWithRootViewController:homeVc];
                    
                }
                 */
                
            }
            else
            {
//                loginVc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
//
//                nav = [[UINavigationController alloc]initWithRootViewController:loginVc];
                
            }
            
        }
        else
        {
            loginVc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            
            nav = [[UINavigationController alloc]initWithRootViewController:loginVc];
        
        }
        
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    }
    
    if (@available(iOS 10.0, *)) {
        
        completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
        
    } else {
        
        // Fallback on earlier versions
        
    }
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings // NS_AVAILABLE_IOS(8_0);
{
    [application registerForRemoteNotifications];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    // NSLog(@"deviceToken: %@", deviceToken);
    
    NSString * token = [NSString stringWithFormat:@"%@", deviceToken];
    //Format token as you need:
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    
    NSLog(@"token: %@", token);
    
    // [self sendEmailwithBody:token];
    
    [Utils setDeviceToken:token];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
    
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@",userInfo);
    
    application.applicationIconBadgeNumber = 0;
    
    if (application.applicationState == UIApplicationStateActive)
    {
        
    }
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"RetailReport"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
