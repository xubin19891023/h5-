//
//  RegisterHandler.h
//  乡货网
//
//  Created by Bill on 2017/5/10.
//  Copyright © 2017年 Bill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKWebViewJavascriptBridge.h"
#import "ReceivedJSNotication.h"
#import <WebKit/WebKit.h>


@interface RegisterHandler : NSObject




//单例
+ (RegisterHandler *)sharedInstance;
//初始化Bridge
- (WKWebViewJavascriptBridge *) registerJavascriptBridgeWithWebview:(WKWebView*)webView delegate:(id<WKNavigationDelegate,WKUIDelegate>) delegate;
//注册JS方法
- (void)registerHandlerwithBridge:(WKWebViewJavascriptBridge *)bridge delegate:(id<ReceivedJSNoticationDelegate>) delegate;
//URL拦截
- (void)evaluateJavaScriptWith:(NSString *)scriptString webview:(WKWebView*)wkWebView;
//扫码回调
//- (void)scanResultCallback:(WKWebViewJavascriptBridge *)bridge scanResult:(NSString *)str;
//- (void)callhandlerWithBridge:(WKWebViewJavascriptBridge *)bridge delegate:(id<ReceivedJSNoticationDelegate>)delegate methodis:(NSString *)method callBackData:(id)data;
@end
