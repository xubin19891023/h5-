//
//  MessageDetailViewController.m
//  XHWBaseAPI
//
//  Created by iOS on 2017/9/9.
//  Copyright © 2017年 XHW. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "Utils.h"
@interface MessageDetailViewController ()

@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [Utils getColor:@"0726e7"];
    NSMutableDictionary *dict = [self.megObj bg_keyValuesIgnoredKeys:nil];
    [dict setValue:@"1" forKey:@"isRead"];
    MessageObj *obj = [MessageObj bg_objectWithDictionary:dict];
    [obj bg_updateWhere:@[@"_j_msgid",@"=",__j_msgid]];
    
    self.title = @"消息详情";
    self.navigationController.navigationItem.backBarButtonItem.title = @"返回";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
