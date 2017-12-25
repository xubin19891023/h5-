//
//  ScanCodeViewController.m
//  demo
//
//  Created by gaofu on 2017/4/10.
//  Copyright © 2017年 siruijk. All rights reserved.
//

#import "ScanCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Extend.h"
#import "WindowsWebviewViewController.h"
#import "RegisterHandler.h"
#import "SMAlert.h"
#define OUTPUT @"CK"
#define INPUT  @"RK"

//入库
#define STORE_IN_BILL   @"http://h5oss.testxianghuowang.me:8051/store/inbill/detail/show/tags.do?isScan=true&vin_bill_id="//@"http://h5oss.xianghuo.me/store/inbill/detail/show/tags.do?isScan=true&vin_bill_id="
//出库
#define STORE_OUT_BILL  @"http://h5oss.testxianghuowang.me:8051/store/obill/detail/show/tags.do?isScan=true&nout_bill_id="//@"http://h5oss.xianghuo.me/store/obill/detail/show/tags.do?isScan=true&nout_bill_id="

const static CGFloat animationTime = 2.5f;//扫描时长

@interface ScanCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) AVCaptureSession *captureSession;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic,strong) AVCaptureMetadataOutput *captureMetadataOutput;
@property (nonatomic,strong) CAShapeLayer *scanPaneBgLayer;
@property (nonatomic , strong) UIButton *lightBtn;
@end

@implementation ScanCodeViewController
{
    UIImageView             *_scanPane;//扫描框
    UILabel                 *_contentLabel;
    NSLayoutConstraint      *_boxLayoutConstraint;
    UIActivityIndicatorView *_loaddingIndicatorView;
    UIImageView             *_scanLine;//扫描线
}


//-(void) initWith
#pragma mark -
#pragma mark  Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 20, 44+20, 44)];
    [button setTitle:[NSString stringWithFormat:@"返回"] forState:UIControlStateNormal];
  
    [button setImage:[UIImage imageNamed:@"back_m"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _scanPane  = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width -260)/2, (self.view.frame.size.height -260)/2, 260, 260)];
    [_scanPane setImage:[UIImage imageNamed:@"scancode_box"]];
    [self.view addSubview:_scanPane];
    
        _lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lightBtn.frame = CGRectMake(40,self.view.bounds.size.height-100, self.view.frame.size.width/2-40, 40);
        [_lightBtn setBackgroundColor:[UIColor clearColor]];
    _lightBtn.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height-100);
    _lightBtn.layer.borderWidth = 0.5;
    _lightBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [_lightBtn setTitle:@"开启手电筒" forState:UIControlStateNormal];
        [_lightBtn addTarget:self action:@selector(lightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_lightBtn];
    
    [self initScanCode];
    [self initScanLine];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startScan];
}

-(void) buttonClick:(id)sender
{
   
        [self.navigationController popViewControllerAnimated:YES];
 
}

-(CAShapeLayer *)scanPaneBgLayer
{
    
    if (!_scanPaneBgLayer)
    {
        _scanPaneBgLayer = [CAShapeLayer layer];
    }
    return _scanPaneBgLayer;
}

#pragma mark -
#pragma mark  Interface Components

//扫描线
-(void)initScanLine
{
    _scanLine = [UIImageView new];
    _scanLine.image = [UIImage imageNamed:@"scancode_line"];
    [_scanPane addSubview:_scanLine];
    
    [self setScanReact:YES];
    [self.view.layer insertSublayer:self.scanPaneBgLayer above:self.captureVideoPreviewLayer];
}

//绘制扫描框背景
- (void)setScanReact:(BOOL)loading
{
    
    CGRect scanRect = _scanPane.frame;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:scanRect];
    [path appendPath:[UIBezierPath bezierPathWithRect:self.view.bounds]];
    
    [self.scanPaneBgLayer setFillRule:kCAFillRuleEvenOdd];
    [self.scanPaneBgLayer setPath:path.CGPath];
    [self.scanPaneBgLayer setFillColor:[UIColor colorWithWhite:0 alpha:loading ? 1 : 0.6].CGColor];
}


#pragma mark -
#pragma mark  Target Action Methods

//开灯按钮
- (void)lightBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
//    [_lightBtn setTitle:@"关闭手电筒" forState:UIControlStateNormal];

    [self turnTorchOn:sender.selected];
}

//打开相册
- (void)photoBtnAction:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = true;
    [self presentViewController:picker animated:true completion:nil];
}

#pragma mark -
#pragma mark  DataRequest


#pragma mark -
#pragma mark  Private Methods

//初始化扫描二维码
-(void)initScanCode
{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (error)
    {
        [self showMessage:@"摄像头不可用" title:@"温馨提示" andler:nil];
        [self.navigationController popViewControllerAnimated:YES];
       // return;
    }
    
    if ([device lockForConfiguration:nil])
    {
        //自动白平衡
        if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance])
        {
            [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        }
        //自动对焦
        if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
        {
            [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        //自动曝光
        if ([device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
        {
            [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
        }
        [device unlockForConfiguration];
    }
    self.captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    [self.self.captureSession canAddInput:input] ? [self.captureSession addInput:input] : nil;
    [self.captureSession canAddOutput:self.captureMetadataOutput] ? [self.captureSession addOutput:self.captureMetadataOutput] : nil;
    
    [self.captureMetadataOutput setMetadataObjectTypes:@[
                                                         AVMetadataObjectTypeQRCode,
                                                         AVMetadataObjectTypeCode39Code,
                                                         AVMetadataObjectTypeCode128Code,
                                                         AVMetadataObjectTypeCode39Mod43Code,
                                                         AVMetadataObjectTypeEAN13Code,
                                                         AVMetadataObjectTypeEAN8Code,
                                                         AVMetadataObjectTypeCode93Code
                                                         ]];
    
    self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.captureVideoPreviewLayer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:self.captureVideoPreviewLayer atIndex:0];
    
    [self loadScan];
}

//启动扫描
-(void)loadScan
{
    [_loaddingIndicatorView startAnimating ];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.captureSession startRunning];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_loaddingIndicatorView stopAnimating];
            [UIView animateWithDuration:0.25 animations:^{
                _contentLabel.alpha = 1;
                _boxLayoutConstraint.constant = 260;//[UIScreen mainScreen].bounds.size.width*0.6;
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                _scanLine.frame = CGRectMake(0 , 0, 260, 3);
                [_scanLine.layer addAnimation:[self moveAnimation] forKey:nil];
                [self setScanReact:NO];
            }];
            self.captureMetadataOutput.rectOfInterest = [self.captureVideoPreviewLayer metadataOutputRectOfInterestForRect:_scanPane.frame];
        });
    });
}

//开始扫描
- (void)startScan
{
    [_scanLine.layer addAnimation:[self moveAnimation] forKey:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.captureSession startRunning];
    });
}

//停止扫描
- (void)stopScan
{
    
    [_scanLine.layer removeAllAnimations];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.captureSession.isRunning )
        {
            [self.captureSession stopRunning];
        }
    });
}

//扫描动画
-(CABasicAnimation*)moveAnimation
{
    CGPoint starPoint = CGPointMake(_scanLine .center.x  , 1);
    CGPoint endPoint = CGPointMake(_scanLine.center.x, _scanPane.bounds.size.height - 2);
    
    CABasicAnimation*translation = [CABasicAnimation animationWithKeyPath:@"position"];
    translation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    translation.fromValue = [NSValue valueWithCGPoint:starPoint];
    translation.toValue = [NSValue valueWithCGPoint:endPoint];
    translation.duration = animationTime;
    translation.repeatCount = CGFLOAT_MAX;
    translation.autoreverses = YES;
    
    return translation;
}

//散光灯
- (void)turnTorchOn: (BOOL)on
{
    if (on) {
        [_lightBtn setTitle:@"关闭手电筒" forState:UIControlStateNormal];
    }else{
        [_lightBtn setTitle:@"开启手电筒" forState:UIControlStateNormal];

    }
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    
    if (captureDeviceClass != nil)
    {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash])
        {
            [device lockForConfiguration:nil];
            if (on && device.torchMode == AVCaptureTorchModeOff)
            {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
            }
            if (!on && device.torchMode == AVCaptureTorchModeOn)
            {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

//扫描结果处理
-(void)dealwithResult:(NSString*)result
{
//    NSLog(@"scan result:%@",result);
    
//    [SMAlert setConfirmBtBackgroundColor:[UIColor whiteColor]];
//    [SMAlert setConfirmBtTitleColor:[UIColor redColor]];
//    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
//    [SMAlert setCancleBtTitleColor:[UIColor blueColor]];
//    [SMAlert setContentTextAlignment:NSTextAlignmentLeft];
//    [SMAlert showContent:result confirmButton:[SMButton initWithTitle:@"确定" clickAction:^{
//            [SMAlert hide];
        if (self.isJSCallBack)
        {
            [self scanCallBack:result];
//             NSLog(@"111111111-------js调用扫码");
        }
        else
        {
            [self scanResult:result];
//             NSLog(@"222222222-------js调用扫码");
        }

//        }] cancleButton:[SMButton initWithTitle:@"取消" clickAction:nil]];
    
    [self playScanCodeSound];
    
}

#pragma mark result mothed
-(void) scanCallBack:(NSString*)result
{

//        NSLog(@"js调用扫码");
        self.myBlock(result); //1
        [self.navigationController popViewControllerAnimated:YES];
        
        
        
//    }
    
}
-(void) scanResult:(NSString *)resultStr
{
    NSString *url = nil;
    NSString *titleName =@"";
    if ([resultStr hasPrefix:INPUT])
    {
        url = [NSString stringWithFormat:@"%@%@",STORE_IN_BILL,resultStr];
        titleName =@"入库单";
    }
    else if ([resultStr hasPrefix:OUTPUT])
    {
        url = [NSString stringWithFormat:@"%@%@",STORE_OUT_BILL,resultStr];
        titleName =@"出库单";
        
    }
    else if ([resultStr hasPrefix:@"http"])
    {
        NSLog(@"扫码的结果：%@",resultStr);
        url = resultStr;
    }
    
    WindowsWebviewViewController *WindowsWeb = [[WindowsWebviewViewController alloc]initWithWindowsObjectWithUrl:url title:titleName];
    WindowsWeb.isFull = YES;
    WindowsWeb.callBackScanResult = resultStr;
    [self.navigationController pushViewController:WindowsWeb animated:YES];
    
}

//播放提示音
- (void)playScanCodeSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"scancode.caf" ofType:nil];
    
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
    AudioServicesPlayAlertSound(soundID);
}

-(void)showMessage:(NSString*)message title:(NSString*)title andler:(void (^)(UIAlertAction *action))handler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:handler];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark -
#pragma mark  AVCaptureMetadataOutputObjects Delegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self stopScan];
    
    //扫完完成
    if (metadataObjects.count > 0)
    {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        NSString *result = obj.stringValue;
        [self dealwithResult:result];
    }
}


#pragma mark -
#pragma mark  UIImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image)
    {
        image = info[UIImagePickerControllerOriginalImage];
    }
    [_loaddingIndicatorView startAnimating];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        NSString *scanResult = [image scanCodeContent];
        
        [_loaddingIndicatorView stopAnimating];
        
        [self dealwithResult:scanResult];
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:true completion:nil];
}


#pragma mark -
#pragma mark  Dealloc

-(void)dealloc
{
    [self.captureSession stopRunning];
    _captureMetadataOutput = nil;
    _captureSession = nil;
    [_captureVideoPreviewLayer removeFromSuperlayer];
    _captureVideoPreviewLayer = nil;
}

@end
