//
//  MessageCenterTableViewController.m
//  XHWBaseAPI
//
//  Created by iOS on 2017/9/7.
//  Copyright © 2017年 XHW. All rights reserved.
//

#import "MessageCenterTableViewController.h"
#import "NSObject+BGModel.h"
#import "MessageObj.h"
#import "MessageTableViewCell.h"
#import "MessageDetailViewController.h"
#import "JXPopoverView.h"
#import "JXPopoverAction.h"
#import "MBProgressHUD.h"
#import "Utils.h"
#import "SMAlert.h"
#import "HomeWebViewController.h"
#import "CQPlaceholderView.h"
#import "UIView+Toast.h"
@interface MessageCenterTableViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,CQPlaceholderViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic , strong) CQPlaceholderView *placeholderView;

@end

@implementation MessageCenterTableViewController
- (NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
//        MessageObj *obj = [[MessageObj alloc] init];
        _dataArray = [NSMutableArray new];
        NSArray *arr = [MessageObj bg_findAll];
        for (MessageObj *obj in arr) {
            [_dataArray addObject:obj];
        }
//        _dataArray = [NSMutableArray arrayWithArray:arr];
    }
    return (NSMutableArray *)[[_dataArray reverseObjectEnumerator] allObjects];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    _dataArray = nil;
    [self dataArray];
    if (_dataArray.count==0) {
        _placeholderView = [[CQPlaceholderView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) type:CQPlaceholderViewTypeNoGoods delegate:self];
        [self.view addSubview:_placeholderView];
    }
    [self.tableView reloadData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"返回";
    self.navigationItem.backBarButtonItem = backBtn;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
    _tableView.tableFooterView = footView;
    
    [self.view addSubview:_tableView];
    
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    selectedBtn.frame = CGRectMake(0, 0, 30, 30);
    
    [selectedBtn setImage:[UIImage imageNamed:@"Overflow-Icon"] forState:UIControlStateNormal];
    [selectedBtn setImage:[UIImage imageNamed:@"Overflow-Icon"] forState:UIControlStateHighlighted];
    [selectedBtn addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    selectedBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0, 0,-10);
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:selectedBtn];
    
    self.navigationItem.rightBarButtonItem =selectItem;
    
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationAction:) name:@"YOU_GOT_AN_MESSAGE" object:nil];

    self.title = @"消息中心";
    
}

//
//该参数就是发送过来的通知,接到通知后执行的方法
- (void)notificationAction:(NSNotification *)notify
{
    if (notify.userInfo) {
       
            //        MessageObj *obj = [[MessageObj alloc] init];
            _dataArray = [NSMutableArray new];
            NSArray *arr = [MessageObj bg_findAll];
            for (MessageObj *obj in arr) {
                [_dataArray addObject:obj];
            }
        [_placeholderView removeFromSuperview];
        [self.tableView reloadData];
    }
}
- (void)dealloc{
    //移除观察者
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"YOU_GOT_AN_MESSAGE" object:nil];
}


- (void)selectedBtn:(UIButton *)button {
    NSArray *array = [NSArray arrayWithObjects:@"全部已读",@"清空消息", nil];//= [responseObject objectForKey:@"content"];
    //    [[array objectAtIndex:0] objectForKey:@"name"];
    NSArray *arrayImg = [NSArray arrayWithObjects:@"msg",@"del", nil];
    JXPopoverView *popoverView = [JXPopoverView popoverView];
    popoverView.showShade = YES;
    NSMutableArray *jxArray = [[NSMutableArray alloc]init];
    for (int i=0; i <[array count]; i ++)
    {
      
        
        //带图片
        JXPopoverAction *action = [JXPopoverAction actionWithImage:[UIImage imageNamed:[arrayImg objectAtIndex:i]] title:[array objectAtIndex:i] handler:^(JXPopoverAction *action)
                                   {
                                       if ([[array objectAtIndex:i] isEqualToString:@"全部已读"])
                                       {
                                           for (int i =0; i<self.dataArray.count; i++) {
                                               NSMutableDictionary *dict = [self.dataArray[i] bg_keyValuesIgnoredKeys:nil];
                                               [dict setValue:@"1" forKey:@"isRead"];
                                               MessageObj *obj = [MessageObj bg_objectWithDictionary:dict];
                                               NSString *messageID = obj._j_msgid;
                                               [obj bg_updateWhere:@[@"_j_msgid",@"=",messageID]];
                                           }
                                           _dataArray = [NSMutableArray new];
                                           NSArray *arr = [MessageObj bg_findAll];
                                           for (MessageObj *obj in arr) {
                                               [_dataArray addObject:obj];
                                           }
//                                          _dataArray = (NSMutableArray *)[[_dataArray reverseObjectEnumerator] allObjects];
                                           [self.tableView reloadData];
                                          
                                       }
                                       else if ([[array objectAtIndex:i] isEqualToString:@"清空消息"])
                                       {
                                           if (self.dataArray.count == 0) {
                                               return ;
                                           }
                                           
                                           [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
                                           [SMAlert setConfirmBtBackgroundColor:[UIColor redColor]];
                                           [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
                                           [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
                                           [SMAlert setCancleBtTitleColor:[UIColor blackColor]];
                                           [SMAlert setContentTextAlignment:NSTextAlignmentCenter];
                                           [SMAlert showImage:[UIImage imageNamed:@""] content:@"确认清空全部消息？" confirmButton:[SMButton initWithTitle:@"确定" clickAction:^{
                                               self.dataArray = nil;
                                               [MessageObj bg_clear];
                                               
                                               [self.tableView reloadData];
                                               MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                               hud.delegate = self;
                                               hud.mode = MBProgressHUDModeText;
                                               hud.labelText = @"消息已清空";
                                               //当需要消失的时候:
                                               [hud hide:YES afterDelay:1];
                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                   [self.navigationController popViewControllerAnimated:YES];
                                               });
                                               [SMAlert hide];
                                           }] cancleButton:[SMButton initWithTitle:@"取消" clickAction:nil]];
             
                                       }
                               }];
        [jxArray addObject:action];
    }
    
    [popoverView showToView:button withActions:jxArray];
    
    //    [popoverView showToPoint:CGPointMake(250, 120) withActions:jxArray];
        
}

#pragma mark - UITableViewDataSource Methods

#pragma mark 设置有多少分组

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    
    return 1;
    
}


#pragma mark 设置每个分组有多少行

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
//    NSLog(@"-----------%ld",self.dataArray.count);
    return self.dataArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100.0;
}
#pragma mark 设置某行上显示的内容

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cellIdentifier";
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MessageTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    
    MessageObj *dic = self.dataArray[indexPath.row];
    cell.titleLable.text = dic.title;
    cell.timeLabel.text = dic.time;
    cell.bodyLable.text = dic.body;
    if ([dic.isRead isEqualToString:@"1"]) {
        cell.tagView.backgroundColor = [UIColor clearColor];
        cell.titleLable.font = [UIFont systemFontOfSize:16 weight:1];
        cell.titleLable.textColor = [UIColor colorWithRed:68/255.0f green:68/255.0f blue:68/255.0f alpha:1];

    }else{
        cell.tagView.backgroundColor = [UIColor redColor];
        cell.titleLable.font = [UIFont systemFontOfSize:16 weight:1];
        cell.titleLable.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1];

    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    cell.accessoryType = 1;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MessageObj *dic = self.dataArray[indexPath.row];
    NSString *messageID = dic._j_msgid;

//    MessageDetailViewController *megDetail = [[MessageDetailViewController alloc] init];
//    megDetail._j_msgid = messageID;
//    megDetail.megObj = dic;
//    [self.navigationController pushViewController:megDetail animated:YES];
    HomeWebViewController *VC = [[HomeWebViewController alloc] init];
    VC.urlStr = @"http://www.xianghuo.me";
    VC.title = @"消息详情";
        VC._j_msgid = messageID;
        VC.megObj = dic;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark 设置可以进行编辑

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return YES;
    
}
#pragma mark - Delegate - 占位图
/** 占位图的重新加载按钮点击时回调 */
- (void)placeholderView:(CQPlaceholderView *)placeholderView reloadButtonDidClick:(UIButton *)sender{
    switch (placeholderView.type) {
        case CQPlaceholderViewTypeNoGoods:       // 没商品
        {
//            [self.view makeToast:@"正在返回首页"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
            
        case CQPlaceholderViewTypeNoOrder:       // 没有订单
        {
            [self.view makeToast:@"拉到就拉到"];
        }
            break;
            
        case CQPlaceholderViewTypeNoNetwork:     // 没网
        {
            [self.view makeToast:@"没网适合打排位"];
        }
            break;
            
        case CQPlaceholderViewTypeBeautifulGirl: // 妹纸
        {
            [self.view makeToast:@"哦，那你很棒棒哦"];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark 设置编辑的样式

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return UITableViewCellEditingStyleDelete;
    
}

//#pragma mark 设置处理编辑情况
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//
//{
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        // 1. 更新数据
//        
//        [_dataArray removeObjectAtIndex:indexPath.row];
//        
//        
//        
//        // 2. 更新UI
//        
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        
//    }
//    
//    
//    
//}
//
//
//#pragma mark 设置可以移动
//
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//
//{
//    
//    return YES;
//    
//}
//
//#pragma mark 处理移动的情况
////
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
//
//{
//    
//    // 1. 更新数据
//    
//    NSString *title = _dataArray[sourceIndexPath.row];
//    
//    [_dataArray removeObject:title];
//    
//    [_dataArray insertObject:title atIndex:destinationIndexPath.row];
//    
//    
//    
//    // 2. 更新UI
//    [tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
//    
//}

#pragma mark 在滑动手势删除某一行的时候，显示出更多的按钮

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 1 添加一个删除按钮
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
//        NSLog(@"点击了删除");
        [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        [SMAlert setConfirmBtBackgroundColor:[UIColor redColor]];
        [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
        [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
        [SMAlert setCancleBtTitleColor:[UIColor blackColor]];
        [SMAlert setContentTextAlignment:NSTextAlignmentCenter];
        [SMAlert showImage:[UIImage imageNamed:@""] content:@"确认删除此条消息？" confirmButton:[SMButton initWithTitle:@"确定" clickAction:^{
            [_dataArray removeObjectAtIndex:indexPath.row];
            // 1.2 更新UI
            [MessageObj bg_deleteWithRow:self.dataArray.count-indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [SMAlert hide];
            if (_dataArray.count == 0) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }] cancleButton:[SMButton initWithTitle:@"取消" clickAction:nil]];
        // 1.1 更新数据
//        MessageObj *dic = self.dataArray[indexPath.row];
//        dic._j_msgid;
      
        
        
    }];
    
    
    
//    // 2 删除一个置顶按钮
//    
//    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        
//        NSLog(@"点击了置顶");
//        
//        
//        
//        // 2.1 更新数据
//        
//        [_dataArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
//        
//        // 2.2 更新UI
//        
//        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
//        
//        [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
//        
//        //            [tableView reloadData]; 全局刷新
//        
//    }];
//    
//    topRowAction.backgroundColor = [UIColor blueColor];
//    
//    
//    
//    //3 添加一个更多按钮
//    
//    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"更多" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        
//        NSLog(@"点击了更多");
//        
//        
//        
//        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
//        
//    }];
//    
//    moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    
//    
    
    // 将设置好的按钮放到数组中返回
    
    return @[deleteRowAction];
    
    //    return @[deleteRowAction,moreRowAction];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
