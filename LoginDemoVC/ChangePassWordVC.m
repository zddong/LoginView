//
//  ChangePassWordVC.m
//  app
//
//  Created by zhao on 2019/12/10.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "ChangePassWordVC.h"

#import "CommonTool.h"

@interface ChangePassWordVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *oldPwEyesImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pwEyesImageView;
@property (weak, nonatomic) IBOutlet UIImageView *confrimEyesImageView;

@property (weak, nonatomic) IBOutlet UITextField *oldPwTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwTextField;
@property (weak, nonatomic) IBOutlet UITextField *confrimTextField;
@property (weak, nonatomic) IBOutlet UIView *oldPwView;


@end

@implementation ChangePassWordVC

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
  self.navigationItem.title = @"修改密码";
  self.view.frame = [[UIScreen mainScreen] bounds];
  
  if ([self.type isEqualToString:@"forget"]) {
    self.oldPwView.hidden = YES;
    self.spaceConstraint.constant = -40.f;
  }
    // Do any additional setup after loading the view from its nib.
}



- (IBAction)ChangeEyesClick:(UIButton *)sender {
  
  if (sender.tag == 100) {
    
    if (self.oldPwTextField.secureTextEntry) {
      self.oldPwTextField.secureTextEntry = NO;
      self.oldPwEyesImageView.image = [UIImage imageNamed:@"open_eyes"];
    } else {
      self.oldPwTextField.secureTextEntry = YES;
      self.oldPwEyesImageView.image = [UIImage imageNamed:@"close_eyes"];
    }
    
  } else if (sender.tag == 101){
  
    if (self.pwTextField.secureTextEntry) {
      self.pwTextField.secureTextEntry = NO;
      self.pwEyesImageView.image = [UIImage imageNamed:@"open_eyes"];
    } else {
      self.pwTextField.secureTextEntry = YES;
      self.pwEyesImageView.image = [UIImage imageNamed:@"close_eyes"];
    }
    
  } else if (sender.tag == 102){
  
    if (self.confrimTextField.secureTextEntry) {
      self.confrimTextField.secureTextEntry = NO;
      self.confrimEyesImageView.image = [UIImage imageNamed:@"open_eyes"];
    } else {
      self.confrimTextField.secureTextEntry = YES;
      self.confrimEyesImageView.image = [UIImage imageNamed:@"close_eyes"];
    }
    
  }
  
}

- (IBAction)ConfrimBtnClick:(UIButton *)sender {
    
  if (![self.type isEqualToString:@"forget"]) {
    if (self.oldPwTextField.text.length == 0) {
      [[CommonTool currentCommon] AlertWithString:@"请输入旧密码" AndViewController:self];
      return;
    }
  }
  if (self.pwTextField.text.length == 0) {
    [[CommonTool currentCommon] AlertWithString:@"请输入新密码" AndViewController:self];
    return;
  }
  if (![CommonTool checkPassWord:self.pwTextField.text]) {
    [[CommonTool currentCommon] AlertWithString:@"密码格式错误" AndViewController:self];
    return;
  }
  if (self.confrimTextField.text.length == 0) {
    [[CommonTool currentCommon] AlertWithString:@"请确认新密码" AndViewController:self];
    return;
  }
  if (![self.confrimTextField.text isEqualToString:self.pwTextField.text]) {
    [[CommonTool currentCommon] AlertWithString:@"新密码不一致" AndViewController:self];
    return;
  }
  
  //处理确认逻辑
  
  [self UpdateForgetPassWord];
    
}

-(void)UpdateForgetPassWord{

  
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud.label.text = @"请稍后...";
  
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  
  NSString *urlStrinng = self.urlDic[@"changePassWord"];
  
  NSMutableDictionary *param = [NSMutableDictionary dictionary];
  if ([self.type isEqualToString:@"forget"]) {
    
    [param setObject:self.sliderCode forKey:@"sliderCode"];
    [param setObject:self.phone forKey:@"phone"];
    [param setObject:self.vCode forKey:@"vCode"];
    
  }else{
    [param setObject:self.oldPwTextField.text forKey:@"password"];
  }
  
  [param setObject:self.token forKey:@"token"];
  [param setObject:self.pwTextField.text forKey:@"newPassword"];
  [param setObject:self.confrimTextField.text forKey:@"newPassword2"];
  
  [manager POST:urlStrinng parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
    
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    [hud hideAnimated:YES];
    if ([responseObject[@"success"] boolValue]) {
      
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
