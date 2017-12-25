//
//  CQPlaceholderView.m
//  CommonPlaceholderView
//
//  Created by 蔡强 on 2017/5/15.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

#import "CQPlaceholderView.h"

@implementation CQPlaceholderView

#pragma mark - 构造方法
/**
 构造方法
 
 @param frame 占位图的frame
 @param type 占位图的类型
 @param delegate 占位图的代理方
 @return 指定frame、类型和代理方的占位图
 */
- (instancetype)initWithFrame:(CGRect)frame type:(CQPlaceholderViewType)type delegate:(id)delegate{
    if (self = [super initWithFrame:frame]) {
        // 存值
        _type = type;
        _delegate = delegate;
        // UI搭建
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI搭建
/** UI搭建 */
- (void)setUpUI{
    self.backgroundColor = [UIColor whiteColor];
    
    //------- 图片在正中间 -------//
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 - 50, self.frame.size.height / 2 - 50, 100, 100)];
    [self addSubview:imageView];
    
    //------- 说明label在图片下方 -------//
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10, self.frame.size.width, 20)];
    descLabel.textColor = [UIColor grayColor];
    [self addSubview:descLabel];
    descLabel.textAlignment = NSTextAlignmentCenter;
    
    //------- 按钮在说明label下方 -------//
    UIButton *reloadButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 - 60, CGRectGetMaxY(descLabel.frame) + 5, 120, 25)];
    [self addSubview:reloadButton];
    [reloadButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    reloadButton.layer.borderColor = [UIColor redColor].CGColor;
    reloadButton.layer.borderWidth = 0.5f;
    reloadButton.layer.cornerRadius = 10.0f;
    reloadButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [reloadButton setBackgroundColor:[UIColor whiteColor]];
    [reloadButton addTarget:self action:@selector(reloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //------- 根据type创建不同样式的UI -------//
    switch (_type) {
        case CQPlaceholderViewTypeNoNetwork: // 没网
        {
            imageView.image = [UIImage imageNamed:@"load_failed"];
            descLabel.text = @"网络不给力，请检查网络";
            [reloadButton setTitle:@"重试加载" forState:UIControlStateNormal];
        }
            break;
            
        case CQPlaceholderViewTypeNoOrder: // 没订单
        {
            imageView.image = [UIImage imageNamed:@"订单无数据"];
            descLabel.text = @"暂无订单";
            [reloadButton setTitle:@"没有拉到" forState:UIControlStateNormal];
        }
            break;
            
        case CQPlaceholderViewTypeNoGoods: // 没商品
        {
            imageView.image = [UIImage imageNamed:@"nomsg"];
            descLabel.text = @"暂无消息数据";
            [reloadButton setTitle:@"点击返回首页" forState:UIControlStateNormal];
        }
            break;
            
        case CQPlaceholderViewTypeBeautifulGirl: // 妹纸
        {
            imageView.image = [UIImage imageNamed:@"妹纸"];
            descLabel.text = @"你会至少在此停留3秒钟";
            [reloadButton setTitle:@"不爱妹纸" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 重新加载按钮点击
/** 重新加载按钮点击 */
- (void)reloadButtonClicked:(UIButton *)sender{
    // 代理方执行方法
    if ([_delegate respondsToSelector:@selector(placeholderView:reloadButtonDidClick:)]) {
        [_delegate placeholderView:self reloadButtonDidClick:sender];
    }
    // 从父视图上移除
    [self removeFromSuperview];
}

@end
