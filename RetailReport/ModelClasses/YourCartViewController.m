//
//  YourCartViewController.m
//  Jing
//
//  Created by fnspl3 on 11/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "YourCartViewController.h"
#import "YourCartTableViewCell.h"
//#import "SDWebImage/UIImageView+WebCache.h"
#import "UIImageView+WebCache.h"

#import "YourCartTableViewCell.h"
#import "ScanForBillViewController.h"
//#import "ProductCategoryViewController.h"
//#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)



@interface YourCartViewController (){
    
    int number;
    int totalitem;
    int totalvalue;
//    int selectedTag;
    NSString*orderuniqueidStr;
    NSString*useridStr;

}

@end

@implementation YourCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    api = [APIManager sharedManager];
    _continueView.layer.cornerRadius = 20.0f;
    _continueView.clipsToBounds = YES;
    
    _checkoutview.layer.cornerRadius = 20.0f;
    _checkoutview.clipsToBounds = YES;
    [self.navigationController.navigationBar setHidden:YES];

    number = 0;
  self.lblSubtotal.text = [NSString stringWithFormat:@"Subtotal :Rs %@ /-",_totalAmountStr];
  self.lblItems.text = [NSString stringWithFormat:@"Items : %@",_totalQuantityStr];
    
    ///////////////////////////////////////////////////

//        totalitem = 0;
//        totalvalue = 0;
//
//        _ProductInfo = [Userdefaults objectForKey:@"CartDetails"];
//
//        if ([_ProductInfo count]>0) {
//
//            for (int i=0; i<[_ProductInfo count]; i++) {
//
//                NSDictionary *dict = [_ProductInfo objectAtIndex:i];
//
//                number = (int)[[Userdefaults objectForKey:[NSString stringWithFormat:@"Product:%d",i]] integerValue];
//
//                if (number==0) {
//
//                    number=1;
//                }
//                //            [Userdefaults removeObjectForKey:[NSString stringWithFormat:@"Product:%d",i]];
//                [Userdefaults setObject:[NSString stringWithFormat:@"%d",number] forKey:[NSString stringWithFormat:@"Product:%d",i]];
//
//                [Userdefaults synchronize];
//
//                NSString *Rupees = [NSString stringWithFormat:@"%@",[dict objectForKey:@"price"]];
//                //            [Userdefaults removeObjectForKey:[NSString stringWithFormat:@"Product:%d",i]];
//
//                totalitem = number + totalitem;
//                totalvalue = ((int)[Rupees integerValue]*number) + totalvalue;
//
//            }
//
//            self.lblSubtotal.text = [NSString stringWithFormat:@"Subtotal : %d Rs/-",totalvalue];
//            self.lblItems.text = [NSString stringWithFormat:@"Items : %d",totalitem];
//
//        }
//        else
//        {
//            self.lblSubtotal.text = [NSString stringWithFormat:@"Subtotal : %d Rs/-",totalvalue];
//            self.lblItems.text = [NSString stringWithFormat:@"Items : %d",totalitem];
//        }
    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
  return [_ProductInfo count];
    
//    return [[_productInfoDict objectForKey:@"productlist"] count];
   // NSDictionary *dict = [_ProductInfo objectAtIndex:0];
   // return [[dict objectForKey:@"title"]count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"YourCartTableViewCell";
    
    YourCartTableViewCell *cell = (YourCartTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"YourCartTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell setDelegate:self];
    
//    NSDictionary *dict = [[_productInfoDict objectForKey:@"productlist"] objectAtIndex:indexPath.row];
//    cell.lblName.text = [dict objectForKey:@"title"];
    
    if ([_ProductInfo count]>0) {
        
        NSDictionary *dict = [_ProductInfo objectAtIndex:indexPath.row];
        
        cell.lblName.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
        cell.lblRupees.text=[NSString stringWithFormat:@"Rs %@/-",[dict objectForKey:@"price"]];
        
        cell.lblCount.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"quantity"]];
        
//        [NSString stringWithFormat:@"%@",[dict objectForKey:@"gate_pass"]];
//        gate_pass
        
        cell.imgview.image = nil;
        
        NSString *imgURL= [NSString stringWithFormat:@"http://cxc.gohipla.com/retail/admin/resources/image/product/%@/%@",[dict objectForKey:@"product_image_folder"],[dict objectForKey:@"product_image"]];
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
                                    cell.imgview.image = image;
                                    
                                    //                                [cell.indicatorView setHidden:YES];
                                    //                                [cell.indicatorView stopAnimating];
                                    
                                }
                            }];
        
        [cell.imgview setContentMode:UIViewContentModeScaleAspectFit];
        
        NSDictionary *dict2 = [_ProductInfoDetails objectAtIndex:0];
        NSString*gatepassStr=[NSString stringWithFormat:@"%@",[dict2 objectForKey:@"gate_pass"]];
        orderuniqueidStr=[NSString stringWithFormat:@"%@",[dict2 objectForKey:@"order_unique_id"]];
        useridStr=[NSString stringWithFormat:@"%@",[dict2 objectForKey:@"user_id"]];
        
        if ([gatepassStr isEqualToString:@"0"]) {
         
             [self.checkoutBtnOutlet addTarget:self action:@selector(btnApproved:) forControlEvents:UIControlEventTouchUpInside];
            
//            NSString*gatepassStr3=@"XYZ";
//            NSLog(@"Error: %@", gatepassStr3);
        }
        else if ([gatepassStr isEqualToString:@"1"]) {
            
            [_checkoutBtnOutlet setTitle:@"Already Approved" forState:UIControlStateNormal];
            [_checkoutBtnOutlet setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            _checkoutview.backgroundColor=[UIColor whiteColor];
            _checkoutview.layer.borderColor = [UIColor blackColor].CGColor;
            _checkoutview.layer.borderWidth = 1.0f; //make border 1px thick
            _checkoutview.layer.cornerRadius = 20.0f;
            _checkoutview.layer.masksToBounds = YES;
            _checkoutview.clipsToBounds = YES;
            
            [self.checkoutBtnOutlet addTarget:self action:@selector(btnAlreadyApproved:) forControlEvents:UIControlEventTouchUpInside];
           
        }
        else{
            
        }
    
    }
    
//    [cell.btnPlusOutlet addTarget:self action:@selector(btnPlus:) forControlEvents:UIControlEventTouchUpInside];
//    cell.btnPlusOutlet.tag = indexPath.row;
    
//    [cell.btnMinusOutlet addTarget:self action:@selector(decrementNumber:) forControlEvents:UIControlEventTouchUpInside];
//    cell.btnMinusOutlet.tag = indexPath.row;
    
//    if(cell.btnMinusOutlet.tag == selectedTag){
//
//        [cell.btnMinusOutlet addTarget:self action:@selector(decrementNumber:) forControlEvents:UIControlEventTouchUpInside];
//    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 98;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
}

#pragma mark - YourCartTableViewCellDelegate
- (void)plusBtnAction:(id)sender{
    
    YourCartTableViewCell *cell = (YourCartTableViewCell *)sender;
    number++;
    cell.lblCount.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%ld",number]];
    
}
- (void)minusBtnAction:(id)sender{
    YourCartTableViewCell *cell = (YourCartTableViewCell *)sender;
    number--;
    if (number<0) {
        number = 0;
    }
    cell.lblCount.text = [NSString stringWithFormat:@"%ld",number];
}
- (void)deleteBtnAction:(id)sender{
    YourCartTableViewCell *cell = (YourCartTableViewCell *)sender;
    NSIndexPath* pathOfTheCell = [_tableViewYourCart indexPathForCell:cell];
    [self.ProductInfo removeObjectAtIndex:pathOfTheCell.row];
    [[self tableViewYourCart] reloadData];
    
}

- (IBAction)crossBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (IBAction)continueBtn:(id)sender {
//    
//    ProductCategoryViewController *productCategoryViewControllerScreen = [[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];
//    [self.navigationController pushViewController:productCategoryViewControllerScreen animated:YES];
//    
//}
- (void)btnApproved:(UIButton *)sender{
    
//    [Userdefaults removeObjectForKey:@"CartDetails"];
    
//    [_lblSubtotal removeAllSubviews];
//    [_lblItems removeAllSubviews];
    
//    _ProductInfo = [[NSMutableArray alloc] init];
//
//    [Userdefaults removeObjectForKey:@"CartDetails"];
//    [Userdefaults synchronize];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//    ScanForBillViewController *scanBarcodeViewControllerViewScreen = [[ScanForBillViewController alloc]initWithNibName:@"ScanForBillViewController" bundle:nil];
//
//    [self.navigationController pushViewController:scanBarcodeViewControllerViewScreen animated:YES];
//
//  });
    
    [self gatestatus];
    
}

- (void)btnAlreadyApproved:(id)sender{

    _ProductInfo = [[NSMutableArray alloc] init];
    
    [Userdefaults removeObjectForKey:@"CartDetails"];
    [Userdefaults synchronize];
   
    
    dispatch_async(dispatch_get_main_queue(), ^{

        ScanForBillViewController *scanBarcodeViewControllerViewScreen = [[ScanForBillViewController alloc]initWithNibName:@"ScanForBillViewController" bundle:nil];

        [self.navigationController pushViewController:scanBarcodeViewControllerViewScreen animated:YES];

    });
    
}

-(void)gatestatus
{
  //  [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"order_unique_id=%@&user_id=%@",orderuniqueidStr,useridStr];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"gatestatus.php" completion:^(NSDictionary * dict, NSError *error) {
        
       // [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                _ProductInfo = [[NSMutableArray alloc] init];
                
                [Userdefaults removeObjectForKey:@"CartDetails"];
                [Userdefaults synchronize];
                
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"order pass status changed."
                                              message:nil
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             
                                             ScanForBillViewController *scanBarcodeViewControllerViewScreen = [[ScanForBillViewController alloc]initWithNibName:@"ScanForBillViewController" bundle:nil];
                                             
                                             [self.navigationController pushViewController:scanBarcodeViewControllerViewScreen animated:YES];
                                             
                                         });
                                         
                                     }];
                
                [alert addAction:ok];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            else {
                
                [SVProgressHUD dismiss];
                
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

@end
