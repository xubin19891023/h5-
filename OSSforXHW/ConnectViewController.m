//
//  ConnectViewController.m
//  BLETR
//
//  Created by D500 user on 12/9/26.
//  Copyright (c) 2012 ISSC Technologies Corporation. All rights reserved.
//
#import "AppDelegate.h"
#import "ConnectViewController.h"
#import "BLKWrite.h"
#import "Config.h"
@interface ConnectViewController ()

@end

@implementation ConnectViewController
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
//            self.edgesForExtendedLayout = UIRectEdgeNone;
//        }
//
//        connectedDeviceInfo = [NSMutableArray new];
//        connectingList = [NSMutableArray new];
//
//        deviceInfo = [[DeviceInfo alloc]init];
//        refreshDeviceListTimer = nil;
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    connectedDeviceInfo = [NSMutableArray new];
    connectingList = [NSMutableArray new];
    
    deviceInfo = [[DeviceInfo alloc]init];
    refreshDeviceListTimer = nil;

    // Do any additional setup after loading the view from its nib.
    self.title = @"蓝牙打印机";
    self.navigationItem.leftBarButtonItem.title = @"返回";
    
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    selectedBtn.frame = CGRectMake(0, 0, 30, 30);
    [selectedBtn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [selectedBtn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateHighlighted];
    [selectedBtn addTarget:self action:@selector(refreshDeviceList:) forControlEvents:UIControlEventTouchUpInside];
    selectedBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0, 0,-10);
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:selectedBtn];
    self.navigationItem.rightBarButtonItem =selectItem;

    self.devicesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -64)];
    self.devicesTableView.delegate = self;
    self.devicesTableView.dataSource = self;
    self.devicesTableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [self.view addSubview:self.devicesTableView];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1,1)];
    self.devicesTableView.tableFooterView = footview;
 
    
//   自动打印开关
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.devicesTableView.bounds.size.width, 50)];
//    headerView.backgroundColor = [UIColor redColor];
    self.devicesTableView.tableHeaderView = headerView;
    UILabel *autoPrint = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, headerView.bounds.size.width/2, 50)];
    autoPrint.text = @"自动打印";
    autoPrint.font = [UIFont systemFontOfSize:16];
    autoPrint.textAlignment = 0;
    [headerView addSubview:autoPrint];
    
     UISwitch *switchView = [[UISwitch alloc]initWithFrame:CGRectMake(headerView.bounds.size.width - 70, 10, 100, 30)];
   
    //设置自动打印初始化
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults valueForKey:@"zidongdayin"]) {
        switchView.on = NO;

    }else if([[defaults valueForKey:@"zidongdayin"] isEqualToString:@"5"]){
        
        switchView.on = YES;

    }else{
        switchView.on = NO;

    }
    
     [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [headerView addSubview:switchView];

}
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        NSLog(@"开");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:@"5" forKey:@"zidongdayin"];
        [defaults synchronize];
    }else {
        NSLog(@"关");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:@"6" forKey:@"zidongdayin"];
        [defaults synchronize];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}
- (void)viewDidAppear:(BOOL)animated {
    
    [self startScan];
}

- (void)viewDidUnload
{
    [_devicesTableView release];
    _devicesTableView = nil;
    [super viewDidUnload];
  
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    NSLog(@"[ConnectViewController] didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    
    [_devicesTableView release];
    [super dealloc];
}

- (void) displayDevicesList {
    
    [_devicesTableView reloadData];
}

- (void)startScan {
    [super startScan];
    
    if ([connectingList count] > 0) {
        for (int i=0; i< [connectingList count]; i++) {
            MyPeripheral *connectingPeripheral = [connectingList objectAtIndex:i];
            
            if (connectingPeripheral.connectStaus == MYPERIPHERAL_CONNECT_STATUS_CONNECTING) {
                //NSLog(@"startScan add connecting List: %@",connectingPeripheral.advName);
                [devicesList addObject:connectingPeripheral];
            }
            else {
                [connectingList removeObjectAtIndex:i];
                //NSLog(@"startScan remove connecting List: %@",connectingPeripheral.advName);
            }
        }
    }
}

- (void)stopScan {
   
    [super stopScan];
    if (refreshDeviceListTimer) {
        [refreshDeviceListTimer invalidate];
        refreshDeviceListTimer = nil;
    }
}

-(void)popToRootPage {
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if (appDelegate.pageTransition == FALSE) {
//        [[appDelegate navigationController] popToRootViewControllerAnimated:NO];
//    }
//    else {
//        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(popToRootPage) userInfo:nil repeats:NO];
//    }
}

- (void)updateDiscoverPeripherals {
    [super updateDiscoverPeripherals];
    [_devicesTableView reloadData];
}

- (void)updateMyPeripheralForDisconnect:(MyPeripheral *)myPeripheral {
//    NSLog(@"updateMyPeripheralForDisconnect");//, %@", myPeripheral.advName);
    if (myPeripheral == controlPeripheral) {
        [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(popToRootPage) userInfo:nil repeats:NO];
    }
    
    for (int idx =0; idx< [connectedDeviceInfo count]; idx++) {
        DeviceInfo *tmpDeviceInfo = [connectedDeviceInfo objectAtIndex:idx];
        if (tmpDeviceInfo.myPeripheral == myPeripheral) {
            [connectedDeviceInfo removeObjectAtIndex:idx];
            //NSLog(@"updateMyPeripheralForDisconnect1");
            break;
        }
    }
    
    for (int idx =0; idx< [connectingList count]; idx++) {
        MyPeripheral *tmpPeripheral = [connectingList objectAtIndex:idx];
        if (tmpPeripheral == myPeripheral) {
            [connectingList removeObjectAtIndex:idx];
            //NSLog(@"updateMyPeripheralForDisconnect2");
            break;
        }
        else{
            //NSLog(@"updateMyPeripheralForDisconnect3 %@, %@", tmpPeripheral.advName, myPeripheral.advName);
        }
        
    }

    [self displayDevicesList];
    
 }

- (void)updateMyPeripheralForNewConnected:(MyPeripheral *)myPeripheral {
    
    [[BLKWrite Instance] setPeripheral:myPeripheral];
    
    NSLog(@"[ConnectViewController] updateMyPeripheralForNewConnected");
    DeviceInfo *tmpDeviceInfo = [[DeviceInfo alloc]init];
    tmpDeviceInfo.myPeripheral = myPeripheral;
    tmpDeviceInfo.myPeripheral.connectStaus = myPeripheral.connectStaus;
    
   /*Connected List Filter*/
    bool b = FALSE;
    for (int idx =0; idx< [connectedDeviceInfo count]; idx++) {
        DeviceInfo *tmpDeviceInfo = [connectedDeviceInfo objectAtIndex:idx];
        if (tmpDeviceInfo.myPeripheral == myPeripheral) {
            b = TRUE;
            break;
        }
    }
    if (!b) {
        [connectedDeviceInfo addObject:tmpDeviceInfo];
    }
    else{
        NSLog(@"Connected List Filter!");
    }
    
    for (int idx =0; idx< [connectingList count]; idx++) {
        MyPeripheral *tmpPeripheral = [connectingList objectAtIndex:idx];
        if (tmpPeripheral == myPeripheral) {
            //NSLog(@"connectingList removeObject:%@",tmpPeripheral.advName);
            [connectingList removeObjectAtIndex:idx];
            break;
        }
    }
    
    for (int idx =0; idx< [devicesList count]; idx++) {
        MyPeripheral *tmpPeripheral = [devicesList objectAtIndex:idx];
        if (tmpPeripheral == myPeripheral) {
            //NSLog(@"devicesList removeObject:%@",tmpPeripheral.advName);
            [devicesList removeObjectAtIndex:idx];
            break;
        }
    }
    [self displayDevicesList];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section

{
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.font = [UIFont systemFontOfSize:13];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

// DataSource methods
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"[ConnectViewController] numberOfRowsInSection,device count = %d", [devicesList count]);
    NSLog(@"----------33333----🐶%ld",connectedDeviceInfo.count);

    switch (section) {
        case 0:
            return [connectedDeviceInfo count];
        case 1:
            return [devicesList count];
        default:
            return 0;
        }
    }

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            //NSLog(@"[ConnectViewController] CellForRowAtIndexPath section 0, Row = %d",[indexPath row]);
            cell = [tableView dequeueReusableCellWithIdentifier:@"connectedList"];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"connectedList"] autorelease];
            }
            DeviceInfo *tmpDeviceInfo = [connectedDeviceInfo objectAtIndex:indexPath.row];
            cell.textLabel.text = tmpDeviceInfo.myPeripheral.advName;
            cell.detailTextLabel.text = @"已连接";
            cell.accessoryView = nil;
            if (cell.textLabel.text == nil)
                cell.textLabel.text = @"未知";
            
            UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [accessoryButton addTarget:self action:@selector(actionButtonDisconnect:)  forControlEvents:UIControlEventTouchUpInside];
            accessoryButton.tag = indexPath.row;
            [accessoryButton setTitle:@"断开连接" forState:UIControlStateNormal];
            [accessoryButton setFrame:CGRectMake(0,0,100,35)];
            cell.accessoryView  = accessoryButton;
      
        }
            break;
            
        case 1:
        {
    
            cell = [tableView dequeueReusableCellWithIdentifier:@"devicesList"];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"devicesList"] autorelease];
            }
            MyPeripheral *tmpPeripheral = [devicesList objectAtIndex:indexPath.row];
            cell.textLabel.text = tmpPeripheral.advName;
            cell.detailTextLabel.text = @"";
            cell.accessoryView = nil;
            if (cell.textLabel.text == nil)
                cell.textLabel.text = @"未知";
        }
            break;
    }
    return cell;
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


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            deviceInfo = [connectedDeviceInfo objectAtIndex:indexPath.row];
            controlPeripheral = deviceInfo.myPeripheral;
            [self stopScan];
            if (refreshDeviceListTimer) {
                [refreshDeviceListTimer invalidate];
                refreshDeviceListTimer = nil;
            }
         
        }
            break;
        case 1:
        {
            //Derek
            NSUInteger count = [devicesList count];
            if ((count != 0) && count > indexPath.row) {
                MyPeripheral *tmpPeripheral = [devicesList objectAtIndex:indexPath.row];
                [self connectDevice:tmpPeripheral];
                [devicesList replaceObjectAtIndex:indexPath.row withObject:tmpPeripheral];
                [connectingList addObject:tmpPeripheral];
                [self displayDevicesList];
            }
            break;
        }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refreshDeviceList:(id)sender {
//    NSLog(@"[ConnectViewController] refreshDeviceList");
        [self stopScan];
        [self startScan];
        [_devicesTableView reloadData];
}

//Derek
- (void)actionButtonDisconnect:(id)sender {
//    NSLog(@"[ConnectViewController] actionButtonDisconnect idx = %d",[sender tag]);
    NSUInteger idx = [sender tag];
    DeviceInfo *tmpDeviceInfo = [connectedDeviceInfo objectAtIndex:idx];
    [self disconnectDevice:tmpDeviceInfo.myPeripheral];
}

@end
