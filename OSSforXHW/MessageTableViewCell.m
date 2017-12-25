//
//  MwssageTableViewCell.m
//  XHWBaseAPI
//
//  Created by iOS on 2017/9/8.
//  Copyright © 2017年 XHW. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, self.contentView.bounds.size.width-20, 30)];
        _titleLable.font = [UIFont systemFontOfSize:16];
//        _titleLable.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        [self.contentView addSubview:_titleLable];
        
        _bodyLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 40, _titleLable.bounds.size.width, 30)];
        _bodyLable.numberOfLines = 0;
        _bodyLable.font = [UIFont systemFontOfSize:14];
        _bodyLable.textColor = [UIColor colorWithRed:68/255.0f green:68/255.0f blue:68/255.0f alpha:1];
        [self.contentView addSubview:_bodyLable];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 75, self.contentView.bounds.size.width-20, 20)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor colorWithRed:68/255.0f green:68/255.0f blue:68/255.0f alpha:1];
        [self.contentView addSubview:_timeLabel];

        _tagView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 10, 10)];
        _tagView.clipsToBounds = YES;
        _tagView.layer.cornerRadius = 5;
        [self.contentView addSubview:_tagView];
        
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        _arrowView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-30, 40, 20, 20);
        _arrowView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_arrowView];
       
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 99.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
        _line.backgroundColor = [UIColor colorWithRed:68/255.0f green:68/255.0f blue:68/255.0f alpha:1];
        [self.contentView addSubview:_line];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
