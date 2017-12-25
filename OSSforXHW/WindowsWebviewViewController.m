//
//  WindowsWebviewViewController.m
//  乡货网
//
//  Created by Bill on 2017/5/9.
//  Copyright © 2017年 Bill. All rights reserved.
//

#import "WindowsWebviewViewController.h"
#import "WindowsOpenPage.h"
#import <WebKit/WebKit.h>
#import "Toolsbar.h"
#import "Config.h"
#import "JXPopoverAction.h"
#import "JXPopoverView.h"
#import "WKWebViewJavascriptBridge.h"
#import "RegisterHandler.h"
#import "JSONKit.h"
#import "iflyMSC/IFlyMSC.h"
#import "ViewController.h"
#import "TscCommand.h"
#import "TagPrinterModel.h"
#import "BLKWrite.h"
#import "EscCommand.h"
#import "HLPrinter.h"
#import "CQPlaceholderView.h"
#import "UIView+Toast.h"
#import "AppDelegate.h"
#import "ScanCodeViewController.h"
#import "Utils.h"

@interface WindowsWebviewViewController ()<WKNavigationDelegate,WKUIDelegate,ReceivedJSNoticationDelegate,IFlyRecognizerViewDelegate,IFlyRecognizerViewDelegate,IFlySpeechSynthesizerDelegate,UITextFieldDelegate>
@property (nonatomic,strong) WindowsOpenPage    *winOpenPage;
@property (nonatomic,strong) UILabel            *titleLabel;
@property (nonatomic,strong) UIView             *titleView;
@property (nonatomic,strong) UIView             *backgroundView;
@property (nonatomic,strong) WKWebView          *webView;
@property (strong,nonatomic) UIProgressView     *progressView;
@property (nonatomic ,strong) UIView            *shadowView; //阴影层
@property (nonatomic ,assign) CGFloat           widthScale;
@property (nonatomic ,assign) CGFloat           heightScale;
@property (nonatomic ,assign) NSInteger         isTitle;
@property WKWebViewJavascriptBridge             *bridge;
@property (nonatomic ,assign) BOOL         addiOSTpye;
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;
@property (nonatomic , strong) UITextField *text;
@property (nonatomic , strong) UILabel *tagView;
@property (nonatomic , strong) CQPlaceholderView *placeholderView;



@end
#define ButtonTag  1000

@implementation WindowsWebviewViewController

- (id)initWithWindowsObjectNone:(NSString *)url
{
    self = [super init];
    if (self)
    {
        self.winOpenPage = [WindowsOpenPage new];
        self.winOpenPage.type = @"NONE";
        self.winOpenPage.content = url;
        self.isTitle  = 0;
        self.widthScale =1;
        self.heightScale = 1;
        self.addiOSTpye = YES;
    }
    return self;
    
}

- (id)initWithWindowsObjectWithUrl:(NSString *)url title:(NSString *)title
{
    self = [super init];
    if (self)
    {
        self.winOpenPage = [WindowsOpenPage new];
        //        self.winOpenPage.type = @"NONE";
        self.winOpenPage.content = url;
        self.winOpenPage.name = title;
        self.widthScale =1;
        self.heightScale = 1;
        self.addiOSTpye = NO;
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init ];
        //:@[@"BACK",@"返回",@"NativeWindowClose",@"LEFT"] forKeys:@[@"ioc",@"name",@"onclick",@"pasitions"]];
        [dict setObject:@"BACK" forKey:@"ioc"];
        [dict setObject:@"返回" forKey:@"name"];
        [dict setObject:@"NativeWindowClose" forKey:@"onclick"];
        [dict setObject:@"LEFT" forKey:@"pasitions"];
        
        
        
        //Toolsbar *toolsbar = [[Toolsbar alloc] initWithDictionary:dict];
        self.winOpenPage.toolsbar =[NSMutableArray arrayWithObjects:dict, nil];
    }
    return self;
    
}

- (id)initWithWindowsObject:(WindowsOpenPage *)obj
{
    self = [super init];
    if (self)
    {
        
        self.winOpenPage = obj;
        self.isTitle  = 1;
        self.addiOSTpye = YES;
        
        if(self.winOpenPage.width&&![self.winOpenPage.width isEqualToString:@""])
        {
            self.widthScale = [self.winOpenPage.width floatValue]/100;
            if(self.widthScale >1)
            {
                self.widthScale =1;
            }
        }
        else
        {
            self.widthScale =1;
        }
        
        if (self.winOpenPage.height&&![self.winOpenPage.height isEqualToString:@""])
        {
            self.heightScale = [self.winOpenPage.height floatValue]/100;
            if(self.heightScale >1)
            {
                self.heightScale =1;
            }
        }
        else
        {
            self.heightScale = 1;
        }
        
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"--------erb-----------正在使用这个控制器");

    if (_bridge)
    {
        return;
    }
    
    if(self.isFull)
    {
        self.widthScale =1;
    }
    
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, VERSIONOFFSETY)];
    //    navigationImg.image = [UIImage imageNamed:@"bg_daohanglan.png"];
    statusView.backgroundColor = [self setColor:@"0786e7"];
    [self.view addSubview:statusView];
    
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, VERSIONOFFSETY, self.view.frame.size.width, self.view.frame.size.height - VERSIONOFFSETY)];
    if ([self.winOpenPage.shadow isEqualToString:@"TRUE"])
    {
        [self.shadowView setBackgroundColor:[UIColor blackColor]];
        self.shadowView.alpha = 0.5;
    }
    else
    {
        [self.shadowView setBackgroundColor:[UIColor clearColor]];
    }
    [self.view addSubview:self.shadowView];
    
    
    self.backgroundView = [[UIView alloc] init];
    [self.backgroundView setBackgroundColor:[UIColor whiteColor]];
    [self setBackgroundViewFrameWithDirection:self.winOpenPage.align];
    [self.view addSubview:self.backgroundView];
    
    
    self.titleView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*self.widthScale, TitleHeight)];
    [self.titleView setBackgroundColor:[self setColor:@"0786e7"]];
    if ([self.winOpenPage.type isEqualToString:NONE])
    {
        self.titleView.hidden = YES;
        self.isTitle = 0 ;
    }
    else
    {
        self.titleView.hidden = NO;
        self.isTitle = 1;
        
    }
    
    [self.backgroundView addSubview:self.titleView];
    
   
    self.titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (self.view.frame.size.width)*self.widthScale, TitleHeight)];
    if (self.winOpenPage.name)
    {
        self.titleLabel.hidden = NO;
        [self.titleLabel setText:[NSString stringWithFormat:@"%@",self.winOpenPage.name]];
    }
    else
    {
        self.titleLabel.hidden = YES;
    }
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleView addSubview:self.titleLabel];
  
    
    
    // 获取默认User-Agent
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        NSString *oldAgent = result;
        // 给User-Agent添加额外的信息
        if(![oldAgent hasSuffix:@"iOS"])
        {
            NSString *newAgent = [NSString stringWithFormat:@"%@,%@", oldAgent, @"iOS"];
            // 设置global User-Agent
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newAgent, @"UserAgent", nil];
            [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.webView setCustomUserAgent:newAgent];
        }
        
        
    }];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, TitleHeight*self.isTitle, self.view.frame.size.width*self.widthScale, self.backgroundView.frame.size.height-TitleHeight*self.isTitle)];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate =self;
    [self.backgroundView addSubview:self.webView];
    
    
    
    if ([self.winOpenPage.toolsbar count]>0)
    {
        for (int i =0; i<[self.winOpenPage.toolsbar count]; i++)
        {
            NSDictionary *dict = [self.winOpenPage.toolsbar objectAtIndex:i];
            Toolsbar *toolsbar = [[Toolsbar alloc] initWithDictionary:dict];
            UIImage *normalImage;
            UIImage *highlightedImage;
            
            
            //            NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"SourcesBundle" ofType:@"bundle"];
            //            NSString *imgPath= [bundlePath stringByAppendingPathComponent:@"demo4"];
            //
            //            UIImage *image = [UIImage imageWithContentsOfFile:imgPath];
            

            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:[NSString stringWithFormat:@"%@",toolsbar.name] forState:UIControlStateNormal];
            if([toolsbar.ioc isEqualToString:MENU])
            {
                NSString *normalImgPath= [MYBUNDLE_PATH stringByAppendingPathComponent:@"btn_back_normal"];
                normalImage = [UIImage imageWithContentsOfFile:normalImgPath];
                
                NSString *highlightedImgPath= [MYBUNDLE_PATH stringByAppendingPathComponent:@"btn_back_click"];
                highlightedImage = [UIImage imageWithContentsOfFile:highlightedImgPath];
                
                //                normalImage = [UIImage imageNamed:@"btn_back_normal.png"];
                //
                //                highlightedImage =[UIImage imageNamed:@"btn_back_click.png"];
                
            }
            else if([toolsbar.ioc isEqualToString:BACK])
            {
               
                normalImage = [UIImage imageNamed:@"back_m"];
                highlightedImage = [UIImage imageNamed:@"back_m"];
            }
            else if([toolsbar.ioc isEqualToString:REFRESH])
            {
                normalImage = [UIImage imageNamed:@"1111.png"];
                highlightedImage =[UIImage imageNamed:@"btn_back_click.png"];
            }
            [button setImage:normalImage forState:UIControlStateNormal];
            [button setImage:highlightedImage forState:UIControlStateHighlighted];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            if([toolsbar.pasitions isEqualToString:LEFT])
            {
                //                [button setImageEdgeInsets:UIEdgeInsetsMake((44-30)/2, 0, (44-30)/2, 44+30-30)];
                [button setFrame:CGRectMake(0, (44 - 44)/2.0, 44+30, 44)];
                //                [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            }
            else if ([toolsbar.pasitions isEqualToString:CENTER])
            {
                [button setFrame:CGRectMake((self.view.frame.size.width*self.widthScale - 44)/2, (44 - 44)/2.0, 44, 44)];
                
            }
            else if ([toolsbar.pasitions isEqualToString:RIGHT])
            {
                [button setFrame:CGRectMake(self.view.frame.size.width*self.widthScale - 44-15, (44 - 44)/2.0, 44, 44)];
            }
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = ButtonTag +i;
            [self.titleView addSubview:button];
        }
    }
    
    //
    _bridge = [[RegisterHandler sharedInstance] registerJavascriptBridgeWithWebview:self.webView delegate:self];
    
    [[RegisterHandler sharedInstance] registerHandlerwithBridge:_bridge delegate:self];
    
    [self loadWebView];
    
    [self initProgressView];
    
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


#pragma mark ViewShow

-(void) setBackgroundViewFrameWithDirection:(NSString *)direction
{
    CGFloat height_offY = 0.0;
    if((self.view.frame.size.height-self.view.frame.size.height*self.heightScale)<20)
    {
        height_offY =1;
    }
    else
    {
    }
    
    if ([direction isEqualToString:LEFT])
    {
        [self.backgroundView setFrame:CGRectMake(0, VERSIONOFFSETY, self.view.frame.size.width*self.widthScale, (self.view.frame.size.height) *self.heightScale-VERSIONOFFSETY*height_offY)];
        
    }
    else if ([direction isEqualToString:RIGHT])
    {
        [self.backgroundView setFrame:CGRectMake(self.view.frame.size.width -self.view.frame.size.width*self.widthScale, VERSIONOFFSETY, self.view.frame.size.width*self.widthScale, (self.view.frame.size.height)*self.heightScale -VERSIONOFFSETY*height_offY)];
        
    }
    else if ([direction isEqualToString:TOP])
    {
        [self.backgroundView setFrame:CGRectMake(0, VERSIONOFFSETY, self.view.frame.size.width*self.widthScale, (self.view.frame.size.height) *self.heightScale -VERSIONOFFSETY*height_offY)];
        
    }
    else if ([direction isEqualToString:BOTTOM])
    {
        [self.backgroundView setFrame:CGRectMake(0, VERSIONOFFSETY*height_offY+self.view.frame.size.height-(self.view.frame.size.height) *self.heightScale, self.view.frame.size.width*self.widthScale, (self.view.frame.size.height) *self.heightScale-VERSIONOFFSETY*height_offY)];
        
    }
    else if ([direction isEqualToString:CENTER])
    {
        [self.backgroundView setFrame:CGRectMake((self.view.frame.size.width -self.view.frame.size.width*self.widthScale)/2, (self.view.frame.size.height-(self.view.frame.size.height) *self.heightScale)/2, self.view.frame.size.width*self.widthScale, (self.view.frame.size.height) *self.heightScale)];
        
    }
    else
    {
        [self.backgroundView setFrame:CGRectMake(0, VERSIONOFFSETY, self.view.frame.size.width*self.widthScale, (self.view.frame.size.height) *self.heightScale-VERSIONOFFSETY*height_offY)];
        
    }
    
}

#pragma mark  progress

- (UIColor *)setColor:(NSString *)hexColor
{
    if (hexColor.length == 6)
    {
        unsigned int red, green, blue;
        NSRange range;
        range.length = 2;
        range.location = 0;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
        range.location = 2;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
        range.location = 4;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
        
        return [UIColor colorWithRed:(float)(red / 255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
    }
    else
    {
        return nil;
    }
}
- (UIColor *)getColor:(NSString *)hexColor
{
    if (hexColor.length == 6)
    {
        unsigned int red, green, blue;
        NSRange range;
        range.length = 2;
        range.location = 0;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
        range.location = 2;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
        range.location = 4;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
        
        return [UIColor colorWithRed:(float)(red / 255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
    }
    else
    {
        return nil;
    }
}

- (void)initProgressView
{
    CGFloat kScreenWidth = [[UIScreen mainScreen] bounds].size.width*self.widthScale;
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, TitleHeight*self.isTitle, kScreenWidth, 1)];
    progressView.tintColor = [self getColor:@"5FEC46"];
    progressView.trackTintColor = [UIColor whiteColor];
    [self.backgroundView addSubview:progressView];
    self.progressView = progressView;
}
- (void) backtoLogin{

    [self.navigationController popToRootViewControllerAnimated:YES];

}
- (void) loadWebView
{
    
    if (self.winOpenPage.content)
    {
        NSString *url = self.winOpenPage.content;
        
        if (self.winOpenPage.callbackfun&&![self.winOpenPage.callbackfun isEqualToString:@""])
        {
            if ([url rangeOfString:@"?"].location!=NSNotFound)
            {
                url = [NSString stringWithFormat:@"%@&method=%@",url,self.winOpenPage.callbackfun];
            }
            else
            {
                url = [NSString stringWithFormat:@"%@?method=%@",url,self.winOpenPage.callbackfun];
            }
//            NSLog(@"url:%@",url);
        }
        if (self.addiOSTpye)
        {
            if ([url rangeOfString:@"?"].location!=NSNotFound)
            {
                url = [NSString stringWithFormat:@"%@&type=iOS",url];
            }
            else
            {
                url = [NSString stringWithFormat:@"%@?type=iOS",url];
            }
        }
        
        [self reloadWebview:url];
    }else{
        [self reloadWebview:@"https//:www.baidu.com"];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    if(self.callBackJS)
    {
       [self callBackJSFun];
    }
    
    AppDelegate *appDlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDlg.isReachable){
//        NSLog(@"网络已连接");//执行网络正常时的代码
        //            [self loadWebView];
    }
    else{
//        NSLog(@"网络连接异常");//执行网络异常时的代码
        [self.navigationController setNavigationBarHidden:YES animated:animated];
        _placeholderView = [[CQPlaceholderView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) type:CQPlaceholderViewTypeNoNetwork delegate:self];
        [self.view addSubview:_placeholderView];
        
    }
    
       
}

- (void) reloadWebview:(NSString *)url
{
    NSURL *URL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:6];
    [self.webView loadRequest:request];
    
}
- (void)buttonClick:(id)sender
{
    NSInteger tag = [(UIButton *)sender tag];
    
    tag  = tag -ButtonTag;
    
    NSDictionary *dict = [self.winOpenPage.toolsbar objectAtIndex:tag];
    Toolsbar *toolsbar = [[Toolsbar alloc] initWithDictionary:dict];
//    NSLog(@"onclick:%@",toolsbar.onclick);
    if ([toolsbar.ioc isEqualToString:BACK])
    {
        NSString *scriptStr = [NSString stringWithFormat:@"%@()",toolsbar.onclick];
        [[RegisterHandler sharedInstance] evaluateJavaScriptWith:scriptStr webview:self.webView];
        [self.navigationController popViewControllerAnimated:YES];
        
        //
    }
    else if ([toolsbar.ioc isEqualToString:REFRESH])
    {
        //        [self.webView reload];
        //        NSString *url = @"https://www.baidu.com";
        //        [self reloadWebview:url];
        //        [self showPopverView:sender];
        NSString *scriptStr = [NSString stringWithFormat:@"%@()",toolsbar.onclick];
        [[RegisterHandler sharedInstance] evaluateJavaScriptWith:scriptStr webview:self.webView];
    }
    else if ([toolsbar.ioc isEqualToString:MENU])
    {
        NSString *scriptStr = [NSString stringWithFormat:@"%@()",toolsbar.onclick];
        [[RegisterHandler sharedInstance] evaluateJavaScriptWith:scriptStr webview:self.webView];
    }
    
}

-(void) showPopverView:(NSDictionary *)responseObject
{
    NSArray *array = [responseObject objectForKey:@"content"];
    //    [[array objectAtIndex:0] objectForKey:@"name"];
    JXPopoverView *popoverView = [JXPopoverView popoverView];
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
#pragma mark - KVO
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [self.progressView setProgress:1.0 animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            });
            
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

#pragma mark - ReceivedJSNoticationDelegate
- (UIViewController *)sendViewControllerToHandle
{
    return self;
}

-(void) callBackMenthod:(NSDictionary *)responseObject
{
    NSLog(@"back-------test:%@",responseObject);
    
    
}
-(void) refreshView:(NSDictionary *)responseObject
{
    NSString *url = [responseObject objectForKey:@"url"];
    [self reloadWebview:url];
}

- (void) jsNoticationWithData :(NSDictionary *)responseObject
{
    NSLog(@"----WKWKWKW--->jsNoticationWithData:%@",responseObject);
    
    if ([responseObject[@"name"] isEqualToString:@"voiceToWord"] ) {
        [[ThirdActhion sharedInstance] yuyinzhuanwenzi:self];
    }
    if ([responseObject[@"name"] isEqualToString:@"speaking"] ) {
        [[ThirdActhion sharedInstance] yuyinhecheng:responseObject[@"speak"] vcIs:self];
    }
    if ([responseObject[@"name"] isEqualToString:@"jumpToLogin"] ) {
        [self backtoLogin];
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
-(void) jsPrintWithData:(NSDictionary *)responseObject{
    
    [[ThirdActhion sharedInstance] jsPrintWithData:responseObject];
    
}


- (void)btnClick
{
    [self.text becomeFirstResponder];
}
- (void)btnClick2
{
    [self.text resignFirstResponder];
}

- (void) callBackFun :(NSDictionary *)responseObject
{
    WindowsWebviewViewController *personVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    //初始化其属性
    if (![personVC isKindOfClass:[WindowsWebviewViewController class]]) {
        if ([[responseObject objectForKey:@"param"] isKindOfClass:[NSDictionary class]])
        {
            ViewController *vc = [[ViewController alloc] init];
            NSDictionary *dict = [responseObject objectForKey:@"param"];
            //        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
            NSString *string = [dict JSONString];
            NSString *scriptStr = [NSString stringWithFormat:@"%@(%@)",[responseObject objectForKey:@"method"],string];
            vc.callBackJS = scriptStr;
            //使用popToViewController返回并传值到上一页面
            [self.navigationController popToViewController:vc animated:true];
            //        [[RegisterHandler sharedInstance] evaluateJavaScriptWith:scriptStr webview:self.webView];
        }
        else if ([[responseObject objectForKey:@"param"] isKindOfClass:[NSArray class]]){
            
            NSLog(@"----------------------------------------------------------------------");
            
        }
        else
        {
            NSString *string = [responseObject objectForKey:@"param"];
            NSString *str = [string JSONString];
            
            NSString *scriptStr = [NSString stringWithFormat:@"%@(%@)",[responseObject objectForKey:@"method"],str];
            personVC.callBackJS = scriptStr;
            
            [self.navigationController popToViewController:personVC animated:true];
            
            //        [[RegisterHandler sharedInstance] evaluateJavaScriptWith:scriptStr webview:self.webView];
        }

    }
    //传递参数过去
    if ([[responseObject objectForKey:@"param"] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = [responseObject objectForKey:@"param"];
        //        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
        NSString *string = [dict JSONString];
        NSString *scriptStr = [NSString stringWithFormat:@"%@(%@)",[responseObject objectForKey:@"method"],string];
        personVC.callBackJS = scriptStr;
        //使用popToViewController返回并传值到上一页面
        [self.navigationController popToViewController:personVC animated:true];
        //        [[RegisterHandler sharedInstance] evaluateJavaScriptWith:scriptStr webview:self.webView];
    }
    else if ([[responseObject objectForKey:@"param"] isKindOfClass:[NSArray class]]){
    
        NSLog(@"----------------------------------------------------------------------");

    }
    else 
    {
        NSString *string = [responseObject objectForKey:@"param"];
        NSString *str = [string JSONString];
        
        NSString *scriptStr = [NSString stringWithFormat:@"%@(%@)",[responseObject objectForKey:@"method"],str];
        personVC.callBackJS = scriptStr;
        
        [self.navigationController popToViewController:personVC animated:true];
        
        //        [[RegisterHandler sharedInstance] evaluateJavaScriptWith:scriptStr webview:self.webView];
    }
}

#pragma mark extend

-(void) extendJSregisterHandler:(NSString*)apiStr delegate:(id)delegate
{
    
    [_bridge registerHandler:apiStr handler:^(id data, WVJBResponseCallback responseCallback)
     {
         NSLog(@"testObjcCallback called: %@", data);
         [[ReceivedJSNotication sharedInstance]createWithResponseObject:data menthod:apiStr delegate:delegate datacallBack:nil];
         
         responseCallback(@"Response from extendJSregisterHandler");
     }];
}



- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    
}

-(void) callBackJSFun
{
    [[RegisterHandler sharedInstance] evaluateJavaScriptWith:self.callBackJS webview:self.webView];
    
}
#pragma mark - WKScriptMessageHandler
//- (void)userContentController:(WKUserContentController *)userContentController
//      didReceiveScriptMessage:(WKScriptMessage *)message
//{
//    NSLog(@"Message: %@", message.body);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma make WKwebview
-(void) scanButtonClick
{
//    ScanCodeViewController *scan = [[ScanCodeViewController alloc] init];
//    //    __typeof (self) __weak weakSelf = self;
//    
//    [self.navigationController pushViewController:scan animated:YES];
    
 
    
}


#pragma mark - 语音功能的代理方法
//返回数据处理的代理方法
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
