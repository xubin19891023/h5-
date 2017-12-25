//
//  ScanCodeViewController.h
//  demo
//
//  Created by gaofu on 2017/4/10.
//  Copyright © 2017年 siruijk. All rights reserved.
//


#import <UIKit/UIKit.h>
@class RegisterHandler;


typedef void(^CallBackBlcok) (id data);//1

@protocol ScanCodeDelegate <NSObject>

@optional

- (void) callBackResult:(NSString *)responseStr;

@end

@interface ScanCodeViewController : UIViewController

@property (nonatomic, assign) BOOL  isJSCallBack;
@property (nonatomic, strong) CallBackBlcok myBlock;
@property (nonatomic, assign) id <ScanCodeDelegate> delegate;

@end
