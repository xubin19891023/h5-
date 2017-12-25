//
//  ViewController.m
//  XHWBaseAPI
//
//  Created by iOS on 2017/9/13.
//  Copyright © 2017年 XHW. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "WKWebViewJavascriptBridge.h"
#import "ReceivedJSNotication.h"
#import "RegisterHandler.h"
#import "JXPopoverAction.h"
#import "JXPopoverView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WindowsWebviewViewController.h"
#import "Utils.h"
#import "ScanCodeViewController.h"
#import "iflyMSC/IFlyMSC.h"
#import "IATConfig.h"
#import "MessageCenterTableViewController.h"
#import "MessageObj.h"
#import "BLKWrite.h"
#import "SystemSettingTableViewController.h"
#import "CQPlaceholderView.h"
#import "UIView+Toast.h"
#import "AnimationEffect.h"
#import "ThirdActhion.h"
#import "CBController.h"
#import "CentralScanController.h"
#import "Config.h"
#define TESTURL @"http://oss.testxianghuowang.me:8081/m/center.do?terminal=m#"
#define ZHENGSHIURL @"http://open.xianghuo.me/authorize.do?client_id=c1ebe466-1cdc-4bd3-ab69-77c3561b9dee&response_type=code&redirect_uri=http://sso.xianghuo.me/center.do&from_uri=http://oss.xianghuo.me/m/center.do"
#define ZHENGSHIURL1 @"http://oss.xianghuo.me/m/center.do?terminal=m#"
#define KAIFAURL @"http://oss.devxianghuowang.me:8081/m/center.do?terminal=m#"
@interface ViewController ()<WKNavigationDelegate,WKUIDelegate,ReceivedJSNoticationDelegate,UIGestureRecognizerDelegate,WKScriptMessageHandler,IFlyRecognizerViewDelegate,IFlyRecognizerViewDelegate,IFlySpeechSynthesizerDelegate,UITextFieldDelegate>

@property WKWebViewJavascriptBridge                     *bridge;
@property (nonatomic , strong) UITapGestureRecognizer    *recognizerTap;
@property (nonatomic , strong) UIAlertController         *alertController;
@property (nonatomic , strong) UIView                    *titleView;
@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic , strong) UITextField *text;
@property (nonatomic , strong) UILabel *tagView;
@property (nonatomic , strong) CQPlaceholderView *placeholderView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //    [[WoReaderLoadingView sharedInstance] showNoticeWithTitle:@"稍等片刻" yOffset:@"0"];
    NSLog(@"-------------------正在使用这个控制器");

//    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:(UIApplicationShortcutIconType)] 
    
    
    //    [self.view setBackgroundColor:[Utils getColor:@"0786e7"]];
    if (_bridge) { return; }
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    
    
    WKUserContentController *contentController = [[WKUserContentController alloc] init];
//    [contentController addScriptMessageHandler:self name:@"xianghuo"];
    config.userContentController = contentController;
    
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, VERSIONOFFSETY)];
    //    navigationImg.image = [UIImage imageNamed:@"bg_daohanglan.png"];
    statusView.backgroundColor = [Utils getColor:@"0786e7"];
    [self.view addSubview:statusView];
    
    
    self.titleView =[[UIView alloc] initWithFrame:CGRectMake(0, VERSIONOFFSETY, self.view.frame.size.width, +45)];
    [self.titleView setBackgroundColor:[Utils getColor:@"0786e7"]];
//    self.titleView.hidden = YES;
    [self.view addSubview:self.titleView];
    
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanButton setImage:[UIImage imageNamed:@"icon-zm_03"] forState:UIControlStateNormal];
    [scanButton setImage:[UIImage imageNamed:@"icon-zm_03"] forState:UIControlStateHighlighted];
    [scanButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [scanButton setFrame:CGRectMake(10, VERSIONOFFSETY+12, 24, 20)];
    [scanButton addTarget:self action:@selector(scanButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[UIImage imageNamed:@"Overflow-Icon"] forState:UIControlStateNormal];
    [menuButton setImage:[UIImage imageNamed:@"Overflow-Icon"] forState:UIControlStateHighlighted];
    [menuButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [menuButton setFrame:CGRectMake(self.view.frame.size.width-10-34, VERSIONOFFSETY+12, 24, 20)];
    [menuButton addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
    
    _tagView = [[UILabel alloc] initWithFrame:CGRectMake(10, VERSIONOFFSETY, 13,13)];
    _tagView.font = [UIFont systemFontOfSize:10];
    _tagView.textAlignment = 1;
    _tagView.clipsToBounds = YES;
    _tagView.layer.cornerRadius = 6.5;
    [menuButton addSubview:_tagView];
    
    
    self.titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setText:@"乡货网终端运营系统"];
    [self.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleView addSubview:self.titleLabel];
    
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, VERSIONOFFSETY+45, self.view.frame.size.width, self.view.frame.size.height-VERSIONOFFSETY) configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.scrollView.bounces = NO;
    [self.view addSubview:self.webView];
    
    
    _bridge = [[RegisterHandler sharedInstance] registerJavascriptBridgeWithWebview:self.webView delegate:self];
    
    [[RegisterHandler sharedInstance] registerHandlerwithBridge:_bridge delegate:self];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationAction:) name:@"YOU_GOT_AN_MESSAGE" object:nil];
    

    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"返回";
    self.navigationItem.backBarButtonItem = backBtn;
    
    [self loadWebView];
}

//
//该参数就是发送过来的通知,接到通知后执行的方法
- (void)notificationAction:(NSNotification *)notify
{
    //    NSLog(@"--------->>%@",notify.userInfo);
    if (notify.userInfo) {
        NSArray* arr = [MessageObj bg_findFormatSqlConditions:@"where %@=%@",bg_sqlKey(@"isRead"),bg_sqlValue(@"0")];
        NSUInteger i = arr.count;
        
        
        if (i>0) {
            _tagView.textColor = [UIColor whiteColor];
            _tagView.backgroundColor = [UIColor redColor];
            _tagView.text = [NSString stringWithFormat:@"%ld",i];
        }else{
            _tagView.textColor = [UIColor clearColor];
            _tagView.backgroundColor = [UIColor clearColor];
            _tagView.text = nil;
        }
        [self loadViewIfNeeded];
    }
}
- (void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"YOU_GOT_AN_MESSAGE" object:nil];
     [[NSNotificationCenter defaultCenter]removeObserver:self name:@"TitleHideNot" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if(self.callBackJS)
    {
        [self callBackJSFun];
    }
    
    NSArray* arr = [MessageObj bg_findFormatSqlConditions:@"where %@=%@",bg_sqlKey(@"isRead"),bg_sqlValue(@"0")];
    NSUInteger i = arr.count;
    
    if (i>0) {
        _tagView.textColor = [UIColor whiteColor];
        _tagView.backgroundColor = [UIColor redColor];
        _tagView.text = [NSString stringWithFormat:@"%ld",i];
    }else{
        _tagView.textColor = [UIColor clearColor];
        _tagView.backgroundColor = [UIColor clearColor];
        _tagView.text = nil;
    }
//    //    NSLog(@"---未读的数目----%ld",i);
//    //
//        AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        if(appDlg.isReachable){
//            NSLog(@"网络已连接");//执行网络正常时的代码
////            [self loadWebView];
//        }
//        else{
//            NSLog(@"网络连接异常");//执行网络异常时的代码
//            [self.navigationController setNavigationBarHidden:YES animated:animated];
//
//            _placeholderView = [[CQPlaceholderView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) type:CQPlaceholderViewTypeNoNetwork delegate:self];
//            [self.view addSubview:_placeholderView];
//    
//        }

}
-(void) callBackJSFun
{
    [[RegisterHandler sharedInstance] evaluateJavaScriptWith:self.callBackJS webview:self.webView];
    
}
#pragma make WKwebview
-(void) scanButtonClick
{
    ScanCodeViewController *scan = [[ScanCodeViewController alloc] init];
    //    __typeof (self) __weak weakSelf = self;
    
    [self.navigationController pushViewController:scan animated:YES];

}

-(void) menuButtonClick:(id) sender
{
    NSArray *array = [NSArray arrayWithObjects:@"扫一扫",@"消息",@"系统设置",@"退出登陆", nil];//= [responseObject objectForKey:@"content"];
    //    [[array objectAtIndex:0] objectForKey:@"name"];
    NSArray *arrayImg = [NSArray arrayWithObjects:@"scan_icon",@"message",@"setting",@"logout", nil];
    JXPopoverView *popoverView = [JXPopoverView popoverView];
    popoverView.showShade = YES;
    NSMutableArray *jxArray = [[NSMutableArray alloc]init];
    for (int i=0; i <[array count]; i ++)
    {
          JXPopoverAction *action = [JXPopoverAction actionWithImage:[UIImage imageNamed:[arrayImg objectAtIndex:i]] title:[array objectAtIndex:i] handler:^(JXPopoverAction *action)
                                   {
                                       if ([[array objectAtIndex:i] isEqualToString:@"扫一扫"])
                                       {
                                           NSLog(@"点击了扫一扫");
                                           [self scanButtonClick];
                                       }
                                       else if ([[array objectAtIndex:i] isEqualToString:@"消息"])
                                       {
                                           NSLog(@"点击了消息");
                                           MessageCenterTableViewController *vc = [[MessageCenterTableViewController alloc] init];
                                           [self.navigationController pushViewController:vc animated:YES];
                                       }
                                       else if ([[array objectAtIndex:i] isEqualToString:@"系统设置"])
                                       {
                                           NSLog(@"点击了系统设置");
                                           SystemSettingTableViewController *setVC = [[SystemSettingTableViewController alloc] init];
                                           [self.navigationController pushViewController:setVC animated:YES];
                                       }
                                      
                                       else if ([[array objectAtIndex:i] isEqualToString:@"退出登陆"])
                                       {
                                           NSLog(@"点击退出系统");
                                           self.titleView.hidden = YES;
                                           [self.webView setFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
                                           [self loadWebView];
                                       
                                       }
                                   }];
        [jxArray addObject:action];
    }
    
    [popoverView showToView:sender withActions:jxArray];
    

}
-(void) showPopverView:(NSDictionary *)responseObject
{
    NSArray *array = [responseObject objectForKey:@"content"];
    //    [[array objectAtIndex:0] objectForKey:@"name"];
    JXPopoverView *popoverView = [JXPopoverView popoverView];
    popoverView.showShade = YES;
    NSMutableArray *jxArray = [[NSMutableArray alloc]init];
    for (int i=0; i <[array count]; i ++)
    {
        JXPopoverAction *action = [JXPopoverAction actionWithTitle:[[array objectAtIndex:i] objectForKey:@"name"] handler:^(JXPopoverAction *action)
                                   {
                                       NSLog(@"-------点击了%@",[[array objectAtIndex:i] objectForKey:@"name"]);
                                       if ([[[array objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"SCAN"])
                                       {
                                           NSLog(@"扫一扫就扫一扫");
                                           [self scanButtonClick];
                                       }
                                   }];
        
        //带图片
        //        JXPopoverAction *action4 = [JXPopoverAction actionWithImage:[UIImage imageNamed:@"1111"] title:@"HXH" handler:^(JXPopoverAction *action) {
        //            NSLog(@"-------点击了HXH");
        //        }];
        [jxArray addObject:action];
    }
    
    
    [popoverView showToPoint:CGPointMake(250, 120) withActions:jxArray];
}
- (void) loadWebView
{
//    self.view.backgroundColor = [UIColor redColor];
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"demo112" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [self.webView loadHTMLString:appHtml baseURL:baseURL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TitleHideNot:) name:@"TitleHideNot" object:nil];
    return;

    
    
    
    NSString *url = ZHENGSHIURL1;
    //      NSString *url = @"http://xianghuo.me";
    [self reloadWebview:url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TitleHideNot:) name:@"TitleHideNot" object:nil];
    
}

-(void)TitleHideNot:(id)theNotification
{
    NSNotification *notification = (NSNotification *)theNotification;
    
    NSDictionary *dit = notification.object;
    NSString *hideStr = [dit objectForKey:@"hide"];
    if ([hideStr isEqualToString:@"NO"])
    {
        //        APPDELEGATE.tabbarController.tabBar.hidden =NO;
        self.titleView.hidden = NO;
        [self.webView setFrame:CGRectMake(0, 45+20, self.view.frame.size.width, self.view.frame.size.height-65)];
//           NSLog(@"-----------666666666--------------");
    }
    else
    {
        //        APPDELEGATE.tabbarController.tabBar.hidden =YES;
        self.titleView.hidden = YES;
        [self.webView setFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
        
    }
}
#pragma mark - ReceivedJSNoticationDelegate
-(void) extendJSWithData:(NSDictionary *)responseObject
{
    NSLog(@"extendJSWithData-------test:%@",responseObject);
    
}
- (UIViewController *)sendViewControllerToHandle
{
    return self;
}

-(void) callBackMenthod:(NSDictionary *)responseObject
{
    NSLog(@"back-------test:%@",responseObject);
    NSString *message = [responseObject objectForKey:@"message"];
    
    NSString *cancelJS = [responseObject objectForKey:@"cancel"];
    NSString *okJS = [responseObject objectForKey:@"ok"];
    
    self.alertController = [UIAlertController alertControllerWithTitle:@"网页提示框" message:message preferredStyle:UIAlertControllerStyleAlert];
    if (cancelJS)
    {
        
        [self.alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                         {
                                             NSLog(@"点击取消");
                                             NSString *scriptStr = [NSString stringWithFormat:@"%@()",cancelJS];
                                             
                                             [[RegisterHandler sharedInstance] evaluateJavaScriptWith:scriptStr webview:self.webView];
                                             
                                         }]];
    }
    if (okJS)
    {
        
        [self.alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击确认");
            NSString *scriptStr = [NSString stringWithFormat:@"%@()",okJS];
            
            [[RegisterHandler sharedInstance] evaluateJavaScriptWith:scriptStr webview:self.webView];
            
        }]];
    }
    
    [self presentViewController:self.alertController animated:YES completion:nil];
    
    if (!self.recognizerTap)
    {
        self.recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    }
    [self.recognizerTap setNumberOfTapsRequired:1];
    self.recognizerTap.cancelsTouchesInView = NO;
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:self.recognizerTap];
}


- (void)handleTapBehind:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint location = [sender locationInView:nil];
        if (![self.alertController.view pointInside:[self.alertController.view convertPoint:location fromView:self.alertController.view] withEvent:nil])
        {
            [self.alertController.view removeGestureRecognizer:sender];
         
            [self.alertController dismissViewControllerAnimated:NO completion:nil];
        }
    }
}
-(void) refreshView:(NSDictionary *)responseObject
{
    NSString *url = [responseObject objectForKey:@"url"];
//    NSLog(@"-------->>>>>>url:%@",url);
    [self reloadWebview:url];
}
- (void) reloadWebview:(NSString *)url
{
    NSURL *URL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:6];
    [self.webView loadRequest:request];
}

-(void) jsNoticationWithData:(NSDictionary *)responseObject{
    
    NSLog(@"------viewController--->jsNoticationWithData:%@",responseObject);
    if ([responseObject[@"name"] isEqualToString:@"voiceToWord"] ) {
        [[ThirdActhion sharedInstance] yuyinzhuanwenzi:self];
    }
    if ([responseObject[@"name"] isEqualToString:@"speaking"] ) {
        [[ThirdActhion sharedInstance] yuyinhecheng:responseObject[@"speak"] vcIs:self];
    }
    if ([responseObject[@"name"] isEqualToString:@"jumpToLogin"] ) {
        [self loadWebView];
    }
    if ([responseObject[@"name"] isEqualToString:@"Window.openKeyboard"] ) {
        self.text = [[UITextField alloc] init];
        self.text.delegate = self;
        [self.view addSubview:self.text];
        [self btnClick];
        
    }
    if ([responseObject[@"name"] isEqualToString:@"Window.closeKeyboard"] ) {
        self.text = [[UITextField alloc] init];
        self.text.delegate = self;
        [self.view addSubview:self.text];
        [self btnClick2];
        
    }
    
    
}
//打印小票
- (void) jsPrintLitterWithData:(NSDictionary *)responseObject{
   
    NSLog(@"------JSJSJSJSJSJS--->printLitterWithData:%@",responseObject);
    HLPrinter *printer = [[ThirdActhion sharedInstance] getPrinter:responseObject];
    NSData *mainData = [printer getFinalData];
    [[BLKWrite Instance] writeEscData:mainData withResponse:YES];
    //获取打印机纸张宽度
//    int width = [[BLKWrite Instance] PrintWidth];
//    NSLog(@"PrintWidth:%d mm", width);
    
}
//打印标签
- (void) jsPrintWithData:(NSDictionary *)responseObject{
    
    [[ThirdActhion sharedInstance] jsPrintWithData:responseObject];
}
//弹出键盘
- (void)btnClick
{
    [self.text becomeFirstResponder];
}
//收起键盘
- (void)btnClick2
{
    [self.text resignFirstResponder];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"Message: %@", message.body);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 语音功能的代理方法
//语音返回数据处理的代理方法
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    if (!isLast) {
        NSMutableString *result = [NSMutableString new];
        NSDictionary *dic = [resultArray objectAtIndex:0];
        for (NSString *key in dic) {
            [result appendFormat:@"%@",key];
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:result forKey:@"yuyinresult"];
        [defaults synchronize];
        NSLog(@"---------->>>%@",result);
    }
}
- (void)onError: (IFlySpeechError *) error{
    
}

//IFlySpeechSynthesizerDelegate协议实现
//合成结束
- (void) onCompleted:(IFlySpeechError *) error {}
//合成开始
- (void) onSpeakBegin {}
//合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg {}
//合成播放进度
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos {}


#pragma mark - Delegate - 占位图
/** 占位图的重新加载按钮点击时回调 */
- (void)placeholderView:(CQPlaceholderView *)placeholderView reloadButtonDidClick:(UIButton *)sender{
    switch (placeholderView.type) {
        case CQPlaceholderViewTypeNoGoods:       // 没商品
        {
            //            [self.view makeToast:@"正在返回首页"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
            
        case CQPlaceholderViewTypeNoOrder:       // 没有订单
        {
            [self.view makeToast:@"拉到就拉到"];
        }
            break;
            
        case CQPlaceholderViewTypeNoNetwork:     // 没网
        {
            self.titleView.hidden = YES;
            [self.webView setFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
            [self loadWebView];
        }
            break;
            
        case CQPlaceholderViewTypeBeautifulGirl: // 妹纸
        {
            [self.view makeToast:@"哦，那你很棒棒哦"];
        }
            break;
            
        default:
            break;
    }
}

@end
