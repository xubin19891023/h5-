//
//  ViewController.h
//  XHWBaseAPI
//
//  Created by iOS on 2017/9/13.
//  Copyright © 2017年 XHW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface ViewController : UIViewController

@property (nonatomic ,strong) WKWebView *webView;
@property (nonatomic,strong) NSString    *callBackJS;

@end

