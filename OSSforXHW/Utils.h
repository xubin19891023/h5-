//
//  Utils.h
//  WoReader
//
//  Created by dzc on 16/1/18.
//  Copyright © 2016年 dzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

//获取颜色
+ (UIColor *)getColor:(NSString *)hexColor;

//日期转换
+ (NSString *)getStandardTimeWithTime:(NSString *)str;

//数字 中文转换
+ (NSString *)number2ChineseNumber:(NSInteger)num;

//uuid 获取
+ (NSString *) uuid;

//计算label
+ (CGSize) countLabelWithText:(NSString *)text Font:(CGFloat)font Width:(CGFloat)width;

//汉字转拼音
+ (NSString *)converterHanToPinyin:(NSString *)Han;

//获取网络状态
+ (NSString *) getNetworkStatus;

//获取设备信息
+ (NSDictionary *) getDeviceInfo;

//判断是否是手机号
+ (BOOL)valiMobile:(NSString *)mobile;

//判断是否是邮箱
+ (BOOL) validateEmail:(NSString *)email;

//与当前时间比较
+ (NSString *)intervalSinceNow: (NSString *) theDate;

//时间转化为字符串
+ (NSString *)TimeTransToStr:(NSDate *)date;

//需要重新请求
+ (BOOL) relogin;

//解析本地文件目录
+ (NSMutableArray *)createDictionaryWithTxt:(NSString *)contentText contentID:(NSString *)contentID withFirst:(BOOL) isFirst;

//默认配置
+ (void)defaultSettings;//默认阅读配置

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)url;

//文件操作
+ (NSString *)getFilePath:(NSString *)fileName Wifi:(BOOL)flag;
+ (void)deleteFile:(NSString *)fileName Wifi:(BOOL)flag;
+ (BOOL)isFileExisted:(NSString *)fileName Wifi:(BOOL)flag;
+ (void)deleteContentResourceWithContentID:(NSUInteger)contentID;


//Json转换
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;



+ (double)checkNetworkflow;
//打点
+ (void)clientDotInfo;
//阅读时长打点
+ (void)clientReadTimeDotInfoWithContentID:(NSString *)contentID;
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;
+ (BOOL) isEmpty:(NSString *) str;//判断全空格
//从图片中间截取图片
+(UIImage*)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool;
+(BOOL)isUnicom;//判断当前账号是不是联通账号
//查询当前字符所在段
+(NSUInteger)checkCurrentParagraphindex:(NSString *)substring currentWordIndex:(NSUInteger ) currentindex;
//查询当前当前段起始位置
+(NSUInteger)checkCurrentWordindex:(NSString *)substring currentParagraphindex:(NSUInteger ) currentP;
//统计某个字符出现次数
+(NSUInteger)occurenceOfString:(NSString *)substring currentWordIndex:(NSString *) filterStr;

//获取农历
+(NSString*)getChineseCalendarWithDate:(NSString *)date;
+(NSString*)getCurrentTimes;//获取当前时间
+(NSString*)getCurrentTimesForlabel;//2017-11-12
+ (NSString *)convertHexStrToString:(NSString *)str;//16进制转字符串
+ (NSString *)convertStringToHexStr:(NSString *)str;//字符串转16进制
//+ (NSString *)notRounding:(float)price afterPoint:(int)position;//四舍五入
+ (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV;//四舍五入
@end
