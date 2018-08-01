//
//  ScanBarcodeViewController.h
//  RetailReport
//
//  Created by fnspl3 on 23/11/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NSDictionary+NullReplacement.h"

@interface ScanBarcodeViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>{
    
    APIManager *api;
}
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL isReading;

- (IBAction)btnBack:(id)sender;
//For barcode
@property (strong, nonatomic) NSMutableArray * allowedBarcodeTypes;
@end
