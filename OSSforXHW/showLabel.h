//
//  showLabel.h
//  OSSforXHW
//
//  Created by iOS on 2017/9/27.
//  Copyright © 2017年 XHW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface showLabel : UIView
@property (nonatomic , strong) UILabel *upLabel;
- (instancetype)initWithFrame:(CGRect)frame upStr:(NSString *)upstr downStr:(NSString *)downstr;

@end
