//
//  Toolsbar.h
//  乡货网
//
//  Created by Bill on 2017/5/9.
//  Copyright © 2017年 Bill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Toolsbar : NSObject

@property (nonatomic, strong) NSString      *name;  //标题栏按钮名字规定为两个字符
@property (nonatomic, strong) NSString      *ioc;  //为指定按钮格式,可以是: MENU/BACK/ REFRESH(菜单/返回/刷新)
@property (nonatomic, strong) NSString      *pasitions;  //标题栏按钮的位置,可以是: LEFT/CENTER/RIGHT
@property (nonatomic, strong) NSString      *onclick;  //指定标题栏按钮点击后调用的JS方法,直接指定方法名

- (id)initWithDictionary:(NSDictionary *)dict;

@end
