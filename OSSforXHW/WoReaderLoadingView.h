//
//  WoReaderLoadingView
//  WoReader
//
//  Created by junlx  on 12-9-3.
//  Copyright (c) 2012年 ZTE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
//@class MBProgressHUD;
typedef void (^retrybutton)(UIButton *btn);

@interface WoReaderLoadingView : UIView <MBProgressHUDDelegate>
{
    MBProgressHUD *loadingHUD;
    MBProgressHUD *noticeHUD;
    MBProgressHUD *progressHUD;
}

@property (nonatomic, assign) BOOL isReadingText;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIButton *block;
@property (nonatomic, strong) UIView *backVi;

+ (WoReaderLoadingView *)sharedInstance;

- (void)HUDShow:(NSString *)labelText yOffset:(NSString *)yOffset;

- (void)HUDHide;

- (void)HUDHideWithNoAnimation;

- (void)showNoticeWithTitle:(NSString *)title yOffset:(NSString *)yOffset;

- (void)showNoticeWithTitle:(NSString *)title yOffset:(NSString *)yOffset delayTime:(NSInteger) delayTime;//延时显示

- (void)showWithLabelDeterminateHorizontalBar;

- (void)HUDNoAutoHide;

- (void)showNoticeWithTitleNoAutoHide:(NSString *)title yOffset:(NSString *)yOffset;

- (void)showOrHideTheWebViewLoadFaildHintView:(BOOL)show onView:(UIView *)view withRetryButton:(retrybutton)button;//网络加载失败提示视图
- (void)showGif:(NSString *)str;

- (void)hideGif;


@end
