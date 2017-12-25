//
//  showLabel.m
//  OSSforXHW
//
//  Created by iOS on 2017/9/27.
//  Copyright © 2017年 XHW. All rights reserved.
//

#import "showLabel.h"
#import "Masonry.h"
@interface showLabel (){
    
    UILabel *downLabel;
}


@end
@implementation showLabel

-(instancetype)initWithFrame:(CGRect)frame upStr:(NSString *)upstr downStr:(NSString *)downstr{
   
    if (self = [super initWithFrame:frame]) {
        
        self.upLabel = [[UILabel alloc] init];
        self.upLabel.textColor = [UIColor whiteColor];
        self.upLabel.font = [UIFont systemFontOfSize:35];
        self.upLabel.textAlignment = 1;
        self.upLabel.text = upstr;
        [self addSubview:self.upLabel];
        [self.upLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.width.equalTo(self);
            make.height.mas_equalTo(self.frame.size.height*2/3);
            make.top.equalTo(self.mas_top);
        }];
        
        downLabel = [[UILabel alloc] init];
        downLabel.textColor = [UIColor whiteColor];
        downLabel.font = [UIFont systemFontOfSize:13];
        downLabel.textAlignment = 1;
        downLabel.text = downstr;
        [self addSubview:downLabel];
        [downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.width.equalTo(self);
            make.height.mas_equalTo(self.frame.size.height/3);
            make.top.equalTo(self.upLabel.mas_bottom);
        }];
        
        if ([upstr containsString:@"."]) {
            // 创建Attributed
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:self.upLabel.text];
            
            
            // 需要改变的第一个文字的位置
            NSUInteger firstLoc = [[noteStr string] rangeOfString:@"."].location + 1;
            // 需要改变的最后一个文字的位置
            //        NSUInteger secondLoc = [[noteStr string] rangeOfString:@"元"].location;
            // 需要改变的区间
            NSRange range = NSMakeRange(firstLoc, noteStr.length - firstLoc);
            // 改变颜色
            //        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range];
            // 改变字体大小及类型
            [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
            // 为label添加Attributed
            [self.upLabel setAttributedText:noteStr];
        }
        

        else {
            NSLog(@"没有小数点");
        }
    }
    return self;
}

@end
