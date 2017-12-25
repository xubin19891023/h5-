//
//  WindowsOpenPage.h
//  乡货网
//
//  Created by Bill on 2017/5/9.
//  Copyright © 2017年 Bill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WindowsOpenPage : NSObject

@property (nonatomic, strong) NSString      *content;  //url
@property (nonatomic, strong) NSString      *height;   //window 高度
@property (nonatomic, strong) NSString      *name;     // 标题名
@property (nonatomic, strong) NSString      *slide;     //进场模式
@property (nonatomic, strong) NSString      *align;  //对齐位置
@property (nonatomic, strong) NSString      *type;  //标题栏是否显示
@property (nonatomic, strong) NSString      *width;   //window 宽度
@property (nonatomic, strong) NSString      *shadow;    // 阴影层
@property (nonatomic, strong) NSString      *callbackfun;  //js回调方法
@property (nonatomic, strong) NSMutableArray  *toolsbar;      //标题栏


- (id)initWithDictionary:(NSDictionary *)dict;
@end


