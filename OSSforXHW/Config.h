//
//  Config.h
//  乡货网
//
//  Created by Bill on 2017/5/10.
//  Copyright © 2017年 Bill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//|| CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size))

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define VERSIONOFFSETY         20  // (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? 20 : 0)
#define TitleHeight            45
#ifdef DEBUG // 调试状态, 打开LOG功能
#define MTDetailLog(fmt, ...) NSLog((@"--------------------------> %@ [Line %d] \n"fmt "\n\n"), [[NSString stringWithFormat:@"%s",__FILE__] lastPathComponent], __LINE__, ##__VA_ARGS__);
#else // 发布状态, 关闭LOG功能
#define MTDetailLog(...)
#endif

#define    MENU           @"MENU"  //
#define    BACK           @"BACK"  //
#define    REFRESH        @"REFRESH"  //

#define    LEFT           @"LEFT"  //
#define    CENTER         @"CENTER"//
#define    RIGHT          @"RIGHT"  //
#define    BOTTOM         @"BOTTOM"
#define    NONE           @"NONE"
#define    TOP            @"TOP"
#define    UP             @"UP"


#define MYBUNDLE_NAME   @"XhBundle.bundle"
#define MYBUNDLE_PATH   [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:MYBUNDLE_NAME]
#define MYBUNDLE        [NSBundle bundleWithPath:MYBUNDLE_PATH]
@end
