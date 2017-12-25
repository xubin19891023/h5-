//
//  ThirdActhion.m
//  OSSforXHW
//
//  Created by iOS on 2017/10/31.
//  Copyright © 2017年 XHW. All rights reserved.
//

#import "ThirdActhion.h"
#import "TagPrinterModel.h"
#import "Utils.h"
@implementation ThirdActhion

+ (ThirdActhion *)sharedInstance
{
    ThirdActhion *instance;
    
    @synchronized(self)
    {
        if (!instance)
        {
            instance = [[ThirdActhion alloc] init];
        }
    }
    return instance;
}

//打印标签
-(void) jsPrintWithData:(NSDictionary *)responseObject{
    NSLog(@"------JSJSJSJSJSJS--->printWithData:%@",responseObject);
    //    return;
    TagPrinterModel *tagModel = [[TagPrinterModel alloc] init];
    [tagModel setValuesForKeysWithDictionary:responseObject];
    
    TscCommand *tscCmd = [[TscCommand alloc] init];
    [tscCmd setHasResponse:YES];
    
    /*
     一定会发送的设置项
     */
    //Size
//    设置纸张宽度和高度
    [tscCmd addSize:50 :40];
    
    //GAP
    [tscCmd addGapWithM:2   withN:0];
    
    //REFERENCE
    [tscCmd addReference:0
                        :0];
    
    //SPEED
    [tscCmd addSpeed:4];
    
    //DENSITY
    
    [tscCmd addDensity:8];
    
    //DIRECTION
    [tscCmd addDirection:0];
    
    //fixed command
    [tscCmd addComonCommand];
    [tscCmd addCls];
    
    //unit
    /*
     打印多行标签文本
     */
    
    
    [tscCmd addTextwithX:22
                   withY:(10)
                withFont:@"TSS24.BF2"
            withRotation:0
               withXscal:1
               withYscal:1
                withText:[NSString stringWithFormat:@"会员:%@",tagModel.member]];
    [tscCmd addTextwithX:22
                   withY:(50)
                withFont:@"TSS24.BF2"
            withRotation:0
               withXscal:1
               withYscal:1
                withText:[NSString stringWithFormat:@"商品:%@",tagModel.goods]];
    //    [tscCmd addTextwithX:220
    //                   withY:(72)
    //                withFont:@"TSS24.BF2"
    //            withRotation:0
    //               withXscal:1
    //               withYscal:1
    //                withText:tagModel.goods_total_price];
    
    if (tagModel.total_money && ![tagModel.total_money isKindOfClass:[NSNull class]]) {
        [tscCmd addTextwithX:22
                       withY:(90)
                    withFont:@"TSS24.BF2"
                withRotation:0
                   withXscal:1
                   withYscal:1
                    withText:[NSString stringWithFormat:@"总金额:%@",tagModel.total_money]];
        
        [tscCmd addTextwithX:220
                       withY:(90)
                    withFont:@"TSS24.BF2"
                withRotation:0
                   withXscal:1
                   withYscal:1
                    withText:[NSString stringWithFormat:@"重量:%@",tagModel.weight]];
        
        [tscCmd addTextwithX:22
                       withY:(130)
                    withFont:@"TSS24.BF2"
                withRotation:0
                   withXscal:1
                   withYscal:1
                    withText:[NSString stringWithFormat:@"价格:%@",tagModel.standard_price]];
        
        [tscCmd addTextwithX:220
                       withY:(130)
                    withFont:@"TSS24.BF2"
                withRotation:0
                   withXscal:1
                   withYscal:1
                    withText:[NSString stringWithFormat:@"数量:%@",tagModel.number]];
        [tscCmd addTextwithX:22
                       withY:(170)
                    withFont:@"TSS24.BF2"
                withRotation:0
                   withXscal:1
                   withYscal:1
                    withText:[NSString stringWithFormat:@"日期:%@",[Utils getCurrentTimesForlabel]]];
    }else{
        [tscCmd addTextwithX:22
                       withY:(90)
                    withFont:@"TSS24.BF2"
                withRotation:0
                   withXscal:1
                   withYscal:1
                    withText:[NSString stringWithFormat:@"价格:%@",tagModel.standard_price]];
        
        [tscCmd addTextwithX:220
                       withY:(90)
                    withFont:@"TSS24.BF2"
                withRotation:0
                   withXscal:1
                   withYscal:1
                    withText:[NSString stringWithFormat:@"重量:%@",tagModel.weight]];
        
        [tscCmd addTextwithX:22
                       withY:(130)
                    withFont:@"TSS24.BF2"
                withRotation:0
                   withXscal:1
                   withYscal:1
                    withText:[NSString stringWithFormat:@"日期:%@",[Utils getCurrentTimesForlabel]]];
        
        [tscCmd addTextwithX:220
                       withY:(130)
                    withFont:@"TSS24.BF2"
                withRotation:0
                   withXscal:1
                   withYscal:1
                    withText:[NSString stringWithFormat:@"数量:%@",tagModel.number]];
    }
    
    [tscCmd addTextwithX:280
                   withY:(172)
                withFont:@"TSS24.BF2"
            withRotation:0
               withXscal:3
               withYscal:3
                withText:@"B14"];
    
    
    [tscCmd add1DBarcode:20 :240 :@"CODE128" :45 :1 :0 :2 :4 :tagModel.sku];
    //print
    [tscCmd addPrint:1 :1];
    
    
}

- (HLPrinter *)getPrinter:(NSDictionary *)dic
{
    
    
    
    HLPrinter *printer = [[HLPrinter alloc] init];
    //    NSString *title = @"乡货网";
    
    [printer appendImage:[UIImage imageNamed:@"order_head1"] alignment:HLTextAlignmentCenter maxWidth:380];
    [printer appendText:@"  " alignment:HLTextAlignmentLeft];
    
    NSString *str1 = [NSString stringWithFormat:@"门店：%@",dic[@"companyName"]];
    NSString *str2 = [NSString stringWithFormat:@"工号：%@",dic[@"user_id"]];
    
    //    [printer appendText:title alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleBig];
    [printer appendText:str1 alignment:HLTextAlignmentLeft];
    [printer appendText:str2 alignment:HLTextAlignmentLeft];
    [printer appendTitle:@"时间:" value:dic[@"print_time"] valueOffset:65];
    
    [printer appendLeftText:@"名称" middleText:@"价格" middleText1:@"优惠" rightText:@"数量" rightText1:@"小计" isTitle:YES];
    //    CGFloat total = 0.0;
    [printer appendSeperatorLine];
    
    
    //    NSDictionary *dict1 = @{@"name":@"铅笔测",@"amount":@"5",@"price":@"2.0",@"price1":@"2.0",@"price2":@"2.0"};
    //    NSDictionary *dict2 = @{@"name":@"新疆沙漠西瓜",@"amount":@"1",@"price":@"1.0",@"price1":@"2.0",@"price2":@"2.0"};
    //    NSDictionary *dict3 = @{@"name":@"新款式iPhoneX",@"amount":@"3",@"price":@"13.0",@"price1":@"12.08",@"price2":@"222.08"};
    NSArray *goodsArray = dic[@"goods"];
    for (NSDictionary *dict in goodsArray) {
        if ([dict[@"name"] length]>4) {
            [printer appendLeftText:dict[@"name"] middleText:nil middleText1:nil rightText:nil rightText1:nil isTitle:NO];
            //            [printer appendNewLine];
            [printer appendLeftText:nil middleText:dict[@"price"] middleText1:dict[@"backMoney"] rightText:dict[@"nums"] rightText1:dict[@"totalPrice"] isTitle:NO];
            
        }else{
            
            [printer appendLeftText:dict[@"name"] middleText:dict[@"price"] middleText1:dict[@"backMoney"] rightText:dict[@"nums"] rightText1:dict[@"totalPrice"] isTitle:NO];
        }
        
        //        [printer appendLeftText:dict[@"name"] middleText:dict[@"amount"] rightText:dict[@"price"] isTitle:NO];
        //        total += [dict[@"price"] floatValue] * [dict[@"amount"] intValue];
    }
    
    [printer appendSeperatorLine];
    NSString *totalStr1 = [NSString stringWithFormat:@"%@",dic[@"totalNums"]];
    [printer appendTitle:@"总数量:" value:totalStr1];
    NSString *totalStr = [NSString stringWithFormat:@"%@",dic[@"yingfuTotalPrice"]];
    [printer appendTitle:@"应付计:" value:totalStr];
    [printer appendTitle:@"实收:" value:[NSString stringWithFormat:@"%@",dic[@"shifuTotalPrice"]]];
    NSString *leftStr = [NSString stringWithFormat:@"%@",dic[@"zhaolingMoney"]];
    [printer appendTitle:@"找零:" value:leftStr];
    [printer appendTitle:@"支付方式:" value:[NSString stringWithFormat:@"%@",dic[@"payType"]]];
    NSArray *payTypeArr = dic[@"payTypes"];
    for (NSDictionary *payDic in payTypeArr) {
        [printer appendText:[NSString stringWithFormat:@"%@:%@",payDic[@"payName"],payDic[@"payMoney"]] alignment:HLTextAlignmentLeft];
    }
    if (dic[@"dsc"]) {
        [printer appendText:[NSString stringWithFormat:@"备注：%@",dic[@"dsc"]] alignment:HLTextAlignmentLeft];
        
    }
    [printer appendSeperatorLine];
    if (dic[@"tihuo_address"] && dic[@"tihuo_phone"] && dic[@"send_date"] ) {
        [printer appendText:[NSString stringWithFormat:@"提货点：%@",dic[@"tihuo_address"]] alignment:HLTextAlignmentLeft];
        [printer appendText:[NSString stringWithFormat:@"提货电话：%@",dic[@"tihuo_phone"]] alignment:HLTextAlignmentLeft];
        [printer appendText:[NSString stringWithFormat:@"预计发货日期：%@",dic[@"send_date"]] alignment:HLTextAlignmentLeft];
        [printer appendSeperatorLine];
    }
    if (dic[@"billNo"]) {
        [printer appendBarCodeWithInfo:[NSString stringWithFormat:@"%@",dic[@"billNo"]]];
        [printer appendText:[NSString stringWithFormat:@"%@",dic[@"billNo"]] alignment:HLTextAlignmentCenter];
    }
    
    
    [printer appendText:@"   " alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
    [printer appendText:@"400-019-0700" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
    [printer appendText:@"全国服务电话" alignment:HLTextAlignmentCenter];
    [printer appendText:@"   " alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleBig];
    [printer appendText:@"   " alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleBig];
    
    //    [printer appendText:@"位图方式二维码" alignment:HLTextAlignmentCenter];
    //    [printer appendQRCodeWithInfo:@"www.baidu.com"];
    //
    //    [printer appendSeperatorLine];
    //    [printer appendText:@"指令方式二维码" alignment:HLTextAlignmentCenter];
    //    [printer appendQRCodeWithInfo:@"www.baidu.com" size:10];
    //
    //    [printer appendFooter:nil];
    //    [printer appendImage:[UIImage imageNamed:@"ico180"] alignment:HLTextAlignmentCenter maxWidth:300];
    
    // 你也可以利用UIWebView加载HTML小票的方式，这样可以在远程修改小票的样式和布局。
    // 注意点：需要等UIWebView加载完成后，再截取UIWebView的屏幕快照，然后利用添加图片的方法，加进printer
    // 截取屏幕快照，可以用UIWebView+UIImage中的catogery方法 - (UIImage *)imageForWebView
    
    return printer;
}



-(void)yuyinzhuanwenzi:(UIViewController *)VC{
    
    self.iflyRecognizerView = [[IFlyRecognizerView alloc]initWithCenter:VC.view.center];
    self.iflyRecognizerView.delegate = VC;
    [VC.view addSubview:self.iflyRecognizerView];
    [self.iflyRecognizerView setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path保存录音文件名,默认目录是documents
    [self.iflyRecognizerView setParameter: @"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    //设置返回的数据格式为默认plain
    [self.iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    [self.iflyRecognizerView setParameter:@"3000" forKey:@"vad_bos"];
    [self.iflyRecognizerView setParameter:@"1500" forKey:@"vad_eos"];
    [self.iflyRecognizerView setParameter:@"0" forKey:@"asr_ptt"];
    IATConfig *instance = [IATConfig sharedInstance];
    
    if ([instance.language isEqualToString:[IATConfig chinese]]) {
        //设置语言
        [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        //设置方言
        NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
        NSString *fangyan = [de objectForKey:@"fangyan"];
        if (fangyan) {
            //            NSLog(@"88888888888888888%@",fangyan);
            if ([fangyan isEqualToString:@"普通话"]) {
                [_iflyRecognizerView setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT_MANDARIN]];
            }else if ([fangyan isEqualToString:@"广东话"]){
                [_iflyRecognizerView setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT_CANTONESE]];
                
            }else if ([fangyan isEqualToString:@"四川话"]){
                [_iflyRecognizerView setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT_SICHUANESE]];
                
            }else{
                [_iflyRecognizerView setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT_HENANESE]];
                
            }
            
        }
        
    }else if ([instance.language isEqualToString:[IATConfig english]]) {
        //设置语言
        [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
    }
    [self.iflyRecognizerView start];
    
    
}
- (void) yuyinhecheng:(NSString *)str vcIs:(UIViewController *)VC{
    //获取语音合成单例
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    //设置协议委托对象
    _iFlySpeechSynthesizer.delegate = VC;
    //设置合成参数
    //设置在线工作方式
    [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD]
                                  forKey:[IFlySpeechConstant ENGINE_TYPE]];
    //设置音量，取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50"
                                  forKey: [IFlySpeechConstant VOLUME]];
    //发音人，默认为”xiaoyan”，可以设置的参数列表可参考“合成发音人列表”
    [_iFlySpeechSynthesizer setParameter:@" xiaoyan "
                                  forKey: [IFlySpeechConstant VOICE_NAME]];
    //保存合成文件名，如不再需要，设置为nil或者为空表示取消，默认目录位于library/cache下
    [_iFlySpeechSynthesizer setParameter:@" tts.pcm"
                                  forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
    //启动合成会话
    [_iFlySpeechSynthesizer startSpeaking: str];
}
@end
