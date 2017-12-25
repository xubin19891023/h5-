//
//  CentralScanController.m
//  ble4.0
//
//  Created by rejoin on 15/4/8.
//  Copyright (c) 2015年 rejoin. All rights reserved.
//

#import "CentralScanController.h"
#import "BLEServer.h"
#import "PeriperalInfo.h"
#import "MBProgressHUD.h"
#import "Utils.h"

@interface CentralScanController ()<UITableViewDataSource,UITableViewDelegate,BLEServerDelegate,MBProgressHUDDelegate>

@property (strong, nonatomic) UITableView *myTableView;
@property (strong,nonatomic)BLEServer * defaultBLEServer;

@property (nonatomic)BOOL readState;
@property (nonatomic)BOOL notifyState;

@property (nonatomic , strong) NSMutableArray *connectedDeviceInfo;


@end

@implementation CentralScanController


- (NSMutableArray *)connectedDeviceInfo{
    if (_connectedDeviceInfo == nil) {
        _connectedDeviceInfo = [NSMutableArray new];
    }
    return _connectedDeviceInfo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    connectingList =[NSMutableArray new];
    // Do any additional setup after loading the view.
    
    self.title = @"蓝牙电子秤";

    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    selectedBtn.frame = CGRectMake(0, 0, 30, 30);
    
    [selectedBtn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [selectedBtn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateHighlighted];
    [selectedBtn addTarget:self action:@selector(selectedBtn222) forControlEvents:UIControlEventTouchUpInside];
    selectedBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0, 0,-10);
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:selectedBtn];
    
    self.navigationItem.rightBarButtonItem =selectItem;

    self.defaultBLEServer = [BLEServer defaultBLEServer];
    self.defaultBLEServer.delegate = self;
    _readState=NO;
    _notifyState=NO;
    [self.defaultBLEServer startScan];

    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [self.view addSubview:self.myTableView];
    
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1,1)];
    self.myTableView.tableFooterView = footview;
//    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

}
-(void)selectedBtn222{

    [self.defaultBLEServer stopScan:YES];
    self.defaultBLEServer.delegate = self;
    [self.defaultBLEServer startScan];
    [self.myTableView reloadData];

}
#pragma mark -- bleserver delegate
-(void)didStopScan
{
    dispatch_async(dispatch_get_main_queue(), ^{
    });
}

-(void)didFoundPeripheral
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"  ------1111-----%ld",self.defaultBLEServer.discoveredPeripherals.count);

        [self.myTableView reloadData];
    });
}

-(void)didDisconnect
{
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [SVProgressHUD dismissWithError:@"断开连接"];
    //        [self.navigationController popToRootViewControllerAnimated:YES];
    //    });
}

#pragma mark -- tableview delegate
#pragma mark 每个分组的数目
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section

{
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.font = [UIFont systemFontOfSize:13];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 60;
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = nil;
    switch (section) {
        case 0:
            title = @"已连接设备:";
            break;
        case 1:
            title = @"已发现设备:";
            break;
            
        default:
            break;
    }
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"----------2222----🐶%ld",_connectedDeviceInfo.count);

    switch (section) {
        case 0:
            return [self.connectedDeviceInfo count];
        case 1:
            return [self.defaultBLEServer.discoveredPeripherals count];
        default:
            return 0;
    }

//    return [self.defaultBLEServer.discoveredPeripherals count];
}
#pragma mark 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

//    [self.defaultBLEServer connect:self.defaultBLEServer.discoveredPeripherals[indexPath.row] withFinishCB:^(CBPeripheral *peripheral, BOOL status, NSError *error) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            if (status) {
//                
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                hud.delegate = self;
//                hud.mode = MBProgressHUDModeText;
//                hud.labelText = [NSString stringWithFormat:@"%@已经成功连接",peripheral.name];
//                //当需要消失的时候:
//                [hud hide:YES afterDelay:2];
//                
//    
//            }else{
////                [SVProgressHUD dismissWithError:@"连接失败"];
//            }
//        });
//        
//    }];
    switch (indexPath.section) {
        case 0:
        {
//            PeriperalInfo *p = [_connectedDeviceInfo objectAtIndex:indexPath.row];
//            controlPeripheral = deviceInfo.myPeripheral;
            [self.defaultBLEServer stopScan:YES];
            if (refreshDeviceListTimer) {
                [refreshDeviceListTimer invalidate];
                refreshDeviceListTimer = nil;
            }
            
        }
            break;
        case 1:
        {
            //Derek
            NSUInteger count = [self.defaultBLEServer.discoveredPeripherals count];
            if ((count != 0) && count > indexPath.row) {
                PeriperalInfo *tmpPeripheral = [self.defaultBLEServer.discoveredPeripherals objectAtIndex:indexPath.row];
                [self.defaultBLEServer connect:self.defaultBLEServer.discoveredPeripherals[indexPath.row] withFinishCB:^(CBPeripheral *peripheral, BOOL status, NSError *error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (status) {
//                            
//                            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                            hud.delegate = self;
//                            hud.mode = MBProgressHUDModeText;
//                            hud.labelText = [NSString stringWithFormat:@"%@已经成功连接",peripheral.name];
//                            //当需要消失的时候:
//                            [hud hide:YES afterDelay:2];
//                            [self.defaultBLEServer.discoveredPeripherals replaceObjectAtIndex:indexPath.row withObject:tmpPeripheral];
                           
                             [self.defaultBLEServer.discoveredPeripherals removeObject:tmpPeripheral];
                            [self.connectedDeviceInfo addObject:tmpPeripheral];
                            [self.myTableView reloadData];
                            
                        }else{
                            //                [SVProgressHUD dismissWithError:@"连接失败"];
                        }
                    });
                    
                }];

                
               
            }
            break;
        }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
#pragma mark cell显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

//    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    if (self.defaultBLEServer.discoveredPeripherals) {
//        PeriperalInfo *pi = self.defaultBLEServer.discoveredPeripherals[indexPath.row];
//        cell.textLabel.text = pi.name;
//        
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//   
//    
//
//    return cell;
    
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
        {
            //NSLog(@"[ConnectViewController] CellForRowAtIndexPath section 0, Row = %d",[indexPath row]);
            cell = [tableView dequeueReusableCellWithIdentifier:@"connectedList1"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"connectedList1"];
            }
            PeriperalInfo *tmpDeviceInfo = [_connectedDeviceInfo objectAtIndex:indexPath.row];
            cell.textLabel.text = tmpDeviceInfo.name;
            cell.detailTextLabel.text = @"已连接";
            cell.accessoryView = nil;
            if (cell.textLabel.text == nil)
                cell.textLabel.text = @"未知";
            
            UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [accessoryButton addTarget:self action:@selector(actionButtonDisconnect1)  forControlEvents:UIControlEventTouchUpInside];
            accessoryButton.tag = indexPath.row;
            [accessoryButton setTitle:@"断开连接" forState:UIControlStateNormal];
            [accessoryButton setFrame:CGRectMake(0,0,100,35)];
            cell.accessoryView  = accessoryButton;
            
        }
            break;
            
        case 1:
        {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"devicesList1"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"devicesList1"];
            }
            PeriperalInfo *tmpPeripheral = self.defaultBLEServer.discoveredPeripherals[indexPath.row];
            cell.textLabel.text = tmpPeripheral.name;
            cell.detailTextLabel.text = @"";
            cell.accessoryView = nil;
            if (cell.textLabel.text == nil)
                cell.textLabel.text = @"未知";
        }
            break;
    }
    
    return cell;
}


- (void)actionButtonDisconnect1 {
    //NSLog(@"[ConnectViewController] actionButtonDisconnect idx = %d",[sender tag]);
    [[BLEServer defaultBLEServer] disConnect];
    [self.connectedDeviceInfo removeAllObjects];
    [self selectedBtn222];
}
@end
