//
//  RukuViewController.m
//  OSSforXHW
//
//  Created by iOS on 2017/9/26.
//  Copyright © 2017年 XHW. All rights reserved.
//

#import "RukuViewController.h"
#import <WebKit/WebKit.h>
#import "WKWebViewJavascriptBridge.h"
#import "Config.h"
#import "Utils.h"
#import "WindowsOpenPage.h"
#import "RegisterHandler.h"
#import "ReceivedJSNotication.h"
#import "BLEServer.h"
#import "showLabel.h"
#import "Masonry.h"
#import "SelectGoodsModel.h"
#import "JSONKit.h"
#import "ThirdActhion.h"
@interface RukuViewController ()<WKNavigationDelegate,WKUIDelegate,ReceivedJSNoticationDelegate,BLEServerDelegate,WKScriptMessageHandler>
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

@property (nonatomic,strong) UILabel            *goodsNameLabel;
@property (nonatomic,strong) UILabel            *needGoodsLabel;
@property (nonatomic,strong) UILabel            *weighingLabel;
@property (nonatomic,strong) UILabel            *totalPriceLabel;
@property (nonatomic,strong) UILabel            *leftLabel;
@property (nonatomic,strong) UILabel            *middleLabel;
@property (nonatomic,strong) UILabel            *rightLabel;

@property (nonatomic ,assign) BOOL         addiOSTpye;


@property (strong,nonatomic)BLEServer * defaultBLEServer;
@property (nonatomic)BOOL readState;
@property (nonatomic)BOOL notifyState;

@property (nonatomic , strong) showLabel *show1;
@property (nonatomic , strong) showLabel *show2;
//@property (nonatomic , strong) showLabel *show3;

@property (nonatomic , strong) NSString *weight1;
@property (nonatomic,strong) SelectGoodsModel *Goodsmodel;


@end

@implementation RukuViewController
//选择商品
- (void) jsSelectSortingGoodsWithData:(NSDictionary *)responseObject
{
    self.Goodsmodel = [[SelectGoodsModel alloc] init];
    [self.Goodsmodel setValuesForKeysWithDictionary:responseObject];
    self.show1.upLabel.text = [NSString stringWithFormat:@"%.2lf",self.Goodsmodel.require_weight];
    
}
//确定称重
- (void) jsEnsureWeightWithData:(NSDictionary *)responseObject{
    
    NSLog(@"----rkrkrk--->jsEnsureWeightWithData:%@",responseObject);
    //    [[RegisterHandler sharedInstance] callhandlerWithBridge:_bridge delegate:self callBackData:nil];
    //    @"{weight:2.30,sku:'123456',id:1,type:1}"
    NSDictionary *jsonNeed ;
    if (_Goodsmodel) {
        long ID = _Goodsmodel.ID;
        NSString *sku = _Goodsmodel.sku;
        double weight = [_show2.upLabel.text floatValue];
//        NSString *weightType = _Goodsmodel.weightType;
        jsonNeed = @{@"weight":@(weight),@"sku":sku,@"id":@(ID)};

//        jsonNeed = @{@"weight":@(weight),@"sku":sku,@"id":@(ID),@"type":weightType};
        //         initWithObjectsAndKeys:@"weight",weight,@"sku",sku,@"id",ID,@"type",weightType, nil];
    }
    NSString *jsonStr = [jsonNeed JSONString];
    NSLog(@"------%@",jsonStr);
    [[RegisterHandler sharedInstance] evaluateJavaScriptWith:[NSString stringWithFormat:@"%@(%@)",responseObject[@"method"],jsonStr] webview:self.webView];
    
    
    
}
//重置参数
- (void) jsClearSortingWithData:(NSDictionary *)responseObject{
    NSLog(@"----Weight--->jsClearSortingWithData:%@",responseObject);
    if ([responseObject[@"type"] isEqual:@"ALL"]) {
        self.show1.upLabel.text = @"0.00";
        self.show2.upLabel.text = @"0.00";
//        self.show3.upLabel.text = @"0.00";
        
        [self loadWebView];
    }else{
        NSLog(@"重量清除");
        self.show2.upLabel.text = @"0.00";
        
    }
    
}
//- (void) jsNoticationWithData :(NSDictionary *)responseObject
//{
//    NSLog(@"----ruku--->jsNoticationWithData:%@",responseObject);
//
//}
- (UIViewController *) sendViewControllerToHandle
{
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.defaultBLEServer = [BLEServer defaultBLEServer];
    self.defaultBLEServer.delegate = self;
    _readState=NO;
    _notifyState=NO;
    
    
}
-(void)didDisconnect
{
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [SVProgressHUD dismissWithError:@"断开连接"];
    //        [self.navigationController popToRootViewControllerAnimated:YES];
    //    });
}

-(void)didReadvalue
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _readState = NO;
        NSData *d = self.defaultBLEServer.selectCharacteristic.value;
        NSString *string = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
        //        NSString *s = [d hexval];
        //        self.lbHex.text = s;
        //
        //        NSString * str=[self turn16to10:s];
        //        self.lbDecimal.text=str;
        //
        //        NSString * st=[self turn10to2:str];
        //        self.lbASCII.text=st;
        
        NSLog(@"===web==%ld",string.length);
        NSLog(@"===web==%@====",string);
        
        float weight = [[string substringToIndex:string.length-5] floatValue];
        
        self.show2.upLabel.text = [Utils decimalwithFormat:@"0.00" floatV:weight];
        //        NSLog(@"s==%@,st==%@,str==%@",s,st,str);
        if ([[Utils decimalwithFormat:@"0.00" floatV:weight] containsString:@"."]) {
            // 创建Attributed
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:self.show2.upLabel.text];
            
            
            // 需要改变的第一个文字的位置
            NSUInteger firstLoc = [[noteStr string] rangeOfString:@"."].location + 1;
            // 需要改变的最后一个文字的位置
            //        NSUInteger secondLoc = [[noteStr string] rangeOfString:@"元"].location;
            // 需要改变的区间
            NSRange range = NSMakeRange(firstLoc, noteStr.length - firstLoc);
            // 改变颜色
            //        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range];
            // 改变字体大小及类型
            [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
            // 为label添加Attributed
            [self.show2 .upLabel setAttributedText:noteStr];
        }
        
        
        else {
            NSLog(@"没有小数点");
        }
    });
}

//-(void)didNotifyData
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        _notifyState = NO;
//
//        NSData *d = self.defaultBLEServer.selectCharacteristic.value;
//        NSLog(@"d----%@",d);
//
//        //        NSString *s = [d hexval];
//        //        self.lbHex.text = s;
//        //
//        //        NSString * str=[self turn16to10:s];
//        //        self.lbDecimal.text=str;
//        //
//        //        NSString * st=[self turn10to2:str];
//        //        self.lbASCII.text=st;
//
//        NSLog(@"-----");
//        //        NSLog(@"s--%@,st--%@,str--%@",s,st,str);
//    });
//}

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
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
    [self.backgroundView setBackgroundColor:[self setColor:@"0786e7"]];
    [self setBackgroundViewFrameWithDirection:self.winOpenPage.align];
    [self.view addSubview:self.backgroundView];
    
    
    self.titleView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*self.widthScale, TitleHeight)];
    [self.titleView setBackgroundColor:[self setColor:@"0786e7"]];
    
    [self.backgroundView addSubview:self.titleView];
    
    
    self.titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (self.view.frame.size.width)*self.widthScale, TitleHeight)];
    if (self.winOpenPage.name) {
        [self.titleLabel setText:self.winOpenPage.name];
    }else{
        [self.titleLabel setText:@"出入库称重"];

    }
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleView addSubview:self.titleLabel];
    
    
    UIImage *normalImage;
    UIImage *highlightedImage;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, (44 - 44)/2.0, 44+30, 44)];
    normalImage = [UIImage imageNamed:@"back_m"];
    highlightedImage = [UIImage imageNamed:@"back_m"];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    [button setTitle:[NSString stringWithFormat:@"返回"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backtobefor) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:button];
    
    UIView *showView = [[UIView alloc] init];
    showView.backgroundColor =  [UIColor whiteColor];
    [self.backgroundView addSubview:showView];
    

    self.show1 = [[showLabel alloc] initWithFrame:CGRectMake(0, 70, (self.view.frame.size.width)/2, 70) upStr:@"0.00" downStr:@"需分拣/Kg"];
//    self.show1.backgroundColor = [UIColor greenColor];
    [self.backgroundView addSubview:_show1];
    
    self.show2 = [[showLabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width)/2, 70, (self.view.frame.size.width)/2, 70) upStr:@"0.00" downStr:@"称重/Kg"];
//    self.show2.backgroundColor = [UIColor redColor];
    [self.backgroundView addSubview:_show2];
    
    
    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.show1.mas_right);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(50);
        make.centerY.equalTo(self.show1.mas_centerY);
    }];
    
    
    
    
    if (_bridge) { return; }
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.minimumFontSize = 10;
    WKUserContentController *contentController = [[WKUserContentController alloc] init];
    config.userContentController = contentController;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 45+110, self.view.frame.size.width*self.widthScale, self.backgroundView.frame.size.height-45-110) configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate =self;
    [self.backgroundView addSubview:self.webView];
    
    _bridge = [[RegisterHandler sharedInstance] registerJavascriptBridgeWithWebview:self.webView delegate:self];
    
    [[RegisterHandler sharedInstance] registerHandlerwithBridge:_bridge delegate:self];
    
    [self loadWebView];
    
    
    
    
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
    
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    
}
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
- (void)backtobefor{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void) loadWebView
{
    
//        NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"demo112" ofType:@"html"];
//        NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
//        NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
//        [self.webView loadHTMLString:appHtml baseURL:baseURL];
//        return;
    NSString *url = nil;
    if (self.winOpenPage.content)
    {
        url = self.winOpenPage.content;
        //
        //        if (self.winOpenPage.callbackfun&&![self.winOpenPage.callbackfun isEqualToString:@""])
        //        {
        //            if ([url rangeOfString:@"?"].location!=NSNotFound)
        //            {
        //                url = [NSString stringWithFormat:@"%@&method=%@",url,self.winOpenPage.callbackfun];
        //            }
        //            else
        //            {
        //                url = [NSString stringWithFormat:@"%@?method=%@",url,self.winOpenPage.callbackfun];
        //            }
        //            //            NSLog(@"url:%@",url);
        //        }
        //        if (self.addiOSTpye)
        //        {
        //            if ([url rangeOfString:@"?"].location!=NSNotFound)
        //            {
        //                url = [NSString stringWithFormat:@"%@&type=iOS",url];
        //            }
        //            else
        //            {
        //                url = [NSString stringWithFormat:@"%@?type=iOS",url];
        //            }
        //        }
        
        
    }else{
        
        url = @"https://www.baidu.com";
        
    }
    
    NSURL *URL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:6];
    [self.webView loadRequest:request];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//打印标签
- (void) jsPrintWithData:(NSDictionary *)responseObject{
    
    [[ThirdActhion sharedInstance] jsPrintWithData:responseObject];
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
