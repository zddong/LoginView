//
//  PersonalViewController.m
//  LoginDemo
//
//  Created by zhao on 2019/11/25.
//  Copyright © 2019 zhao. All rights reserved.
//

#import "PersonalViewController.h"
#import "SDWebImage.h"

#define leftSpace 20

@interface PersonalViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];

    
    NSArray *arr = @[@{
                         @"name":@"实名信息",
                         @"value":@"已实名"
                         },@{
                         @"name":@"账号信息",
                         @"value":@"未完善"
                         },@{
                         @"name":@"账号管理",
                         @"value":@"已实名"
                         },@{
                         @"name":@"清除缓存",
                         @"value":@"已实名"
                         },@{
                         @"name":@"退出登录",
                         @"value":@"退出登录"
                         }];
    self.dataArr = [NSMutableArray arrayWithArray:arr];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView reloadData];
    
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

#pragma mark - UITableViewDataSource

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    NSDictionary *item = self.dataArr[indexPath.row];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1574745021298&di=8c3e2ba35d8d1cd7a5c13f7226afbbbf&imgtype=0&src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2F3082ac27c9139ea7b80b1c88f31ea86f8531f25611dcf-Owa1Zu_fw658"]];
    
    cell.textLabel.text = item[@"name"];
    
    
    return cell;
    
}


@end
