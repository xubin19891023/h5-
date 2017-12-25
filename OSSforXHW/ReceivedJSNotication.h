//
//  ReceivedJSNotication.h
//  乡货网
//
//  Created by Bill on 2017/5/9.
//  Copyright © 2017年 Bill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "iflyMSC/IFlyMSC.h"

//block
typedef void (^dataCallback)(id callBackData);
typedef void (^dataCallback1)(id callBackData1);
typedef void (^dataCallback2)(id callBackData2);


//代理协议
@protocol ReceivedJSNoticationDelegate <NSObject>

@required
- (UIViewController *) sendViewControllerToHandle;

@optional
- (void) callBackMenthod:(NSDictionary *)responseObject; //回调方法
- (void) refreshView:(NSDictionary *)responseObject; //刷新页面
- (void) showPopverView:(NSDictionary *)responseObject;//展示POP
- (void) jsNoticationWithData:(NSDictionary *)responseObject;//通知带数据
- (void) callBackFun:(NSDictionary *)responseObject;//从上级页面回调数据
- (void) extendJSWithData:(NSString*)menthod Data:(NSDictionary *)responseObject; 
- (void) jsPrintWithData:(NSDictionary *)responseObject;//打印标签带数据
- (void) jsSelectSortingGoodsWithData:(NSDictionary *)responseObject;//页面选择商品
- (void) jsEnsureWeightWithData:(NSDictionary *)responseObject;//确定称重
- (void) jsClearSortingWithData:(NSDictionary *)responseObject;//重置参数
- (void) jsSetSortingTypeWithData:(NSDictionary *)responseObject;//更改模式
- (void) jsPrintLitterWithData:(NSDictionary *)responseObject;//打印小票



@end

@interface ReceivedJSNotication : NSObject 

@property (nonatomic, assign) id <ReceivedJSNoticationDelegate> delegate;
@property (nonatomic , strong) dataCallback dataCallbackto;
@property (nonatomic , strong) dataCallback1 dataCallbackto1;
@property (nonatomic , strong) dataCallback2 dataCallbackto2;
@property (nonatomic, strong) NSString *yuyinResult;



+ (ReceivedJSNotication *)sharedInstance;

- (void)createWithResponseObject:(NSDictionary *)responseObject menthod:(NSString *)menthod delegate:(id<ReceivedJSNoticationDelegate>)delegate datacallBack:(dataCallback)datacallbackto;

@end
