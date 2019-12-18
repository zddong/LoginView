//
//  ChangeUserNameVC.m
//  app
//
//  Created by zhao on 2019/12/11.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "ChangeUserNameVC.h"

#import "CommonTool.h"

@interface ChangeUserNameVC ()
@property (weak, nonatomic) IBOutlet UITextField *userName;

@end

@implementation ChangeUserNameVC

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
  self.navigationItem.title = @"修改用户名";
  self.view.frame = [[UIScreen mainScreen] bounds];
  
  
  
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)ConfrimBtnClick:(UIButton *)sender {
  
  if (self.userName.text.length == 0) {
    
    [[CommonTool currentCommon] AlertWithString:@"请输入用户名" AndViewController:self];
    
  }
  
  if (self.userName.text.length > 5) {
    
    [[CommonTool currentCommon] AlertWithString:@"用户名不允许超过5个字" AndViewController:self];
    
  }
  
  [self UpdateUserNameReques];
  
}


- (void)UpdateUserNameReques{

  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud.label.text = @"请稍后...";
  
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  
  NSString *urlStrinng = self.urlDic[@"changeName"];
  
  NSMutableDictionary *param = [NSMutableDictionary dictionary];
  
  [param setObject:self.token forKey:@"token"];
  [param setObject:self.userName.text forKey:@"uname"];
  
  
  [manager POST:urlStrinng parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
    
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    [hud hideAnimated:YES];
    if ([responseObject[@"success"] boolValue]) {
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
