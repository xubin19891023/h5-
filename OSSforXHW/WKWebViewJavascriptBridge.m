//
//  WKWebViewJavascriptBridge.m
//

//


#import "WKWebViewJavascriptBridge.h"

#if defined(supportsWKWebKit)

@implementation WKWebViewJavascriptBridge {
    WKWebView* _webView;
    id _webViewDelegate;
    long _uniqueId;
    WebViewJavascriptBridgeBase *_base;
}

/* API
 *****/

+ (void)enableLogging { [WebViewJavascriptBridgeBase enableLogging]; }

+ (instancetype)bridgeForWebView:(WKWebView*)webView handler:(WVJBHandler)handler {
    return [self bridgeForWebView:webView webViewDelegate:nil handler:handler];
}

+ (instancetype)bridgeForWebView:(WKWebView*)webView webViewDelegate:(NSObject<WKNavigationDelegate>*)webViewDelegate handler:(WVJBHandler)messageHandler {
    return [self bridgeForWebView:webView webViewDelegate:webViewDelegate handler:messageHandler resourceBundle:nil];
}

+ (instancetype)bridgeForWebView:(WKWebView*)webView webViewDelegate:(NSObject<WKNavigationDelegate>*)webViewDelegate handler:(WVJBHandler)messageHandler resourceBundle:(NSBundle*)bundle
{
    WKWebViewJavascriptBridge* bridge = [[self alloc] init];
    [bridge _setupInstance:webView webViewDelegate:webViewDelegate handler:messageHandler resourceBundle:bundle];
    [bridge reset];
    return bridge;
}

- (void)send:(id)data {
    [self send:data responseCallback:nil];
}

// camera
- (void)camera:(NSString *)handlerName data:(id)data {
    [self callHandler:handlerName data:data responseCallback:nil];
}

- (void)camera:(NSString *)handlerName data:(id)data responseCallback:(WVJBResponseCallback)responseCallback {
//    [_base sendData:data responseCallback:responseCallback handlerName:handlerName];
    [self callHandler:handlerName data:data responseCallback:responseCallback];

}

//window
- (void)windows:(NSString *)handlerName data:(id)data {
    [self callHandler:handlerName data:data responseCallback:nil];
}

//获取位置
- (void)geolocation:(NSString *)handlerName data:(id)data {
    [self callHandler:handlerName data:data responseCallback:nil];
}

//授权
- (void)oauth:(NSString *)handlerName data:(id)data {
    [self callHandler:handlerName data:data responseCallback:nil];
}

//pos界面
- (void)business:(NSString *)handlerName data:(id)data {
    [self callHandler:handlerName data:data responseCallback:nil];
}

- (void)send:(id)data responseCallback:(WVJBResponseCallback)responseCallback {
    [_base sendData:data responseCallback:responseCallback handlerName:nil];
}

- (void)callHandler:(NSString *)handlerName {
    [self callHandler:handlerName data:nil responseCallback:nil];
}

- (void)callHandler:(NSString *)handlerName data:(id)data {
    [self callHandler:handlerName data:data responseCallback:nil];
}

- (void)callHandler:(NSString *)handlerName data:(id)data responseCallback:(WVJBResponseCallback)responseCallback {
    [_base sendData:data responseCallback:responseCallback handlerName:handlerName];
}

- (void)registerHandler:(NSString *)handlerName handler:(WVJBHandler)handler {
    _base.messageHandlers[handlerName] = [handler copy];
}

- (void)reset {
    [_base reset];
}

/* Internals
 ***********/

- (void)dealloc {
    _base = nil;
    _webView = nil;
    _webViewDelegate = nil;
    _webView.navigationDelegate = nil;
}


/* WKWebView Specific Internals
 ******************************/

- (void) _setupInstance:(WKWebView*)webView webViewDelegate:(id<WKNavigationDelegate>)webViewDelegate handler:(WVJBHandler)messageHandler resourceBundle:(NSBundle*)bundle{
    _webView = webView;
    _webViewDelegate = webViewDelegate;
    _webView.navigationDelegate = self;
    _base = [[WebViewJavascriptBridgeBase alloc] initWithHandler:(WVJBHandler)messageHandler resourceBundle:(NSBundle*)bundle];
    _base.delegate = self;
}


- (void)WKFlushMessageQueue {
    [_webView evaluateJavaScript:[_base webViewJavascriptFetchQueyCommand] completionHandler:^(NSString* result, NSError* error) {
        [_base flushMessageQueue:result];
    }];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (webView != _webView) { return; }


    NSLog(@"finish");
    _base.numRequestsLoading--;
    
//    NSRange range =[[webView.URL absoluteString] rangeOfString:@"home/countryHistory.do"];
//    if (range.location != NSNotFound)
//    {
        if (_base.numRequestsLoading == 0) {
            [webView evaluateJavaScript:[_base webViewJavascriptCheckCommand] completionHandler:^(NSString *result, NSError *error) {
                [_base injectJavascriptFile:![result boolValue]];
            }];
        }
//    }
    [self _evaluateJavascript:@"document.documentElement.style.webkitUserSelect='none';"];
    
    [self _evaluateJavascript:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [strongDelegate webView:webView didFinishNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"didCommitNavigation");
//    NSRange range =[[webView.URL absoluteString] rangeOfString:@"home/countryHistory.do"];
//    if (range.location == NSNotFound)
//    {
    
//        [webView evaluateJavaScript:[_base webViewJavascriptCheckCommand] completionHandler:^(NSString *result, NSError *error) {
//            [_base injectJavascriptFile:![result boolValue]];
//        }];
//    }

}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    // 获取cookie,并设置到本地
    NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
    decisionHandler(WKNavigationResponsePolicyAllow);
    
}
- (void)webView:(WKWebView *)webView
decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (webView != _webView) { return; }
    NSURL *url = navigationAction.request.URL;
    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    NSLog(@"------>>>>------url:%@",[url absoluteString]);
    
    
    NSRange range =[[url absoluteString] rangeOfString:@"home.do"];
    NSRange range1 =[[url absoluteString] rangeOfString:@"seach.do"];
    NSRange range2 =[[url absoluteString] rangeOfString:@"category/type.do"];
    NSRange range3 =[[url absoluteString] rangeOfString:@"showMyNear.do"];
    NSRange range4 =[[url absoluteString] rangeOfString:@"home/country.do"];
    NSRange range5 =[[url absoluteString] rangeOfString:@"home/countryHistory.do"];
    
    NSRange range6 =[[url absoluteString] rangeOfString:@"http://oss.testxianghuowang.me:8081/m/center.do"] ;
    NSRange range7 =[[url absoluteString] rangeOfString:@"http://open.testxianghuowang.me:8888/authorize.do"];
    
    NSRange range8 =[[url absoluteString] rangeOfString:@"http://sso.xianghuo.me/center.do"] ;
//    NSRange range9 =[[url absoluteString] rangeOfString:@"https://open.xianghuo.me/authorize.do"];
      NSRange range10 =[[url absoluteString] rangeOfString:@"http://open.xianghuo.me/authorize.do"];
//    
//    NSLog(@"----------rang8---%ld",range8.location);
//    NSLog(@"----------rang9---%ld",range9.location);


//    if((range8.location != NSNotFound)&&(range9.location == NSNotFound)&&(range10.location == NSNotFound))
        if((range8.location != NSNotFound)&&(range10.location == NSNotFound))
    {
        NSMutableDictionary *dict  = [NSMutableDictionary new];
        
        [dict setValue:@"NO" forKey:@"hide"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TitleHideNot" object:dict];
    }
    

    
    if((range6.location != NSNotFound)&&(range7.location == NSNotFound))
    {
        NSMutableDictionary *dict  = [NSMutableDictionary new];
        
        [dict setValue:@"NO" forKey:@"hide"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TitleHideNot" object:dict];
    }
    
    if((range3.location != NSNotFound)||(range4.location != NSNotFound)||(range5.location != NSNotFound)||(range.location != NSNotFound))
    {
        [webView evaluateJavaScript:[_base webViewJavascriptCheckCommand] completionHandler:^(NSString *result, NSError *error) {
            [_base injectJavascriptFile:![result boolValue]];
        }];
    }

    if(range.location != NSNotFound)
    {
        NSMutableDictionary *dict  = [NSMutableDictionary new];
        
        [dict setValue:@"NO" forKey:@"hide"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarHideNot" object:dict];
    }
    else if ((range1.location != NSNotFound)||(range2.location != NSNotFound))
    {
        NSMutableDictionary *dict  = [NSMutableDictionary new];
        
        [dict setValue:@"YES" forKey:@"hide"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarHideNot" object:dict];
    }
    
    if ([_base isCorrectProcotocolScheme:url]) {
        if ([_base isCorrectHost:url]) {
            [self WKFlushMessageQueue];
        } else {
            [_base logUnkownMessage:url];
        }

        [webView stopLoading];
    }
    

    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
        [_webViewDelegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if (webView != _webView) { return; }
    
    
    _base.numRequestsLoading++;
    

    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didStartProvisionalNavigation:)]) {
        [strongDelegate webView:webView didStartProvisionalNavigation:navigation];
    }
}


- (void)webView:(WKWebView *)webView
didFailNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if (webView != _webView) { return; }
    
    _base.numRequestsLoading--;
    
    __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didFailNavigation:withError:)]) {
        [strongDelegate webView:webView didFailNavigation:navigation withError:error];
    }
}

- (NSString*) _evaluateJavascript:(NSString*)javascriptCommand
{
    [_webView evaluateJavaScript:javascriptCommand completionHandler:nil];
    return NULL;
}


@end


#endif
