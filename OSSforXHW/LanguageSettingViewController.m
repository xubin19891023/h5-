//
//  LanguageSettingViewController.m
//  OSSforXHW
//
//  Created by iOS on 2017/10/10.
//  Copyright © 2017年 XHW. All rights reserved.
//

#import "LanguageSettingViewController.h"
#import "MBProgressHUD.h"
@interface LanguageSettingViewController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *data;

@end

@implementation LanguageSettingViewController
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
    self.title = @"方言设置";
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.rowHeight = 50;
    
    UIView *footView = [[UIView alloc] init];
    _tableView.tableFooterView = footView;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray new];
        NSDictionary *dic1 = @{@"name":@"普通话"};
        NSDictionary *dic2 = @{@"name":@"广东话"};
        NSDictionary *dic3 = @{@"name":@"四川话"};
        NSDictionary *dic4 = @{@"name":@"河南话"};
        
        [_data addObject:dic1];
        [_data addObject:dic2];
        [_data addObject:dic3];
        [_data addObject:dic4];

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
//        cell.imageView.image = [UIImage imageNamed:_data[indexPath.row][@"image"]];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *tag ;
    NSString *fangyan;
    if (_data) {
        if (_data[indexPath.row][@"name"]) {
            tag = _data[indexPath.row][@"name"];
//            NSLog(@"------tag is %@",tag);
        }
        if ([tag isEqualToString:@"普通话"]) {
            fangyan = @"普通话";
            
        }else if([tag isEqualToString:@"广东话"]){
            fangyan = @"广东话";
            
        }else if([tag isEqualToString:@"四川话"]){
            fangyan = @"四川话";
            
        }else if([tag isEqualToString:@"河南话"]){
            fangyan = @"河南话";
            
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:fangyan forKey:@"fangyan"];
        [defaults synchronize];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.delegate = self;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"已设置成%@",_data[indexPath.row][@"name"]];
        //当需要消失的时候:
        [hud hide:YES afterDelay:1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
//        NSLog(@"------ is %@",[defaults objectForKey:@"fangyan"]);

    }
    
}
@end
