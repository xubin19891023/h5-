//
//  MessageDetailViewController.h
//  XHWBaseAPI
//
//  Created by iOS on 2017/9/9.
//  Copyright © 2017年 XHW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageObj.h"
@interface MessageDetailViewController : UIViewController
@property (nonatomic , strong) NSString *_j_msgid;
@property (nonatomic , strong) MessageObj *megObj;
@end
