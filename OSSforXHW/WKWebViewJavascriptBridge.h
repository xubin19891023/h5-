//
//  WKWebViewJavascriptBridge.h
//

//

//#if (__MAC_OS_X_VERSION_MAX_ALLOWED > __MAC_10_9 || __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1)
//#define supportsWKWebKit
//#endif
#define supportsWKWebKit

#if defined(supportsWKWebKit )

#import <Foundation/Foundation.h>
#import "WebViewJavascriptBridgeBase.h"
#import <WebKit/WebKit.h>

@interface WKWebViewJavascriptBridge : NSObject<WKNavigationDelegate, WebViewJavascriptBridgeBaseDelegate>

+ (instancetype)bridgeForWebView:(WKWebView*)webView handler:(WVJBHandler)handler;
+ (instancetype)bridgeForWebView:(WKWebView*)webView webViewDelegate:(NSObject<WKNavigationDelegate>*)webViewDelegate handler:(WVJBHandler)handler;
+ (instancetype)bridgeForWebView:(WKWebView*)webView webViewDelegate:(NSObject<WKNavigationDelegate>*)webViewDelegate handler:(WVJBHandler)handler resourceBundle:(NSBundle*)bundle;
+ (void)enableLogging;

- (void)send:(id)message;
- (void)send:(id)message responseCallback:(WVJBResponseCallback)responseCallback;
- (void)registerHandler:(NSString*)handlerName handler:(WVJBHandler)handler;
- (void)callHandler:(NSString*)handlerName;
- (void)callHandler:(NSString*)handlerName data:(id)data;
// camera
- (void)camera:(NSString *)handlerName data:(id)data responseCallback:(WVJBResponseCallback)responseCallback;
// camera
- (void)camera:(NSString *)handlerName data:(id)data;
//window
- (void)windows:(NSString *)handlerName data:(id)data;

//获取位置
- (void)geolocation:(NSString *)handlerName data:(id)data;
//授权
- (void)oauth:(NSString *)handlerName data:(id)data;
//pos界面
- (void)business:(NSString *)handlerName data:(id)data;

- (void)callHandler:(NSString*)handlerName data:(id)data responseCallback:(WVJBResponseCallback)responseCallback;
- (void)reset;

@end

#endif
