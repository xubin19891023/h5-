//
//  MwssageTableViewCell.h
//  XHWBaseAPI
//
//  Created by iOS on 2017/9/8.
//  Copyright © 2017年 XHW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property (nonatomic , strong) UILabel *titleLable;
@property (nonatomic , strong) UILabel *bodyLable;
@property (nonatomic , strong) UILabel *timeLabel;
@property (nonatomic , strong) UIView *tagView;
@property (nonatomic , strong) UIImageView *arrowView;
@property (nonatomic , strong) UIView *line;

@end
