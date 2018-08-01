//
//  ScanBarcodeViewController.m
//  RetailReport
//
//  Created by fnspl3 on 23/11/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "ScanBarcodeViewController.h"
#import "Barcode.h"
#import "CartDetails.h"
#import "YourCartViewController.h"
@import AVFoundation; 

@interface ScanBarcodeViewController (){
    
    NSMutableArray *ProductInfo;
    NSMutableArray *ProductInfo2;
    NSDictionary *productInfoDict;
    NSDictionary *productInfoDict2;
    CartDetails* cartDetails;
    NSString* totalAmountStr;
    NSString*totalQuantityStr;
    BOOL isProcessing;
    
    
}

@property (strong, nonatomic) NSMutableArray * foundBarcodes;
@property (weak, nonatomic) IBOutlet UIView *previewView;

@end

@implementation ScanBarcodeViewController{
    
    AVCaptureSession *_captureSession;
    AVCaptureDevice *_videoDevice;
    AVCaptureDeviceInput *_videoInput;
    AVCaptureVideoPreviewLayer *_previewLayer;
    BOOL _running;
    AVCaptureMetadataOutput *_metadataOutput;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [Userdefaults removeObjectForKey:@"CartDetails"];
    [Userdefaults synchronize];
    
    isProcessing=NO;
    [self.navigationController.navigationBar setHidden:YES];
    
     api = [APIManager sharedManager];
    
    [self setupCaptureSession];
    _previewLayer.frame = _previewView.bounds;
    [_previewView.layer addSublayer:_previewLayer];
    self.foundBarcodes = [[NSMutableArray alloc] init];
    
    // listen for going into the background and stop the session
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillEnterForeground:)
     name:UIApplicationWillEnterForegroundNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationDidEnterBackground:)
     name:UIApplicationDidEnterBackgroundNotification
     object:nil];
    
    // set default allowed barcode types, remove types via setings menu if you don't want them to be able to be scanned
    self.allowedBarcodeTypes = [NSMutableArray new];
    [self.allowedBarcodeTypes addObject:@"org.iso.QRCode"];
    [self.allowedBarcodeTypes addObject:@"org.iso.PDF417"];
    [self.allowedBarcodeTypes addObject:@"org.gs1.UPC-E"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Aztec"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Code39"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Code39Mod43"];
    [self.allowedBarcodeTypes addObject:@"org.gs1.EAN-13"];
    [self.allowedBarcodeTypes addObject:@"org.gs1.EAN-8"];
    [self.allowedBarcodeTypes addObject:@"com.intermec.Code93"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Code128"];
    
//    [self postQRMatching];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startRunning];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopRunning];
}
#pragma mark - AV capture methods

- (void)setupCaptureSession {
    // 1
    if (_captureSession) return;
    // 2
    _videoDevice = [AVCaptureDevice
                    defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!_videoDevice) {
        NSLog(@"No video camera on this device!");
        return;
    }
    // 3
    _captureSession = [[AVCaptureSession alloc] init];
    // 4
    _videoInput = [[AVCaptureDeviceInput alloc]
                   initWithDevice:_videoDevice error:nil];
    // 5
    if ([_captureSession canAddInput:_videoInput]) {
        [_captureSession addInput:_videoInput];
    }
    // 6
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc]
                     initWithSession:_captureSession];
    _previewLayer.videoGravity =
    AVLayerVideoGravityResizeAspectFill;
    
    
    // capture and process the metadata
    _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    dispatch_queue_t metadataQueue =
    dispatch_queue_create("com.1337labz.featurebuild.metadata", 0);
    [_metadataOutput setMetadataObjectsDelegate:self
                                          queue:metadataQueue];
    if ([_captureSession canAddOutput:_metadataOutput]) {
        [_captureSession addOutput:_metadataOutput];
    }
}

- (void)startRunning {
    if (_running) return;
    [_captureSession startRunning];
    _metadataOutput.metadataObjectTypes =
    _metadataOutput.availableMetadataObjectTypes;
    _running = YES;
}
- (void)stopRunning {
    if (!_running) return;
    [_captureSession stopRunning];
    _running = NO;
}

//  handle going foreground/background
- (void)applicationWillEnterForeground:(NSNotification*)note {
    [self startRunning];
}
- (void)applicationDidEnterBackground:(NSNotification*)note {
    [self stopRunning];
}
#pragma mark - Delegate functions

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    [metadataObjects
     enumerateObjectsUsingBlock:^(AVMetadataObject *obj,
                                  NSUInteger idx,
                                  BOOL *stop)
     {
         if ([obj isKindOfClass:
              [AVMetadataMachineReadableCodeObject class]])
         {
             // 3
             AVMetadataMachineReadableCodeObject *code =
             (AVMetadataMachineReadableCodeObject*)
             [_previewLayer transformedMetadataObjectForMetadataObject:obj];
             // 4
             Barcode * barcode = [Barcode processMetadataObject:code];
             
             for(NSString * str in self.allowedBarcodeTypes){
                 if([barcode.getBarcodeType isEqualToString:str]){
                     [self validBarcodeFound:barcode];
                     return;
                 }
             }
         }
     }];
}

- (void) validBarcodeFound:(Barcode *)barcode{
    if(!isProcessing){
    [self stopRunning];
    [self.foundBarcodes addObject:barcode];
    [self postQRMatching:barcode];
    }
}

- (IBAction)btnShowCart:(id)sender {
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        YourCartViewController *YourCartViewScreen = [[YourCartViewController alloc]initWithNibName:@"YourCartViewController" bundle:nil];
//
//        YourCartViewScreen.ProductInfo = cartDetails.addToCartItems;
//
//        [self.navigationController pushViewController:YourCartViewScreen animated:YES];                    });
    
    //    [self postQRMatching];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)postQRMatching:(Barcode *)QRstr

//-(void)postQRMatching
{
//    [SVProgressHUD show];
     isProcessing=YES;
    NSString *userUpdate = [NSString stringWithFormat:@"order_unique_id=%@",[QRstr getBarcodeData]];
//    NSString *userUpdate = [NSString stringWithFormat:@"order_unique_id=OD11308943806"];
    
    NSLog(@"%@",userUpdate);
    
    //    NSString *userUpdate = [NSString stringWithFormat:@"bar_code=9771234567003"];
    
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"ordpurchasedbyuniqueid.php" completion:^(NSDictionary * dict, NSError *error) {
//        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
//                 isProcessing=NO;
                ProductInfo = [dict objectForKey:@"order_list"];
                
                if ([ProductInfo count]>0) {
                    
                    productInfoDict = (NSDictionary *)[ProductInfo objectAtIndex:0];
                    
        ///////////////////////////////////////////////////////////////////////////////////////////
                    totalAmountStr =[NSString stringWithFormat:@"%@",[productInfoDict objectForKey:@"total_amount"]];
                    totalQuantityStr =[NSString stringWithFormat:@"%@",[productInfoDict objectForKey:@"total_quantity"]];
                    
        //////////////////////////////////////////////////////////////////////////////////////////
                    
                    ProductInfo2 = (NSMutableArray *) [productInfoDict objectForKey:@"product"];
                    
                    if ([ProductInfo2 count] > 0)
                    {
                        for (int i=0; i<[ProductInfo2 count]; i++) {
                            
                            productInfoDict2 = (NSDictionary *)[ProductInfo2 objectAtIndex:i];
                            
                            cartDetails = [CartDetails sharedInstanceCartDetails];
                            
                            cartDetails.addToCartItems = [NSMutableArray array];
                            
                            NSString *countlbl = [productInfoDict2 objectForKey:@"quantity"];
                            
                            [Userdefaults setObject:countlbl forKey:[NSString stringWithFormat:@"Product:%d",i]];
                            
                            [cartDetails.addToCartItems addObject:productInfoDict2];
                            
                            NSMutableArray *ProductInfo = [Userdefaults objectForKey:@"CartDetails"];
                            
                            for (NSDictionary *dict in ProductInfo)
                            {
                                [cartDetails.addToCartItems addObject:dict];
                            }
                            
                            [Userdefaults setObject:cartDetails.addToCartItems forKey:@"CartDetails"];
                            
                            [Userdefaults synchronize];
                            
                            //  NSDictionary *dict = [ProfDict dictionaryByReplacingNullsWithBlanks];
                            //  NSLog(@"DICT=====%@",dict);
                            //
                            
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            YourCartViewController *YourCartViewScreen = [[YourCartViewController alloc]initWithNibName:@"YourCartViewController" bundle:nil];
                            
                            YourCartViewScreen.ProductInfo = cartDetails.addToCartItems;
                            YourCartViewScreen.totalAmountStr = totalAmountStr;
                            YourCartViewScreen.totalQuantityStr = totalQuantityStr;
                            YourCartViewScreen.ProductInfoDetails = ProductInfo;
                            
                            [self.navigationController pushViewController:YourCartViewScreen animated:YES];
                            
                        });
                    }
                    
                }
                else{
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"This product bar code not matched, please try again later."
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                    
                         [alertView show];
                    });
                    
//                    [SVProgressHUD dismiss];
                    
                }
                
            } else {
                
//                [SVProgressHUD dismiss];
                
                NSLog(@"Error: %@", error);
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem to the  barcode scaning, try again later."
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
        }
    }];
    
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
