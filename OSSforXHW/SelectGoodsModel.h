//
//  SelectGoodsModel.h
//  OSSforXHW
//
//  Created by iOS on 2017/10/28.
//  Copyright © 2017年 XHW. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface SelectGoodsModel : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *goodsType;
@property (nonatomic,strong) NSString *unitName;
@property (nonatomic,strong) NSString *sku;
@property (nonatomic,assign) double require_weight;
@property (nonatomic,assign) double standard_price;
@property (nonatomic,assign) double totalMoney;
@property (nonatomic,assign) long ID;

@end
//{
//    id = 1;
//    name = apple;
//    "require_weight" = 88;
//    sku = 123456;
//    "standard_price" = "12.88";
//    totalMoney = "8.880000000000001";
//    unitName = "\U516c\U65a4";
//    weightType = 659;
//}
