//
//  Utils.m
//  WoReader
//
//  Created by dzc on 16/1/18.
//  Copyright © 2016年 dzc. All rights reserved.
//

#import "Utils.h"
#import "AppDelegate.h"
#import <CoreFoundation/CoreFoundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <net/if.h>
#import <mach/mach_host.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <dlfcn.h>
#import <sys/xattr.h>

#import <Foundation/Foundation.h>

@implementation Utils


+ (UIColor *)getColor:(NSString *)hexColor
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
//json转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}

//字典转json
+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

+ (NSString *)getStandardTimeWithTime:(NSString *)str
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *tmpDate = [date dateFromString:str];
    [date setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [date stringFromDate:tmpDate];
    return dateString;
}

+ (NSString *)number2ChineseNumber:(NSInteger)num
{
    NSArray *unitArray = [[NSArray alloc]initWithObjects:@"",@"十",@"百",@"千",@"万",@"亿", nil];
    NSArray *numArray = [[NSArray alloc]initWithObjects:@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",nil];
    
    NSMutableString *returnStr = [[NSMutableString alloc] init];
    NSString *numStr = [NSString stringWithFormat:@"%ld",(long)num];
    for (NSInteger i = numStr.length-1; i!=-1; i--)
    {
        int r = (int)num/pow(10, i);
        if (r%10 !=0)
        {
            NSString *s = [NSString stringWithFormat:@"%d",r];
            NSString *t = [s substringWithRange:NSMakeRange(s.length-1,1)];
            [returnStr appendString:[numArray objectAtIndex:[t intValue]-1]];
            [returnStr appendString:[unitArray objectAtIndex:i]];
        }
        else
        {
            if (![returnStr hasSuffix:@"零"])
            {
                [returnStr appendString:@"零"];
            }
        }
    }
    if ([returnStr hasSuffix:@"零"])
    {
        if(returnStr.length > 1)
        {
            return [returnStr substringWithRange:NSMakeRange(0,returnStr.length-1)];
        }
    }
    return returnStr;
}


+(NSString*) uuid
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    NSLog(@"uuid:%@",result);
    return result;
}

//计算label
+ (CGSize) countLabelWithText:(NSString *)text Font:(CGFloat)font Width:(CGFloat)width
{
    
    CGSize titleSize;
    
    titleSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    
    //    label.text = [NSString stringWithFormat:@"%@",text];
    //    label.font = [UIFont systemFontOfSize:font];
    //    label.numberOfLines =0;
    //    [label sizeToFit];
    return titleSize;
}


+ (NSString *) getNetworkStatus
{
    struct sockaddr_in hostAddress;
    bzero(&hostAddress, sizeof(hostAddress));
    hostAddress.sin_len = sizeof(hostAddress);
    hostAddress.sin_family = AF_INET;
    SCNetworkReachabilityRef reachAbility = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&hostAddress);
    
    SCNetworkReachabilityFlags    flags;
    SCNetworkReachabilityGetFlags(reachAbility,&flags);
    CFRelease(reachAbility);
    
    if ((flags & kSCNetworkFlagsReachable))
    {
        if ((flags & kSCNetworkReachabilityFlagsIsWWAN)) {
            return @"3G";
        } else {
            return @"WiFi";
        }
    }else{
        return @"NotReachable";
    }
}


#pragma mark - File Operation
+ (NSString *)getFilePath:(NSString *)fileName Wifi:(BOOL)flag
{
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory;
    if (flag)
    {
//        documentsDirectory = APPDELEGATE.epubWifiDirectory;
    }
    else
    {
//        documentsDirectory = APPDELEGATE.downloadDirectory;
    }
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    return filePath;
}

//判断输入是否是手机号码

+ (BOOL)valiMobile:(NSString *)mobile
{
    if (mobile.length !=11)
    {
        return NO;
    }
    else
    {
//        /**
//         * 移动号段正则表达式
//         */
//        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
//        /**
//         * 联通号段正则表达式
//         */
//        NSString *CU_NUM = @"^(13[0-2]|(175)|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
//        /**
//         * 电信号段正则表达式
//         */
//        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        
        //只要是电话号码
        NSString *mobile_NUM = @"^((1[3-8]))\\d{9}$";
        NSPredicate *pred4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile_NUM];
        BOOL isMatch4 = [pred4 evaluateWithObject:mobile];
        if (isMatch4) {
            return  YES;
        }
        else{
        
            return NO;
        }
        
//        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
//        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
//        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
//        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
//        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
//        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
//        if (isMatch1 || isMatch2 || isMatch3)
//        {
//            return YES;
//        }
//        else
//        {
//            return NO;
//        }
    }
    return NO;
}

+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//与当前时间比较
+ (NSString *)intervalSinceNow:(NSString *)theDate
{
    NSArray *timeArray = [theDate componentsSeparatedByString:@"."];
    theDate = [timeArray objectAtIndex:0];
    
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    date.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d = [date dateFromString:theDate];
    
    NSTimeInterval late = [d timeIntervalSince1970]*1;
    
    NSDate *dat = [NSDate date];
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    NSString *timeString = @"";
    
    NSTimeInterval cha=now-late;
    
    if (cha/60<1) {
        timeString = [NSString stringWithFormat:@"%f", cha];
        timeString = [timeString substringToIndex:timeString.length-7];
        //        timeString=[NSString stringWithFormat:@"%@秒前", timeString];
        timeString=[NSString stringWithFormat:@"刚刚"];
        
        
    }
    
    if (cha/60>1&&cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        
    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@天前", timeString];
        
    }
    return timeString;
}


#pragma mark 生成目录


+ (BOOL)isFileExisted:(NSString *)fileName Wifi:(BOOL)flag
{
    NSString *filePath = [self getFilePath:fileName  Wifi:flag];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        return YES;
    }
    return NO;
}

+ (void)deleteFile:(NSString *)fileName Wifi:(BOOL)flag
{
    if([self isFileExisted:fileName Wifi:flag])
    {
        NSString *filePath = [self getFilePath:fileName Wifi:flag];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

+ (void) deleteMagazineHtml:(long long) chapterID
{
    //删除杂志缓存文件
    NSArray *appSupportArray = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *directoryName = @"MagazineHtml";
    NSString *appSupportDirectory = [appSupportArray objectAtIndex:0];
    NSString *directoryPath = [appSupportDirectory stringByAppendingPathComponent:directoryName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath])
    {
        NSString *filepath=[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%lld.html",chapterID]];
        [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
    }
}











+ (NSString *)TimeTransToStr:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [df stringFromDate:date];
    
    NSDate *tmpdate = [df dateFromString:dateString];
    //转换时间格式
    NSDateFormatter *df2 = [[NSDateFormatter alloc]init];//格式化
    [df2 setDateFormat:@"yyyyMMddHHmmss"];
    [df2 setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    dateString = [df2 stringFromDate:tmpdate];
    
    return dateString;
}


+ (double)checkNetworkflow
{
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1)
    {
        return 0;
    }
    
    uint32_t iBytes     = 0;
    uint32_t oBytes     = 0;
    uint32_t allFlow    = 0;
    uint32_t wifiIBytes = 0;
    uint32_t wifiOBytes = 0;
    uint32_t wifiFlow   = 0;
    uint32_t wwanIBytes = 0;
    uint32_t wwanOBytes = 0;
    uint32_t wwanFlow   = 0;
#ifdef __LP64__
    struct timeval32 time;
#else
    struct timeval time;
#endif
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
    {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        if (ifa->ifa_data == 0)
            continue;
        // Not a loopback device.
        // network flow
        if (strncmp(ifa->ifa_name, "lo", 2))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
            allFlow = iBytes + oBytes;
#ifdef __LP64__
            time = if_data->ifi_lastchange;
#else
            time = if_data->ifi_lastchange;
#endif
        }
        //wifi flow
        if (!strcmp(ifa->ifa_name, "en0"))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            wifiIBytes += if_data->ifi_ibytes;
            wifiOBytes += if_data->ifi_obytes;
            wifiFlow    = wifiIBytes + wifiOBytes;
        }
        //3G and gprs flow
        if (!strcmp(ifa->ifa_name, "pdp_ip0"))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            wwanIBytes += if_data->ifi_ibytes;
            wwanOBytes += if_data->ifi_obytes;
            wwanFlow    = wwanIBytes + wwanOBytes;
        }
    }
    freeifaddrs(ifa_list);
    return ((double)(wifiFlow+wwanFlow));//B
    
}
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{

    NSComparisonResult result = [oneDay compare:anotherDay];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}

+ (BOOL) isEmpty:(NSString *) str {
    
    if (!str) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

//从图片中间截取图片
+(UIImage*)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool
{
    
    /*如若centerBool为Yes则是由中心点取mCGRect范围的图片*/
    
    
    float imgwidth = image.size.width;
    float imgheight = image.size.height;
    float viewwidth = mCGRect.size.width;
    float viewheight = mCGRect.size.height;
    CGRect rect;
    if(centerBool){
        if (imgwidth>=viewwidth&&imgheight>=viewheight) {
            
            rect = CGRectMake((imgwidth-viewwidth)/2, (imgheight-viewheight)/2, viewwidth, viewheight);
        }
        else if (imgwidth<viewwidth&&imgheight>=viewheight){
        
         rect = CGRectMake(0, (imgheight-viewheight)/2, imgwidth, viewheight);
        
        }
        else if (imgwidth>=viewwidth&&imgheight<viewheight){
            
            rect = CGRectMake((imgwidth-viewwidth)/2, 0, viewwidth, imgheight);
            
        }
    
        else if (imgwidth<viewwidth&&imgheight<viewheight){
        
            rect = CGRectMake(0, 0, imgwidth, imgheight);
        
        }
        else{
        
            rect = CGRectMake((imgwidth-viewwidth)/2, (imgheight-viewheight)/2, viewwidth, viewheight);
        }
    
    }

    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}


+(NSUInteger)occurenceOfString:(NSString *)substring currentWordIndex:(NSString *) filterStr
{
    NSUInteger cnt = 0, length = [substring length];
    NSRange range = NSMakeRange(0, length);
    while(range.location != NSNotFound)
    {
        range = [substring rangeOfString: filterStr options:0 range:range];
        if(range.location != NSNotFound)
        {
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            cnt++; 
        }
    }
    return cnt;
}

+(NSUInteger)checkCurrentParagraphindex:(NSString *)substring currentWordIndex:(NSUInteger ) currentindex
{
    NSUInteger cnt = 1, length = [substring length];
    NSRange range = NSMakeRange(0, length);
    while(range.location != NSNotFound)
    {
        range = [substring rangeOfString: @"\n" options:0 range:range];
        if(range.location != NSNotFound)
        {
            if (range.location >= currentindex)
            {
                break;
            }
            
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            cnt++;
        }
    }
    return cnt;
}

+(NSUInteger)checkCurrentWordindex:(NSString *)substring currentParagraphindex:(NSUInteger ) currentP
{
    NSUInteger cnt = 1, length = [substring length];
    NSRange range = NSMakeRange(0, length);
    //NSUInteger startP = 0;
    
    if (currentP == 1)
    {
        return 1;
    }
    
    while(range.location != NSNotFound)
    {
        range = [substring rangeOfString: @"\n" options:0 range:range];
        if(range.location != NSNotFound)
        {
            NSLog(@"location=%lu",(unsigned long)range.location);
            NSLog(@"count=%lu",(unsigned long)cnt);
            cnt++;
            if (cnt >= currentP)
            {
                break;
            }
            
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
 
        }
    }
    
    if (range.location > 1)
    {
        return range.location;
    }
    else
    {
        return 1;
    }
    
}

//获取农历
+(NSString*)getChineseCalendarWithDate:(NSString *)dateString{
    
    NSDateFormatter *date1=[[NSDateFormatter alloc] init];
    [date1 setDateFormat:@"yyyyMMdd"];
    NSDate *tmpDate = [date1 dateFromString:dateString];
    
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:tmpDate];
    
    NSLog(@"%ld_%ld_%ld  %@",(long)localeComp.year,(long)localeComp.month,(long)localeComp.day, localeComp.date);
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@年%@%@",y_str,m_str,d_str];
    
    return chineseCal_str;
}
+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}
+(NSString*)getCurrentTimesForlabel{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}
//将十六进制的字符串转换成NSString则可使用如下方式:
+ (NSString *)convertHexStrToString:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    NSString *string = [[NSString alloc]initWithData:hexData encoding:NSUTF8StringEncoding];
    return string;
}
//将NSString转换成十六进制的字符串则可使用如下方式:
+ (NSString *)convertStringToHexStr:(NSString *)str {
    if (!str || [str length] == 0) {
        return @"";
    }
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}
////四舍五入
//+ (NSString *)notRounding:(float)price afterPoint:(int)position{
//       NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];    NSDecimalNumber *ouncesDecimal;
//       NSDecimalNumber *roundedOunces;
//      ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
//    return [NSString stringWithFormat:@"%@",roundedOunces];
//}
+ (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}
@end
