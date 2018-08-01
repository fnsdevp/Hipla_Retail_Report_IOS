//
//  LoginViewController.h
//  Jing
//
//  Created by fnspl3 on 08/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "NSDictionary+NullReplacement.h"


@interface LoginViewController : ViewController<UITextFieldDelegate>
{
    UINavigationController *localNavigationController;
}
@property (weak, nonatomic) IBOutlet UIView *emailPassView;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)forgetPassBtn:(id)sender;
- (IBAction)signUpBtn:(id)sender;
- (IBAction)loginBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewLogin;
@property (weak, nonatomic) IBOutlet UIView *viewSignUp;

@end
