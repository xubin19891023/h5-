//
//  AppDelegate.m
//  XHWBaseAPI
//
//  Created by iOS on 2017/9/4.
//  Copyright © 2017年 XHW. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Utils.h"
#import "Reachability.h"
#import "iflyMSC/IFlyMSC.h"
#import "JPUSHService.h"
#import "NSObject+BGModel.h"
#import "MessageObj.h"
#import "WZXLaunchViewController.h"
#import "HomeWebViewController.h"
#import "JSONKit.h"
#import "ScanCodeViewController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif




#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width

@interface AppDelegate ()<JPUSHRegisterDelegate>

@property (nonatomic,strong) Reachability *netConnect;
@property (nonatomic , assign) BOOL isRead;
//@property (nonatomic,strong) UITabBarController *tabbarController;
@end
#define APPID_VALUE @"59b8f370"
//#define JIGUANG_KEY @"f294eb47ebd1565a4945b2f0" 个人的
#define JIGUANG_KEY @"a4ccbda037eef791e8da983d" //公司统一的
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    
    
    //设置自动打印初始化
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults valueForKey:@"zidongdayin"]) {
        [defaults setValue:@"6" forKey:@"zidongdayin"];
        [defaults synchronize];
    }
   
    // Override point for customization after application launch.
        [NSThread sleepForTimeInterval:0.5];
    //    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    //        [self loadStartADImg];
    //蓝牙搜索注册
    self.mConnBLE = [[ConnectViewController alloc] initWithNibName:nil bundle:nil];
    //消息是否已读
    _isRead = NO;
    
    //网络测试
    NSString *urlStr = @"www.baidu.com";
    self.netConnect = [Reachability reachabilityWithHostName:urlStr];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [self.netConnect startNotifier];
    

    
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    //打开输出在console的log开关
    [IFlySetting showLogcat:YES];
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    
    
//    
//    
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
//        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
//        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
//        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
//    }
//    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        //可以添加自定义categories
//        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                                          UIUserNotificationTypeSound |
//                                                          UIUserNotificationTypeAlert)
//                                              categories:nil];
//    }
//    else {
//        //categories 必须为nil
////        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
////                                                          UIRemoteNotificationTypeSound |
////                                                          UIRemoteNotificationTypeAlert)
////                                              categories:nil];
//    }
//    [JPUSHService setupWithOption:launchOptions appKey:JIGUANG_KEY
//                          channel:@"appstore"
//                 apsForProduction:NO
//            advertisingIdentifier:nil];  // 这里是没有advertisingIdentifier的情况，有的话，大家在自行添加
//    //注册远端消息通知获取device token
//    [application registerForRemoteNotifications];
  
   
    
    
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

    [JPUSHService setupWithOption:launchOptions appKey:JIGUANG_KEY
                          channel:@"appstore"
                 apsForProduction:1
            advertisingIdentifier:nil];
    
    [JPUSHService setAlias:@"OSS" completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:1];
    NSSet * set2 = [[NSSet alloc] initWithObjects:@"SM_1",@"TA_100001", nil];
    
    [JPUSHService addTags:set2 completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        
    } seq:2];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                         @"male", @"sex",
//                         @"20", @"age",
//                         @"Tom", @"name",
//                         @"run",@"hobby", nil ];
//    
//    NSString *str = [dic JSONString];
//    
//    NSDictionary *jsondic = [Utils dictionaryWithJsonString:str];
////
//    NSLog(@"-----------alert---%@",jsondic);
    
    [self mianView];
    ViewController *controller = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    nav.navigationBarHidden = YES;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = nav;
    [self .window makeKeyAndVisible];
//    [self WZXLaunchView];
    return YES;
}

- (void)WZXLaunchView{
    
    __weak typeof(self) weakSelf = self;

//    NSString *gifImageURL = @"http://img1.gamedog.cn/2013/06/03/43-130603140F30.gif";
    
//    NSString *imageURL = @"http://img4.duitang.com/uploads/item/201410/24/20141024135636_t2854.thumb.700_0.jpeg";
    NSString *image = @"icon_noting_face@2x";
    ///设置启动页
    [WZXLaunchViewController showWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-130) ImageURL:image advertisingURL:@"http://www.xianghuo.me" timeSecond:3 hideSkip:YES imageLoadGood:^(UIImage *image, NSString *imageURL) {
        /// 广告加载结束
//        NSLog(@"%@ %@",image,imageURL);
        
    } clickImage:^(UIViewController *WZXlaunchVC){
        
        /// 点击广告
        
        //2.在webview中打开
        HomeWebViewController *VC = [[HomeWebViewController alloc] init];
        VC.urlStr = @"http://www.xianghuo.me";
        VC.title = @"广告";
        VC.AppDelegateSele= -1;
        
        VC.WebBack= ^(){
            //广告展示完成回调,设置window根控制器
            
            ViewController *vc = [[ViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            
            weakSelf.window.rootViewController = nav;
        };
        
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:VC];
        
        [WZXlaunchVC presentViewController:nav animated:YES completion:nil];
        
    } theAdEnds:^{
        
        
        //广告展示完成回调,设置window根控制器
        
        ViewController *controller = [[ViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        nav.navigationBarHidden = YES;
        weakSelf.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        weakSelf.window.backgroundColor = [UIColor whiteColor];
        weakSelf.window.rootViewController = nav;
        [weakSelf.window makeKeyAndVisible];
        
    }];
    
    
}

-(void) mianView
{
    [[UINavigationBar appearance] setBarTintColor:[Utils getColor:@"0786e7"]];
    //设置导航条文字颜色 白色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置按钮文字颜色 白色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //设置导航栏按钮字体大小
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
}

-(void)reachabilityChanged:(NSNotification *)note{
//    //设置了缓冲区，在1秒内多次触发这个函数 将会只执行最后一次，，这里有时候一次要调用两下。
//    //取消的函数 必须要和 传入的函数 带的值一样
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateInterfaceWithReachability) object:nil];
//    [self performSelector:@selector(updateInterfaceWithReachability) withObject:nil afterDelay:1];
    
    Reachability *currReach = [note object];
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    //对连接改变做出响应处理动作
    NetworkStatus status = [currReach currentReachabilityStatus];
    //如果没有连接到网络就弹出提醒实况
    self.isReachable = YES;
    if(status == NotReachable){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接异常" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        self.isReachable = NO;
        return;
    }
    if (status==ReachableViaWiFi||status==ReachableViaWWAN) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接信息" message:@"网络连接正常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//         [alert show];
        self.isReachable = YES;
    }
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication alloc] setApplicationIconBadgeNumber:0];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [[UNUserNotificationCenter alloc] removeAllPendingNotificationRequests];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



// 获取deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
  
    
}

//注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support APP处于前台接到通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionSound); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    [self saveToBGFMDB:userInfo];
    NSLog(@"--111111--前台--%@",userInfo);

}

// iOS 10 Support     点击了就会走这个
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    NSLog(@"---222222---后台---%@",userInfo);
    
    [self saveToBGFMDB:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"---iOS7才支持---%@",userInfo);
    [self saveToBGFMDB:userInfo];
    

}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    NSLog(@"---iOS6以下---%@",userInfo);

    [JPUSHService handleRemoteNotification:userInfo];
}
-(void) saveToBGFMDB:(NSDictionary *)userInfo{
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:userInfo[@"_j_business"] forKey:@"_j_business"];
    [dic setValue:userInfo[@"_j_msgid"] forKey:@"_j_msgid"];
    [dic setValue:userInfo[@"_j_uid"] forKey:@"_j_uid"];
    //    [dic setValue:userInfo[@"aps"][@"badge"] forKey:@"badge"];
    //    [dic setValue:userInfo[@"aps"][@"sound"] forKey:@"sound"];
    //    if (userInfo[@"aps"][@"content-available"]) {
    //        [dic setValue:userInfo[@"aps"][@"content-available"] forKey:@"content-available"];
    //
    //    }else{
    //        [dic setValue:@"无" forKey:@"content-available"];
    //    }
    if ([userInfo[@"aps"][@"alert"] isKindOfClass:[NSDictionary class]]) {
        if (userInfo[@"aps"][@"alert"][@"body"]) {
            [dic setValue:userInfo[@"aps"][@"alert"][@"body"] forKey:@"body"];
        }else{
            [dic setValue:@"无" forKey:@"body"];
        }
        if (userInfo[@"aps"][@"alert"][@"subtitle"]) {
            [dic setValue:userInfo[@"aps"][@"alert"][@"subtitle"] forKey:@"subtitle"];
        }else{
            [dic setValue:@"无" forKey:@"subtitle"];
        }
        if (userInfo[@"aps"][@"alert"][@"title"]) {
            [dic setValue:userInfo[@"aps"][@"alert"][@"title"] forKey:@"title"];
        }else{
            [dic setValue:@"无" forKey:@"title"];
        }
        
    }else {
        
//        [dic setValue:userInfo[@"aps"][@"alert"] forKey:@"body"];
      NSDictionary *jsondic = [Utils dictionaryWithJsonString:userInfo[@"aps"][@"alert"]];
        NSLog(@"----------jsondic---%@",jsondic);
        [dic setValue:jsondic[@"title"] forKey:@"title"];
        [dic setValue:jsondic[@"body"] forKey:@"body"];
        [dic setValue:jsondic[@"subtitle"] forKey:@"subtitle"];

    }
    
    [dic setValue:userInfo[@"aps"][@"category"] forKey:@"category"];
    [dic setValue:[NSString stringWithFormat:@"%d",_isRead] forKey:@"isRead"];
    [dic setValue:[Utils getCurrentTimes] forKey:@"time"];
    
    MessageObj *obj = [MessageObj bg_objectWithDictionary:dic];
    
    [obj bg_saveOrUpdate];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"YOU_GOT_AN_MESSAGE" object:nil userInfo:dic];
    
    
}
// 程序在后台运行，或者从死亡被激活，从3d进来的页面
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
   
    
    if ([shortcutItem.localizedTitle isEqualToString:@"扫一扫"]) {
        ScanCodeViewController *sao = [[ScanCodeViewController alloc] init];
        ViewController *controller = [[ViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
//        nav.navigationBarHidden = YES;
//        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        self.window.backgroundColor = [UIColor whiteColor];
        self.window.rootViewController = nav;
        [nav pushViewController:sao animated:YES];
       
    }
}


@end
