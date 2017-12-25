//
//  MessageObj.h
//  XHWBaseAPI
//
//  Created by iOS on 2017/9/7.
//  Copyright © 2017年 XHW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSObject+BGModel.h"


@interface MessageObj : NSObject

@property (nonatomic , strong) NSString *_j_business;
@property (nonatomic , strong) NSString *_j_msgid;
@property (nonatomic , strong) NSString *_j_uid;
@property (nonatomic , strong) NSString *isRead;
@property (nonatomic , strong) NSString *time;
@property (nonatomic , strong) NSString *body;
@property (nonatomic , strong) NSString *subtitle;
@property (nonatomic , strong) NSString *title;
@property (nonatomic , strong) NSString *badge;
@property (nonatomic , strong) NSString *content_available;
@property (nonatomic , strong) NSString *sound;
@property (nonatomic , strong) NSString *category;



@end


//@interface alert:NSObject
//@property (nonatomic , strong) NSString *body;
//@property (nonatomic , strong) NSString *subtitle;
//@property (nonatomic , strong) NSString *title;
//@end
//
//
//@interface aps: NSObject
//@property (nonatomic , strong) NSString *badge;
////@property (nonatomic , strong) NSString *content_available;
//@property (nonatomic , strong) NSString *sound;
//@property (nonatomic , strong) alert *alert;
//
//@end
//
//
//@interface MessageObj : NSObject
//
//@property (nonatomic , strong) NSString *_j_business;
//@property (nonatomic , strong) NSString *_j_msgid;
//@property (nonatomic , strong) NSString *_j_uid;
//@property (nonatomic , strong) NSString *isRead;
//@property (nonatomic , strong) NSString *time;
//@property (nonatomic , strong) aps *aps;
//@end

