//
//  SystemSettingTableViewController.m
//  OSSforXHW
//
//  Created by iOS on 2017/9/14.
//  Copyright © 2017年 XHW. All rights reserved.
//

#import "SystemSettingTableViewController.h"
#import "ConnectViewController.h"
#import "AppDelegate.h"
#import "CentralScanController.h"
#import "LanguageSettingViewController.h"


@interface SystemSettingTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *data;
@end

@implementation SystemSettingTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"返回";
    self.navigationItem.backBarButtonItem = backBtn;
    self.title = @"系统设置";
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.rowHeight = 60;
    
    UIView *footView = [[UIView alloc] init];
    _tableView.tableFooterView = footView;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

}

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray new];
        NSDictionary *dic1 = @{@"name":@"蓝牙打印机",@"image":@"blue_print"};
        NSDictionary *dic2 = @{@"name":@"蓝牙秤",@"image":@"balance"};
        NSDictionary *dic3 = @{@"name":@"方言设置",@"image":@"blue_print"};


        [_data addObject:dic1];
        [_data addObject:dic2];
        [_data addObject:dic3];
    }
    return _data;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
   UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (_data) {
        
        cell.textLabel.text = _data[indexPath.row][@"name"];
        cell.imageView.image = [UIImage imageNamed:_data[indexPath.row][@"image"]];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0:
        {
            
//            {
//                PrintConnectViewController *con = [[PrintConnectViewController alloc] init];
//                [self.navigationController pushViewController:con animated:YES];
//                
//            }
            AppDelegate *dele = [UIApplication sharedApplication].delegate;
            [self.navigationController pushViewController:dele.mConnBLE animated:YES];
        }
            break;
        case 1:{
            {
                CentralScanController *con = [[CentralScanController alloc] init];
                [self.navigationController pushViewController:con animated:YES];
                
            }
}
            break;
        case 2:{
            {
                LanguageSettingViewController *con = [[LanguageSettingViewController alloc] init];
                [self.navigationController pushViewController:con animated:YES];
                
            }
        }
            break;
        default:
            break;
    }



}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
