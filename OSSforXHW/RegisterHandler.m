//
//  RegisterHandler.m
//  乡货网
//
//  Created by Bill on 2017/5/10.
//  Copyright © 2017年 Bill. All rights reserved.
//

#import "RegisterHandler.h"
#import "ReceivedJSNotication.h"
#import <AVFoundation/AVFoundation.h>
//#import <AVFoundation/AVSpeechSynthesis.h>
#import "JSONKit.h"
@implementation RegisterHandler


+ (RegisterHandler *)sharedInstance
{
    RegisterHandler *instance;
    
    @synchronized(self)
    {
        if (!instance)
        {
            instance = [[RegisterHandler alloc] init];
        }
    }
    return instance;
}

- (WKWebViewJavascriptBridge *) registerJavascriptBridgeWithWebview:(WKWebView*)webView delegate:(id<WKNavigationDelegate,WKUIDelegate>) delegate
{
    [WKWebViewJavascriptBridge enableLogging];
    
    WKWebViewJavascriptBridge *bridge = [WKWebViewJavascriptBridge bridgeForWebView:webView webViewDelegate:delegate handler:^(id data, WVJBResponseCallback responseCallback)
                                         {
//                                             NSLog(@"ObjC received message from JS: %@", data);
//                                             responseCallback(@"Response for message from ObjC");
                                         }];
    return bridge;
}
- (void)evaluateJavaScriptWith:(NSString *)scriptString webview:(WKWebView*)wkWebView
{
    if (scriptString == nil || scriptString.length == 0)
    {
        return;
    }
    else
    {
        
        [wkWebView evaluateJavaScript:scriptString completionHandler:^(id _Nullable returnValue, NSError * _Nullable error) {
            //            MTDetailLog(@"evaluateJavaScript result : \n error : %@  \nreturnValue:%@",error,returnValue);
        }];
    }
}

////扫码结果回调
//- (void)scanResultCallback:(WKWebViewJavascriptBridge *)bridge scanResult:(NSString *)str
//{
////    NSLog(@"走了这个方法");
////    [bridge send:str responseCallback:^(id response) {
////        NSLog(@"scanResult got response: %@", response);
////    }];
//  
//}
//- (void)callhandlerWithBridge:(WKWebViewJavascriptBridge *)bridge delegate:(id<ReceivedJSNoticationDelegate>)delegate methodis:(NSString *)method callBackData:(id)data {
//
//    [bridge callHandler:method data:data responseCallback:^(id responseData) {
//
//        }];
//}


//注册JS方法
- (void)registerHandlerwithBridge:(WKWebViewJavascriptBridge *)bridge delegate:(id<ReceivedJSNoticationDelegate>) delegate
{
    
    //相机相关
    [bridge registerHandler:@"Camera" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Camera" delegate:delegate datacallBack:^(id callBackData) {
            responseCallback(callBackData);
        }];
        
    }];
    
    //APi相关
    [bridge registerHandler:@"MyNative.api" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"MyNative.api" delegate:delegate datacallBack:nil];
        
        responseCallback(@"这是一个回调");
    }];
    
    //打开新页面
    [bridge registerHandler:@"Window.open" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.open" delegate:delegate datacallBack:nil];
        
        responseCallback(@"");
    }];
    
    //关闭页面
    [bridge registerHandler:@"Window.close" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.close" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test Window.close");
    }];
    
    //返回上一级
    [bridge registerHandler:@"Window.back" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.back" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test Window.back");
    }];
    
    //刷新页面
    [bridge registerHandler:@"Window.refresh" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.refresh" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test Window.refresh");
    }];
    
    //弹窗
    [bridge registerHandler:@"Window.dialog" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.dialog" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test Window.dialog");
    }];
    
    //泡泡弹出
    [bridge registerHandler:@"Window.showpop" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.showpop" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test Window.showpop");
    }];
    
    //打开键盘
    [bridge registerHandler:@"Window.openKeyboard" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.openKeyboard" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test Window.openKeyboard");
    }];
    
    //关闭键盘
    [bridge registerHandler:@"Window.closeKeyboard" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.closeKeyboard" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test Window.closeKeyboard");
    }];
    
    //获取父界面方法
    [bridge registerHandler:@"Window.callbackfun" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.callbackfun" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test Window.callbackfun");
    }];
    
    //选择了商品
    [bridge registerHandler:@"Window.balanceGoodsCompute" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.balanceGoodsCompute" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test Window.balanceGoodsCompute");
    }];
   
    //跳转到登录界面
    [bridge registerHandler:@"jumpToLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"jumpToLogin" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test jumpToLogin");
    }];
   
   //获取当前位置经纬度
    [bridge registerHandler:@"GetPosition" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"GetPosition" delegate:delegate datacallBack:^(id callBackData) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                
                if (defaults) {
                    
                    NSString *log = [defaults valueForKey:@"longitude"];
                    NSString *lat = [defaults valueForKey:@"latitude"];
                    //            NSLog(@"%@-----%@",log,lat);
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:log,@"longitude",lat,@"latitude", nil];
                    responseCallback(dict);
                    [defaults removeObjectForKey:@"latitude"];
                    [defaults removeObjectForKey:@"longitude"];
                    
                }
            });
        }];
    }];
    
//    获取token
    [bridge registerHandler:@"Oauth.getAccessToken" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (defaults) {
            
            NSString *token = [defaults valueForKey:@"token"];
            //            NSLog(@"%@-----%@",log,lat);
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:token,@"token",nil];
            responseCallback(dict);
        }
    }];
    
//    授权成功
    [bridge registerHandler:@"Oauth.success" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
       
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Oauth.success" delegate:delegate datacallBack:nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:data[@"token"]forKey:@"token"];
        [defaults synchronize];
    }];
    
//    
//    [bridge registerHandler:@"Oauth.fail" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"testObjcCallback called: %@", data);
//        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Oauth.fail" delegate:delegate datacallBack:nil];
//        
//        responseCallback(@"Response from testObjcCallback---for Bill test Oauth.fail");
//    }];
//    
//
    
    //pos，添加数据到分屏
    [bridge registerHandler:@"Window.addDataToLCD" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.addDataToLCD" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test Window.addDataToLCD");
    }];
    
//    更新分屏数据
    [bridge registerHandler:@"Window.updataLCDData" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.updataLCDData" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test Window.updataLCDData");
    }];
    
//    删除分屏数据
    [bridge registerHandler:@"Window.deleteLCDData" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.deleteLCDData" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test Window.deleteLCDData");
    }];
    
//    清空分屏数据
    [bridge registerHandler:@"Window.clearLCDData" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.clearLCDData" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test Window.clearLCDData");
    }];
    
//    开钱箱
    [bridge registerHandler:@"Window.openCashBox" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.openCashBox" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test Window.openCashBox");
    }];
    
//    打印小票
    [bridge registerHandler:@"Window.printReceipt" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.printReceipt" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test Window.printReceipt");
    }];
    
//    打开称重界面
    [bridge registerHandler:@"Window.openBalance" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.openBalance" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test Window.openBalance");
    }];
    
// 选择商品
    [bridge registerHandler:@"Window.selectGoods" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.selectGoods" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test Window.selectGoods");
    }];
    
//主屏投放到分屏
    [bridge registerHandler:@"Window.showMainUITOLCD" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.showMainUITOLCD" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test Window.showMainUITOLCD");
    }];
    
//    取消主屏投放
    [bridge registerHandler:@"Window.hideMainUI" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.hideMainUI" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test Window.hideMainUI");
    }];
    
//    打印标签
    [bridge registerHandler:@"Window.printSortingLabel" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.printSortingLabel" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test Window.printLabel");
    }];
    
//    扩展测试
        [bridge registerHandler:@"extend" handler:^(id data, WVJBResponseCallback responseCallback)
         {
             NSLog(@"testObjcCallback called: %@", data);
             [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"extend" delegate:delegate datacallBack:^(id callBackData) {
                 
             }];
    
             responseCallback(@"Response from extendJSregisterHandler");
         }];
    
//    文字转语音
    [bridge registerHandler:@"speaking" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"speaking" delegate:delegate datacallBack:^(id callBackData) {
                    
                }];
        
        responseCallback(@"Response from testObjcCallback---for Bill test speaking");
    }];
    
    
//    语音转文字
    [bridge registerHandler:@"voiceToWord" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"voiceToWord" delegate:delegate datacallBack:^(id callBackData) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                if (defaults) {
                    
                    NSString *log = [defaults valueForKey:@"yuyinresult"];
                    //            NSLog(@"%@-----%@",log,lat);
                    responseCallback(log);
                    [defaults removeObjectForKey:@"yuyinresult"];
                    
                    
                }
            });
        }];
//
        
    }];
 
//    获取当前地址
    [bridge registerHandler:@"getAddress" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"getAddress" delegate:delegate datacallBack:^(id callBackData) {
             responseCallback(callBackData);
        }];
    }];
    
//   导航到某地
    [bridge registerHandler:@"toNavigation" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"toNavigation" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test toNavigation");
    }];
    
//    打开称重分拣界面
    [bridge registerHandler:@"Window.openBalanceSorting" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.openBalanceSorting" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test Window.openBalanceSorting");
    }];
    
    
//    称重分拣页面选择商品
    [bridge registerHandler:@"selectSortingGoods" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"selectSortingGoods" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test selectSortingGoods");
    }];
    
    //称重分拣确定本次称重
    [bridge registerHandler:@"ensureWeight" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"ensureWeight" delegate:delegate datacallBack:nil];
       
    }];
    
    //称重分拣重置参数
    [bridge registerHandler:@"clearSorting" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"clearSorting" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test clearSorting");
    }];
    
//    打开称重出入库有界面
    [bridge registerHandler:@"Window.openBalanceStorage" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.openBalanceStorage" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test Window.openBalanceStorage");
    }];

//    称重出入库有界面选择商品
    [bridge registerHandler:@"selectStorageGoods" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"selectStorageGoods" delegate:delegate datacallBack:nil];
        
    }];
    
//    出入库页面重置参数
    [bridge registerHandler:@"clearStorage" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"clearStorage" delegate:delegate datacallBack:nil];
        
        responseCallback(@"Response from testObjcCallback---for Bill test clearStorage");
    }];
    
    //    是否自动打印
    [bridge registerHandler:@"Window.getOSSBasicSettings" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
//        [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:@"Window.getOSSBasicSettings" delegate:delegate datacallBack:nil];
       
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (defaults) {
            
            NSString *zidongdayin = [defaults valueForKey:@"zidongdayin"];
            //            NSLog(@"%@-----%@",log,lat);
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:zidongdayin,@"outoPrint",nil];
            responseCallback(dict);
        }
    }];
    
}
@end
