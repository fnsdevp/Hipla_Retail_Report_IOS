//
//  ScanForBillViewController.m
//  RetailReport
//
//  Created by fnspl3 on 23/11/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "ScanForBillViewController.h"
#import "ScanBarcodeViewController.h"
#import "LoyalCustomerViewController.h"

@interface ScanForBillViewController (){
    
    NSDictionary *ProfInfo;
    NSString *sales_id;
}

@end

@implementation ScanForBillViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     api = [APIManager sharedManager];
    
    // Do any additional setup after loading the view from its nib.
    _btnScanForBillOutlet.layer.cornerRadius = 25.0f;
    _btnScanForBillOutlet.clipsToBounds = YES;
    _btnLoyalCustomerOutlet.layer.cornerRadius = 25.0f;
    _btnLoyalCustomerOutlet.clipsToBounds = YES;
    
    [self.navigationController.navigationBar setHidden:YES];
    
    ProfInfo = [Userdefaults objectForKey:@"ProfInfo"];
    sales_id = [NSString stringWithFormat:@"%@",[ProfInfo objectForKey:@"id"]];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
     [self UpdateToken];
    
}
-(void)UpdateToken
{
    //    [SVProgressHUD show];
    
    
//    NSDictionary *dict = [productCategory objectAtIndex:0];
//    sales_id=[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    
    NSString *deviceToken = [Utils deviceToken];
    
    NSString *userUpdate = [NSString stringWithFormat:@"sales_id=%@&regkey=%@&device_type=ios",[NSString stringWithFormat:@"%@",sales_id],deviceToken];
    
    NSLog(@"%@",userUpdate);
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"sales_token_update.php" completion:^(NSDictionary * dict, NSError *error) {
        //        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"])
            {
                
            }
            
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)btnScanForBill:(id)sender {
    
    ScanBarcodeViewController *scanBarcodeViewControllerViewScreen = [[ScanBarcodeViewController alloc]initWithNibName:@"ScanBarcodeViewController" bundle:nil];
    
    [self.navigationController pushViewController:scanBarcodeViewControllerViewScreen animated:YES];
}

- (IBAction)btnLoyalCustomer:(id)sender {
    
    LoyalCustomerViewController *loyalCustomerViewControllerViewScreen = [[LoyalCustomerViewController alloc]initWithNibName:@"LoyalCustomerViewController" bundle:nil];
    
    [self.navigationController pushViewController:loyalCustomerViewControllerViewScreen animated:YES];
    
}
@end
