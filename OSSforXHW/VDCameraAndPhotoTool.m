//
//  CameraAndPhotoTool.m
//  sheet
//
//  Created by lyb on 16/3/22.
//  Copyright © 2016年 lyb. All rights reserved.
//

#import "VDCameraAndPhotoTool.h"
#import "UIImage+Extension.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef enum {
    
    photoType,
    cameraType,
    videoType
}pickerType;
static VDCameraAndPhotoTool *tool ;

@interface VDCameraAndPhotoTool ()<UIActionSheetDelegate>

@property (nonatomic, copy)cameraReturn finishBack;

@property (nonatomic, strong) UIActionSheet *actionSheet;

@property(nonatomic, weak)UIViewController *fromVc;

@property (nonatomic, strong) UIImagePickerController *picker;


@end


@implementation VDCameraAndPhotoTool

+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        tool = [[VDCameraAndPhotoTool alloc] init];
    });
    
    return tool;
}


- (void)showVideoInViewController:(UIViewController *)vc andFinishBack:(cameraReturn)finishBack {
    
    if (finishBack) {
        
        self.finishBack = finishBack;
    }
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self setUpImagePicker:videoType];
    
    [vc presentViewController:self.picker animated:YES completion:nil];//进入照相界面
    [vc.view layoutIfNeeded];
}


- (void)showCameraInViewController:(UIViewController *)vc andFinishBack:(cameraReturn)finishBack {
    
    if (finishBack) {
        
        self.finishBack = finishBack;
    }
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self setUpImagePicker:cameraType];
    
    [vc presentViewController:self.picker animated:YES completion:nil];//进入照相界面
    [vc.view layoutIfNeeded];
}

- (void)showPhotoInViewController:(UIViewController *)vc andFinishBack:(cameraReturn)finishBack{
    
    if (finishBack) {
        
        self.finishBack = finishBack;
    }
    
   [self setUpImagePicker:photoType];
    
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [vc presentViewController:self.picker animated:YES completion:nil];//进入相册界面
    [vc.view layoutIfNeeded];

}

#pragma mark - imagePicker delegate
/**
 *  完成回调
 *
 *  @param picker imagePickerController
 *  @param info   信息字典
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, NULL);
            });
        }
        
        //根据屏幕方向裁减图片(640, 480)||(480, 640),如不需要裁减请注释
//        image = [UIImage resizeImageWithOriginalImage:image];
        NSString *time = [self getNowTimeTimestamp3];
        [self saveImageToSandbox:image andImageNage:[NSString stringWithFormat:@"%@.png",time]];
        
        if ([self filePath:[NSString stringWithFormat:@"%@.png",time]]) {
 // NSLog(@"-------------%@",[self filePath:[NSString stringWithFormat:@"%@.png",time]]);
        }
//        NSURL *pUrl = [info objectForKey:uiima];
     //   UIImage *shaimage = [self loadImageFromSandbox:[NSString stringWithFormat:@"%@.png",time]];
      
        if (self.finishBack) {
            
            self.finishBack(nil,[self filePath:[NSString stringWithFormat:@"%@.png",time]]);
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        
        NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        NSString *urlStr=[url path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
            
            //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
        }
    }
    
    
}


#pragma mark----将照片保存到沙盒
-(void)saveImageToSandbox:(UIImage *)image andImageNage:(NSString *)imageName
{
    //高保真压缩图片，此方法可将图片压缩，但是图片质量基本不变，第二个参数为质量参数
    NSData *imageData=UIImageJPEGRepresentation(image, 0.5);
    //将图片写入文件
    NSString *filePath=[self filePath:imageName];
    //是否保存成功
    BOOL result=[imageData writeToFile:filePath atomically:YES];
    //保存成功传值到blcok中
    
    NSLog(@"----chengg----%d",result);
}
#pragma mark----获取沙盒路径
-(NSString *)filePath:(NSString *)fileName
{
    //获取沙盒目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //保存文件名称
    NSString *filePath=[paths[0] stringByAppendingPathComponent:fileName];
    
    return filePath;
}

#pragma mark----从沙盒中读取照片
-(UIImage *)loadImageFromSandbox:(NSString *)imageName
{
    //获取沙盒路径
    NSString *filePath=[self filePath:imageName];
    //根据路径读取image
    UIImage *image=[UIImage imageWithContentsOfFile:filePath];
    
    return image;
}

//获取当前时间戳  （以毫秒为单位）

-(NSString *)getNowTimeTimestamp3{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
    
}


//视频保存后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {//可以在此解析错误
        
    }else{//保存成功
        
        //录制完之后自动播放
        if (self.finishBack) {
            
            self.finishBack(nil,videoPath);
            //NSLog(@"-------------%@",videoPath);
        }
        
       [self.picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showImagePickerController:(UIViewController *)vc andFinishBack:(cameraReturn)finishBack{
    
    if (finishBack) {
        
        self.finishBack = finishBack;
    }
    
    if (vc) {
        
        self.fromVc = vc;
        [self.actionSheet showInView:vc.view];
    }
    
}


- (void)setUpImagePicker:(pickerType )type {
    
    self.picker = nil;
    
    self.picker = [[UIImagePickerController alloc] init];//初始化
    self.picker.delegate = self;
    self.picker.allowsEditing = NO;//设置不可编辑
    
    if (type == photoType) {
        
        //判断用户是否允许访问相册权限
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
            //无权限
            return;
        }
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        self.picker.sourceType = sourceType;
    }else if (type == cameraType){
        //判断用户是否允许访问相机权限
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {
            //无权限
            return;
        }
        //判断用户是否允许访问相册权限
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
            //无权限
            return;
        }
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        self.picker.sourceType = sourceType;
        
        
    }else if (type == videoType) {
        //判断用户是否允许访问相机权限
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {
            //无权限
            return;
        }
        
        //判断用户是否允许访问麦克风权限
        authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {
            //无权限
            return;
        }

        //判断用户是否允许访问相册权限
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
            //无权限
            return;
        }
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        self.picker.sourceType = sourceType;
        
        self.picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        self.picker.videoQuality=UIImagePickerControllerQualityTypeIFrame1280x720;
        self.picker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;
       
    }
    
}

#pragma mark - actionsheet delegate


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        [self showCameraInViewController:self.fromVc andFinishBack:nil];
        
    }else if (buttonIndex == 1) {
        
        [self showPhotoInViewController:self.fromVc andFinishBack:nil];
        
    }else if (buttonIndex == 2) {
        
        [self showVideoInViewController:self.fromVc andFinishBack:nil];
    }

}



#pragma mark - getter and setter

- (UIActionSheet *)actionSheet {
    if (_actionSheet == nil) {
        _actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册",@"录像", nil];
    }
    return _actionSheet;
}
@end
