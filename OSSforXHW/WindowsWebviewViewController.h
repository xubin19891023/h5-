//
//  WindowsWebviewViewController.h
//  乡货网
//
//  Created by Bill on 2017/5/9.
//  Copyright © 2017年 Bill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridgeBase.h"
#import "ThirdActhion.h"
@class WindowsOpenPage;

@interface WindowsWebviewViewController : UIViewController

@property (nonatomic,strong) NSString    *callBackJS;
@property (nonatomic,strong) NSString    *callBackScanResult;
@property (nonatomic,assign) BOOL  isFull;


- (id) initWithWindowsObject:(WindowsOpenPage *)obj;//打开的新页面
- (id) initWithWindowsObjectNone:(NSString *)url;//带url
- (id) initWithWindowsObjectWithUrl:(NSString *)url title:(NSString *)title;
- (void) reloadWebview:(NSString *)url;
-(void) extendJSregisterHandler:(NSString*)apiStr delegate:(id)delegate;

@end
