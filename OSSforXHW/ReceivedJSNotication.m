//
//  ReceivedJSNotication.m
//  乡货网
//
//  Created by Bill on 2017/5/9.
//  Copyright © 2017年 Bill. All rights reserved.
//

#import "ReceivedJSNotication.h"
#import "WindowsOpenPage.h"
#import "WindowsWebviewViewController.h"
#import "AnimationEffect.h"
#import "Config.h"
#import "ScanCodeViewController.h"
#import "RegisterHandler.h"
#import "VDCameraAndPhotoTool.h"
#import "RegisterHandler.h"
#import "WeighingandsortingViewController.h"
#import "RukuViewController.h"
@implementation ReceivedJSNotication


+ (ReceivedJSNotication *)sharedInstance
{
    static ReceivedJSNotication *instance;
    
    @synchronized(self)
    {
        if (!instance)
        {
            instance = [[ReceivedJSNotication alloc] init];
        }
    }
    return instance;
}

- (void)createWithResponseObject:(NSDictionary *)responseObject menthod:(NSString *)menthod delegate:(id<ReceivedJSNoticationDelegate>)delegate datacallBack:(dataCallback)datacallbackto
{
    
    
//    NSLog(@"选择执行的menthod:%@",responseObject);
    if (![responseObject isKindOfClass:[NSDictionary class]] ){
        
        //        NSDictionary* responseDic = [NSDictionary dictionaryWithDictionary:responseObject];
        self.delegate = delegate;
        [self handleResponseObject:nil menthod:menthod callBack:^(id callBackData1) {
            datacallbackto(callBackData1);
        }];
    }
    else
    {
        
        NSDictionary* responseDic = [NSDictionary dictionaryWithDictionary:responseObject];
        self.delegate = delegate;
        [self handleResponseObject:responseDic menthod:menthod callBack:^(id callBackData1) {
            datacallbackto(callBackData1);
        }];
    }
    
}

- (void)handleResponseObject:(NSDictionary *)responseDic menthod:(NSString *)menthod callBack:(dataCallback1)callback
{
    
    UIViewController *view = [self.delegate sendViewControllerToHandle];
    NSLog(@"---------------------现在执行的方法menthod:%@", menthod);

    
    if ([menthod isEqualToString:@"Window.open"])
    {
        WindowsOpenPage *winOpenpage = [[WindowsOpenPage alloc] initWithDictionary:responseDic];
        if(winOpenpage.content)
        {
            WindowsWebviewViewController *winWeb =  [[WindowsWebviewViewController alloc]initWithWindowsObject:winOpenpage];
            winWeb.isFull = YES;
            [self AnimationMoveDirectionWithView:winWeb.view direction:winOpenpage.slide];
            view.navigationController.hidesBottomBarWhenPushed = YES;
            [view.navigationController pushViewController:winWeb animated:YES];
        }
    }
    else if ([menthod isEqualToString:@"Camera"])
    {
        NSString *str;
        if (responseDic) {
            str = responseDic[@"type"];
        }else{
            return;
        }

        if ([str isEqualToString:@"PHOTO"]) {
            NSLog(@"take photo");
            //   [self takingPictures];
            [[VDCameraAndPhotoTool shareInstance] showCameraInViewController:view andFinishBack:^(UIImage *image,NSString *videoPath) {
                if (videoPath) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObject:videoPath forKey:@"path"];
                    callback(dict);
                }

                            }];

        } else if ([str isEqualToString:@"IMAGE"]){
            NSLog(@"choose photo");
            //   [self selectPhotoAlbumPhotos];
            [[VDCameraAndPhotoTool shareInstance] showPhotoInViewController:view andFinishBack:^(UIImage *image,NSString *videoPath) {
                
                if (videoPath) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObject:videoPath forKey:@"path"];
                    callback(dict);
                }

                
            }];

        }else if ([str isEqualToString:@"VIDEO"]){
            NSLog(@"take video");
            //  [self takingShooting];
            [[VDCameraAndPhotoTool shareInstance] showVideoInViewController:view andFinishBack:^(UIImage *image,NSString *videoPath) {
                
                if (videoPath) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObject:videoPath forKey:@"path"];
                    callback(dict);
                                    }
                
            }];

            
        }else{
            NSLog(@"start scan");
           
            ScanCodeViewController *scan = [ScanCodeViewController new];
            scan.isJSCallBack = YES;
            scan.myBlock = ^(id data) {
//                NSLog(@"扫码结果第一次回调——————>%@",data);
                NSDictionary *dict = [NSDictionary dictionaryWithObject:data forKey:@"result"];
                callback(dict);
            };
            [view.navigationController pushViewController:scan animated:YES];
        }                                                                
        
    }
    else if ([menthod isEqualToString:@"MyNative.api"])
    {
        NSLog(@"-----api %@",responseDic);
//        [view.navigationController popViewControllerAnimated:YES];
//       [self.delegate performSelector:@selector(callBackMenthod:) withObject:responseDic];
    }
    else if ([menthod isEqualToString:@"Window.close"])
    {
        [view.navigationController popViewControllerAnimated:YES];
        //        [self.delegate performSelector:@selector(callBackMenthod:) withObject:responseDic];
    }
    else if ([menthod isEqualToString:@"Window.back"])
    {
        [view.navigationController popViewControllerAnimated:YES];
        
        //        [self.delegate performSelector:@selector(callBackMenthod:) withObject:responseDic];
    }
    else if ([menthod isEqualToString:@"Window.refresh"])
    {
        
        [self.delegate performSelector:@selector(refreshView:) withObject:responseDic];
    }
    else if ([menthod isEqualToString:@"Window.dialog"])
    {
        [self.delegate performSelector:@selector(callBackMenthod:) withObject:responseDic];
    }
    else if ([menthod isEqualToString:@"Window.showpop"])
    {
//        NSLog(@"------pop>>>%@",responseDic);
        [self.delegate performSelector:@selector(showPopverView:) withObject:responseDic];
    }
    else if ([menthod isEqualToString:@"Window.openKeyboard"])
    {
        [self.delegate performSelector:@selector(jsNoticationWithData:) withObject:@{@"name":@"Window.openKeyboard"}];
    }
    else if ([menthod isEqualToString:@"Window.closeKeyboard"])
    {
       [self.delegate performSelector:@selector(jsNoticationWithData:) withObject:@{@"name":@"Window.closeKeyboard"}];
             }
    else if ([menthod isEqualToString:@"Window.callbackfun"])
    {
        
//        [self.delegate performSelector:@selector(callBackFun:) withObject:responseDic];
    }
    
    
    
    
    //POS
    else if ([menthod isEqualToString:@"Window.addDataToLCD"])
    {
        [self.delegate performSelector:@selector(jsNoticationWithData:) withObject:responseDic];
    }
    else if ([menthod isEqualToString:@"Window.updataLCDData"])
    {
        [self.delegate performSelector:@selector(jsNoticationWithData:) withObject:responseDic];
    }
    else if ([menthod isEqualToString:@"Window.deleteLCDData"])
    {
        [self.delegate performSelector:@selector(jsNoticationWithData:) withObject:responseDic];
    }
    else if ([menthod isEqualToString:@"Window.clearLCDData"])
    {
        [self.delegate performSelector:@selector(jsNoticationWithData:) withObject:responseDic];
    }
    else if ([menthod isEqualToString:@"Window.openCashBox"])
    {
        [self.delegate performSelector:@selector(jsNoticationWithData:) withObject:responseDic];
    }
    else if ([menthod isEqualToString:@"Window.printReceipt"])
    {
        [self.delegate performSelector:@selector(jsPrintLitterWithData:) withObject:responseDic];
    }
    else if ([menthod isEqualToString:@"Window.printSortingLabel"])
    {
        [self.delegate performSelector:@selector(jsPrintWithData:) withObject:responseDic];
        
    }
    else if ([menthod isEqualToString:@"Window.openBalance"])
    {
        
    }
    else if ([menthod isEqualToString:@"Window.openBalanceSorting"])
    {
        
        
        WindowsOpenPage *winOpenpage = [[WindowsOpenPage alloc] initWithDictionary:responseDic];
        if(winOpenpage.content)
        {
            WeighingandsortingViewController *winWeb =  [[WeighingandsortingViewController alloc] initWithWindowsObject:winOpenpage];
            //  winWeb.isFull = YES;
            [self AnimationMoveDirectionWithView:winWeb.view direction:winOpenpage.slide];
            view.navigationController.hidesBottomBarWhenPushed = YES;
            [view.navigationController pushViewController:winWeb animated:YES];
        }
    }
    
    else if ([menthod isEqualToString:@"selectSortingGoods"])
    {
        [self.delegate performSelector:@selector(jsSelectSortingGoodsWithData:) withObject:responseDic];
    }
    
    else if ([menthod isEqualToString:@"ensureWeight"])
    {
        [self.delegate performSelector:@selector(jsEnsureWeightWithData:) withObject:responseDic];
       
    }
    
    else if ([menthod isEqualToString:@"clearSorting"])
    {
        [self.delegate performSelector:@selector(jsClearSortingWithData:) withObject:responseDic];
    }
   
    else if ([menthod isEqualToString:@"Window.openBalanceStorage"])
    {
        
        NSLog(@"winopenb");
        WindowsOpenPage *winOpenpage = [[WindowsOpenPage alloc] initWithDictionary:responseDic];
        if(winOpenpage.content)
        {
            RukuViewController *winWeb =  [[RukuViewController alloc] initWithWindowsObject:winOpenpage];
            //  winWeb.isFull = YES;
            [self AnimationMoveDirectionWithView:winWeb.view direction:winOpenpage.slide];
            view.navigationController.hidesBottomBarWhenPushed = YES;
            [view.navigationController pushViewController:winWeb animated:YES];
        }
        
    }
    else if ([menthod isEqualToString:@"selectStorageGoods"])
    {
        [self.delegate performSelector:@selector(jsSelectSortingGoodsWithData:) withObject:responseDic];
    }
    else if ([menthod isEqualToString:@"clearStorage"])
    {
        [self.delegate performSelector:@selector(jsClearSortingWithData:) withObject:responseDic];
    }
    else if ([menthod isEqualToString:@"Window.selectGoods"])
    {
        [self.delegate performSelector:@selector(jsNoticationWithData:) withObject:responseDic];
    }
    else if ([menthod isEqualToString:@"Window.showMainUITOLCD"])
    {
        [self.delegate performSelector:@selector(jsNoticationWithData:) withObject:responseDic];
    }
    else if ([menthod isEqualToString:@"Window.hideMainUI"])
    {
        [self.delegate performSelector:@selector(jsNoticationWithData:) withObject:responseDic];
    }
    else if ([menthod isEqualToString:@"jumpToLogin"])
    {
        [self.delegate performSelector:@selector(jsNoticationWithData:) withObject:@{@"name":@"jumpToLogin"}];
    }
  
    else if ([menthod isEqualToString:@"Window.balanceGoodsCompute"])
    {
        [self.delegate performSelector:@selector(jsNoticationWithData:) withObject:responseDic];
    }
    else if ([menthod isEqualToString:@"Oauth.success"])
    {
//        [self.delegate performSelector:@selector(jsNoticationWithData:) withObject:responseDic];
    }
    else if ([menthod isEqualToString:@"Oauth.fail"])
    {
//        [self.delegate performSelector:@selector(jsNoticationWithData:) withObject:responseDic];
    }

    else if ([menthod isEqualToString:@"GetPosition"])
    {
        [self.delegate performSelector:@selector(jsNoticationWithData:) withObject:@{@"name":@"GetPosition"}];
    }
    else if ([menthod isEqualToString:@"getAddress"])
    {
    
           }
    else if ([menthod isEqualToString:@"toNavigation"])
    {
            }
    else if ([menthod isEqualToString:@"speaking"])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"speaking" forKey:@"name"];
        [dict setObject:[NSString stringWithFormat:@"%@",responseDic[@"speak"]] forKey:@"speak"];

        [self.delegate performSelector:@selector(jsNoticationWithData:) withObject:dict];
    }
    else if ([menthod isEqualToString:@"voiceToWord"])
    {
        
         [self.delegate performSelector:@selector(jsNoticationWithData:) withObject:@{@"name":@"voiceToWord"}];

    }

    else
    {
        [self.delegate performSelector:@selector(extendJSWithData:Data:) withObject:menthod withObject:responseDic ];
    }

}

- (void) AnimationMoveDirectionWithView:(UIView *)view direction:(NSString *)direction
{
    if ([direction isEqualToString:LEFT])
    {
        [AnimationEffect animationMoveLeft:view];
    }
    else if ([direction isEqualToString:RIGHT])
    {
        [AnimationEffect animationMoveRight:view];
    }
    else if ([direction isEqualToString:UP])
    {
        [AnimationEffect animationMoveDown:view duration:0.35];
    }
    else if ([direction isEqualToString:BOTTOM])
    {
        [AnimationEffect animationMoveUp:view duration:0.35];
    }
    
}

@end
