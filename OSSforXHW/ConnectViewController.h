//
//  ConnectViewController.h
//  BLETR
//
//  Created by D500 user on 12/9/26.
//  Copyright (c) 2012 ISSC Technologies Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBController.h"
#import "DeviceInfo.h"

@interface ConnectViewController : CBController<UITableViewDataSource, UITextViewDelegate, UITableViewDelegate>
{
//    IBOutlet UITableView *devicesTableView;

    NSTimer *refreshDeviceListTimer;
    //Derek
    DeviceInfo *deviceInfo;
    MyPeripheral *controlPeripheral;
    NSMutableArray *connectedDeviceInfo;//stored for DeviceInfo object
    NSMutableArray *connectingList;//stored for MyPeripheral object
    
}
@property (nonatomic , strong) UITableView *devicesTableView;

@end
