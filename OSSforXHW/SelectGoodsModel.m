//
//  SelectGoodsModel.m
//  OSSforXHW
//
//  Created by iOS on 2017/10/28.
//  Copyright © 2017年 XHW. All rights reserved.
//

#import "SelectGoodsModel.h"

@implementation SelectGoodsModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"])
        self.ID = [value integerValue];
    
}
@end

