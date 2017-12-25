//
//  AppDelegate.h
//  OSSforXHW
//
//  Created by iOS on 2017/9/13.
//  Copyright © 2017年 XHW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectViewController.h"
#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define H5Url  @"http://m.xianghuo.me"  //http://m.testxianghuowang.me:8083


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ConnectViewController *mConnBLE;
@property (nonatomic , assign) BOOL isReachable;

@end

