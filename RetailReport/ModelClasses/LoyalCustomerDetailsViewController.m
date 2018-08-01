//
//  LoyalCustomerDetailsViewController.m
//  RetailReport
//
//  Created by fnspl3 on 15/01/18.
//  Copyright © 2018 fnspl3. All rights reserved.
//

#import "LoyalCustomerDetailsViewController.h"
#import "LoyalCustomerDetailsTableViewCell.h"
#import "UIImageView+WebCache.h"


@interface LoyalCustomerDetailsViewController (){
    
    NSMutableArray *productShowlistInfo;
    NSDictionary *productShowDict;
    
}

@end

@implementation LoyalCustomerDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     api = [APIManager sharedManager];
    [self productbycatbyuserpreference];
    
    _imgView.layer.cornerRadius = _imgView.frame.size.height/2;
    _imgView.layer.masksToBounds = YES;
    _lblName.text=[NSString stringWithFormat:@"%@",_nameStr];
    _lblPhone.text=[NSString stringWithFormat:@"%@",_phoneStr];
    _lblCusType.text=[NSString stringWithFormat:@"%@",_usertypeStr];
    
    [self.indicatorView startAnimating];
    NSString *imgURL= _imageURL;
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
                                self.imgView.image = image;
                                
                                [self.indicatorView setHidden:YES];
                                [self.indicatorView stopAnimating];
                                
                                
                            }
                        }];
    
    [self.imgView setContentMode:UIViewContentModeScaleAspectFit];
    
    
    
    // Do any additional setup after loading the view from its nib.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   return [productShowlistInfo count];
//    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"LoyalCustomerDetailsTableViewCell";
    
    LoyalCustomerDetailsTableViewCell *cell = (LoyalCustomerDetailsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LoyalCustomerDetailsTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //    NSDictionary *dict = [[_productInfoDict objectForKey:@"productlist"] objectAtIndex:indexPath.row];
    //    cell.lblName.text = [dict objectForKey:@"title"];
    
    if ([productShowlistInfo count]>0) {
        
        NSDictionary *dict = [productShowlistInfo objectAtIndex:indexPath.row];
        
        cell.productTitle.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
        cell.ProductPrice.text=[NSString stringWithFormat:@"Rs/-%@ ",[dict objectForKey:@"price"]];
        
//        cell.productImgView.image = [UIImage imageNamed:@"bigNoimage.png"];
        
//        cell.productImgView.image = nil;
        
        cell.productImgView.image = nil;
        
        NSString *imgURL= [NSString stringWithFormat:@"http://cxc.gohipla.com/retail/admin/resources/image/product/%@/%@",[dict objectForKey:@"product_image_folder"],[dict objectForKey:@"product_image"]];
         [cell.indicatorView startAnimating];
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
                                    cell.productImgView.image = image;
                                    
                                    [cell.indicatorView setHidden:YES];
                                    [cell.indicatorView stopAnimating];
                                    
                                    
                                }
                            }];
        
        [cell.productImgView setContentMode:UIViewContentModeScaleAspectFit];
        
    }
      else  {
          
        cell.productTitle.text=@"";
        cell.ProductPrice.text=@"";
        cell.productImgView.image = nil;
        
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
    
}

//-(void)getinterestedproductbyuser
//{
//    //    [SVProgressHUD show];
//
//    NSString *userUpdate = [NSString stringWithFormat:@"user_id=%@",_userIdStr];
//
//    //Convert the String to Data
//    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
//
//    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"interestedproductbyuser.php" completion:^(NSDictionary * dict, NSError *error) {
//
//        //        [SVProgressHUD dismiss];
//
//        NSLog(@"%@",dict);
//
//        NSLog(@"%@",error);
//
//        if (!error) {
//
//            NSString *successStr = [dict objectForKey:@"status"];
//
//            if ([successStr isEqualToString:@"success"]) {
//                //                dispatch_async(dispatch_get_main_queue(), ^{
//
//                productShowlistInfo = [dict objectForKey:@"productlist"];
//
//                if ([productShowlistInfo count]>0) {
//
//                    productShowDict = (NSDictionary *)[productShowlistInfo objectAtIndex:0];
//
//                    dispatch_async(dispatch_get_main_queue(), ^{
//
//                        [self.tableViewProductShow reloadData];
//
//                    });
//                    //                    [SVProgressHUD dismiss];
//                }
//                else{
//
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with order history, try again later."
//                                                                        message:nil
//                                                                       delegate:nil
//                                                              cancelButtonTitle:@"Ok"
//                                                              otherButtonTitles:nil];
//                    [alertView show];
//                    //                    [SVProgressHUD dismiss];
//
//                }
//                //               });
//            } else {
//
//                //                [SVProgressHUD dismiss];
//
//                NSLog(@"Error: %@", error);
//
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with order history, try again later."
//                                                                    message:nil
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"Ok"
//                                                          otherButtonTitles:nil];
//                [alertView show];
//            }
//        }
//    }];
//
//}
-(void)productbycatbyuserpreference
{
//    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"user_id=%@",_userIdStr];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"productbycatbyuserpreference.php" completion:^(NSDictionary * dict, NSError *error) {
        
//        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                //                dispatch_async(dispatch_get_main_queue(), ^{
                
                productShowlistInfo = [dict objectForKey:@"productlist"];
                
                if ([productShowlistInfo count]>0) {
                    
                    productShowDict = (NSDictionary *)[productShowlistInfo objectAtIndex:0];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.tableViewProductShow reloadData];
                        
                    });
                    //                    [SVProgressHUD dismiss];
                }
                else{
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with order history, try again later."
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    //                    [SVProgressHUD dismiss];
                    
                }
                //               });
            } else {
                
//                [SVProgressHUD dismiss];
                
                NSLog(@"Error: %@", error);
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with login, try again later."
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
