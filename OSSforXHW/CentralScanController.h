//
//  CentralScanController.h
//  ble4.0
//
//  Created by rejoin on 15/4/8.
//  Copyright (c) 2015年 rejoin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CentralScanController : UIViewController
{
    NSTimer *refreshDeviceListTimer;
 
    NSMutableArray *connectingList;//stored for MyPeripheral object
    
}
@end
