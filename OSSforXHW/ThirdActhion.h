//
//  ThirdActhion.h
//  OSSforXHW
//
//  Created by iOS on 2017/10/31.
//  Copyright © 2017年 XHW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TscCommand.h"
#import "HLPrinter.h"
#import "iflyMSC/IFlyMSC.h"
#import "IATConfig.h"
@interface ThirdActhion : NSObject
//单例
@property (nonatomic , strong) IFlyRecognizerView *iflyRecognizerView;
@property (nonatomic , strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

+ (ThirdActhion *)sharedInstance;
-(void) jsPrintWithData:(NSDictionary *)responseObject;
- (HLPrinter *)getPrinter:(NSDictionary *)dic;
-(void)yuyinzhuanwenzi:(UIViewController *)VC;
- (void) yuyinhecheng:(NSString *)str vcIs:(UIViewController *)VC;
@end
