//
//  SettingViewController.m
//  app
//
//  Created by zhao on 2019/12/11.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "SettingViewController.h"

#import "CommonTool.h"
//#import "MainTabbarController.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cacheSize;

@end

@implementation SettingViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
  self.navigationItem.title = @"设置";
  self.view.frame = [[UIScreen mainScreen] bounds];
  
  float cache = [CommonTool GetCacheSize]/1024;
  self.cacheSize.text = [NSString stringWithFormat:@"%.fM",cache];
  
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  
}

//清除缓存
- (IBAction)ClearCacheClick:(UIButton *)sender {
  
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否确定清除缓存？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
    [CommonTool clearCache];
    self.cacheSize.text = @"0M";
    
  }];
  UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
  
  [alertController addAction:actionA];
  [alertController addAction:actionB];
  
  [self presentViewController:alertController animated:YES completion:nil];
  
}


//退出登录
- (IBAction)LoginOutClick:(UIButton *)sender {
  
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定退出登录？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
    [self LoginOutRequest];
    
  }];
  
  UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
  
  [alertController addAction:actionA];
  [alertController addAction:actionB];
  
  [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)LoginOutRequest{

  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud.label.text = @"退出登录...";
  
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  
  NSString *urlStrinng = [kBaseUrl stringByAppendingPathComponent:kLoginOut];
  NSMutableDictionary *param = [NSMutableDictionary dictionary];
  
  [param setObject:self.token forKey:@"token"];
  
  [manager POST:urlStrinng parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
    [hud hideAnimated:YES];
    if ([responseObject[@"success"] boolValue]) {
      
      [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"username"];
      [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
      [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"phoneLogin"];
      [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"token"];
      [[NSUserDefaults standardUserDefaults] synchronize];
      
//      MainTabbarController *tab = (MainTabbarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//      tab.selectedIndex = 0;
      
      [self.navigationController popViewControllerAnimated:YES];
      
    }
    
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    [hud hideAnimated:YES];
  }];
  
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
