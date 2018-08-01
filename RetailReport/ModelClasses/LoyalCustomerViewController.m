//
//  LoyalCustomerViewController.m
//  RetailReport
//
//  Created by fnspl3 on 13/01/18.
//  Copyright © 2018 fnspl3. All rights reserved.
//

#import "LoyalCustomerViewController.h"
#import "LoyalCustomerTableViewCell.h"
#import "LoyalCustomerDetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "IndoorMapViewController.h"

@interface LoyalCustomerViewController (){
    
    NSMutableArray *allInterestedlistInfo;
    NSDictionary *allInterestedDict;
    NSString *userIdStr;
    NSString *nameStr;
    NSString *phoneStr;
    NSString *usertypeStr;
    NSString *zoneId;
    NSString *imageURL;
    
    
}

@end

@implementation LoyalCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    api = [APIManager sharedManager];
    [self getAllInterestedUser];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [allInterestedlistInfo count];
//    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"LoyalCustomerTableViewCell";
    
    LoyalCustomerTableViewCell *cell = (LoyalCustomerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LoyalCustomerTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //    NSDictionary *dict = [[_productInfoDict objectForKey:@"productlist"] objectAtIndex:indexPath.row];
    //    cell.lblName.text = [dict objectForKey:@"title"];
    
    if ([allInterestedlistInfo count]>0) {
        
        NSDictionary *dict = [allInterestedlistInfo objectAtIndex:indexPath.row];
        
        cell.lblName.text=[NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"fname"],[dict objectForKey:@"lname"]];
        cell.lblPhoneNumber.text=[NSString stringWithFormat:@"Phone No : %@",[dict objectForKey:@"phone"]];
        cell.lblCustomerType.text=[NSString stringWithFormat:@"Customer Type : %@",[dict objectForKey:@"usertype"]];
//        cell.imgView.image = [UIImage imageNamed:@"bigNoimage.png"];
        cell.btnNavOutlet.tag=indexPath.row;
        
        [cell.btnNavOutlet addTarget:self action:@selector(btnNavigate:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.imgView.image = nil;
         [cell.indicatorView startAnimating];
        NSString *imgURL= [NSString stringWithFormat:@"http://cxc.gohipla.com/retail/%@",[dict objectForKey:@"image"]];
//        [cell.indicatorView startAnimating];
        imgURL = [imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:imgURL]
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 
                                 // progression tracking code
                                 NSLog(@"receivedSize %ld",(long)receivedSize);
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                
                                if (image) {
                                    // do something with image
                                    cell.imgView.image = image;
                                    
                                     [cell.indicatorView setHidden:YES];
                                     [cell.indicatorView stopAnimating];
                                    
                                    
                                }
                            }];
        
        [cell.imgView setContentMode:UIViewContentModeScaleAspectFit];

    }
   else {
    cell.lblName.text=@"";
    cell.lblPhoneNumber.text=@"";
    cell.lblCustomerType.text=@"";
    cell.imgView.image = nil;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 98;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSDictionary *dict = [orderhistoryDetailslistInfo objectAtIndex:indexPath.row];
//    orderhistoryIdStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
//    orderUniqueIdStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_unique_id"]];
//
//    NSLog(@"orderhistoryIdStr=== %@",orderhistoryIdStr);
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        [self gotoHome];
//
//        //                            ProductDetailsViewController *productbyDetailsScreen = [[ProductDetailsViewController alloc]initWithNibName:@"ProductDetailsViewController" bundle:nil];
//        //                            productbyDetailsScreen.productbyDetailslistInfo = productbyDetailslistInfo;
//        //                            [self.navigationController pushViewController:productbyDetailsScreen animated:YES];
//
//    });
    
    
        NSDictionary *dict = [allInterestedlistInfo objectAtIndex:indexPath.row];
        userIdStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    
       nameStr = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"fname"],[dict objectForKey:@"lname"]];
       phoneStr = [NSString stringWithFormat:@"Phone No : %@",[dict objectForKey:@"phone"]];
       usertypeStr = [NSString stringWithFormat:@"Customer Type : %@",[dict objectForKey:@"usertype"]];
       imageURL= [NSString stringWithFormat:@"http://cxc.gohipla.com/retail/%@",[dict objectForKey:@"image"]];
    
       LoyalCustomerDetailsViewController *loyalCustomerDetailsViewControllerViewScreen = [[LoyalCustomerDetailsViewController alloc]initWithNibName:@"LoyalCustomerDetailsViewController" bundle:nil];
    
    loyalCustomerDetailsViewControllerViewScreen.userIdStr=userIdStr;
    
    loyalCustomerDetailsViewControllerViewScreen.nameStr=nameStr;
    loyalCustomerDetailsViewControllerViewScreen.phoneStr=phoneStr;
    loyalCustomerDetailsViewControllerViewScreen.usertypeStr=usertypeStr;
    loyalCustomerDetailsViewControllerViewScreen.imageURL=imageURL;
    
    [self.navigationController pushViewController:loyalCustomerDetailsViewControllerViewScreen animated:YES];
    
}
- (void)btnNavigate:(UIButton *)sender{
    
    NSDictionary *dict = [allInterestedlistInfo objectAtIndex:(int)sender.tag];
    
    zoneId=[NSString stringWithFormat:@"%@",[dict objectForKey:@"zone_code"]];
    IndoorMapViewController *indoorMapScreen = [[IndoorMapViewController alloc]initWithNibName:@"IndoorMapViewController" bundle:nil];
    
    indoorMapScreen.zoneId=zoneId;
    [self.navigationController pushViewController:indoorMapScreen animated:YES];
    
}
-(void)getAllInterestedUser
{
//    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@""];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"all_interested_user.php" completion:^(NSDictionary * dict, NSError *error) {
        
//        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                allInterestedlistInfo = [dict objectForKey:@"interestlist"];
                
                if ([[Utils sharedInstance] isNullString:(NSString *)allInterestedlistInfo])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with order history, try again later."
                                                                            message:nil
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"Ok"
                                                                  otherButtonTitles:nil];
                        [alertView show];
                        
                    });
                }
                else{
                    
                    allInterestedDict = (NSDictionary *)[allInterestedlistInfo objectAtIndex:0];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.tableViewAllinterested reloadData];
                        
                    });
                    
                }
                
            } else {
                
//                [SVProgressHUD dismiss];
                
                NSLog(@"Error: %@", error);
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with order history, try again later."
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
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

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
