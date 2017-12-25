//
//  Toolsbar.m
//  乡货网
//
//  Created by Bill on 2017/5/9.
//  Copyright © 2017年 Bill. All rights reserved.
//

#import "Toolsbar.h"

@implementation Toolsbar

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self)
    {
        self.name = [dict  objectForKey:@"name"];
        self.ioc = [dict  objectForKey:@"ioc"];
        self.onclick = [dict  objectForKey:@"onclick"];
        self.pasitions = [dict  objectForKey:@"pasitions"];
    }
    return self;
}
@end
