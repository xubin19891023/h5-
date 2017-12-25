//
//  WindowsOpenPage.m
//  乡货网
//
//  Created by Bill on 2017/5/9.
//  Copyright © 2017年 Bill. All rights reserved.
//

#import "WindowsOpenPage.h"

@implementation WindowsOpenPage

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self)
    {
        if([dict objectForKey:@"content"])
        {
            self.content = [dict  objectForKey:@"content"];
        }
        
        if([dict objectForKey:@"height"])
        {
            self.height = [dict  objectForKey:@"height"];
        }
        if([dict objectForKey:@"width"])
        {
            self.width = [dict  objectForKey:@"width"];
        }
        
        if([dict objectForKey:@"slide"])
        {
            self.slide = [dict  objectForKey:@"slide"];
        }
        
        if([dict objectForKey:@"name"])
        {
            self.name = [dict  objectForKey:@"name"];
        }
        
        if([dict objectForKey:@"align"])
        {
            self.align = [dict  objectForKey:@"align"];
        }
        
        if([dict objectForKey:@"type"])
        {
            self.type = [dict  objectForKey:@"type"];
        }
        
        if([dict objectForKey:@"callbackfun"])
        {
            self.callbackfun = [dict  objectForKey:@"callbackfun"];
        }
        
        if([dict objectForKey:@"shadow"])
        {
            self.shadow = [dict  objectForKey:@"shadow"];
        }
        
        if([dict objectForKey:@"toolsbar"])
        {
            self.toolsbar = [dict  objectForKey:@"toolsbar"];
//            self.toolsbar_name = [self.toolsbar  objectForKey:@"name"];
//            self.toolsbar_ioc = [self.toolsbar  objectForKey:@"ioc"];
//            self.toolsbar_onclick = [self.toolsbar  objectForKey:@"onclick"];
//            self.toolsbar_pasitions = [self.toolsbar  objectForKey:@"pasitions"];

        }
        
    }
    
    return self;
}


@end
