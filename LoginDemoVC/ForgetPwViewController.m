//
//  ForgetPwViewController.m
//  app
//
//  Created by zhao on 2019/12/10.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "ForgetPwViewController.h"

#import "ChangePassWordVC.h"

@interface ForgetPwViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phone;

@property (weak, nonatomic) IBOutlet UITextField *authCode;

@property (weak, nonatomic) IBOutlet UIButton *getAuthCodeBtn;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *authMessage;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIView *arrowView;
@property (weak, nonatomic) IBOutlet UIImageView *authImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowLeftConnstraint;

@property (nonatomic, strong) NSMutableArray *sliderArr;
@property (nonatomic, strong) NSString *slideCode;

@end

@implementation ForgetPwViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
  self.navigationItem.title = @"忘记密码";
  self.view.frame = [[UIScreen mainScreen] bounds];
  
  self.phone.delegate = self;
  self.authCode.delegate = self;
  
  self.sliderArr = [NSMutableArray array];
  
  [self creatCheckSliderView];
  
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
  
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = NO;
  
}

- (void)creatCheckSliderView{
  UIPanGestureRecognizer *geture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
  [self.arrowView addGestureRecognizer:geture];
}

- (void)handleSwipeFrom:(UIPanGestureRecognizer *)recognizer{
  
  CGPoint point = [recognizer locationInView:self.view];
  
  NSDictionary *dic = @{
                        @"pageX":[NSString stringWithFormat:@"%.f",point.x],
                        @"pageY":[NSString stringWithFormat:@"%.f",point.y],
                        @"time":[CommonTool getCurrentTimeStamp],
                        };
  [self.sliderArr addObject:dic];
  
  if (point.x > 30 && (self.selectView.frame.size.width < self.view.frame.size.width-60)) {
    
    if (point.x < self.view.frame.size.width-45) {
      self.arrowView.center = CGPointMake(point.x, self.arrowView.center.y);
      self.selectView.frame = CGRectMake(self.selectView.frame.origin.x, self.selectView.frame.origin.y, point.x-30, 30);
    }else{
      self.authImage.image = [UIImage imageNamed:@"auth_finish"];
      self.authMessage.text = @"验证通过";
      self.authMessage.textColor = [UIColor whiteColor];
      self.arrowView.center = CGPointMake(self.view.frame.size.width-45, self.arrowView.center.y);
      self.selectView.frame = CGRectMake(self.selectView.frame.origin.x, self.selectView.frame.origin.y, self.view.frame.size.width-60, 30);
      self.arrowLeftConnstraint.constant = self.view.frame.size.width-90;
      self.selectWidthConstraint.constant = self.view.frame.size.width-60;
      
       [self GetSliderCode];
      
    }
    
  }
  
}

-(void)GetSliderCode{
  
  NSString *urlString = [kBaseUrl stringByAppendingPathComponent:kSlideCheck];
  NSMutableDictionary *param = [NSMutableDictionary dictionary];
  [param setObject:[[CommonTool currentCommon] convertToJsonData:self.sliderArr] forKey:@"action"];
  [param setObject:[CommonTool currentCommon].tempToken forKey:@"token"];
  
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  
  [manager POST:urlString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
    if ([responseObject[@"success"] boolValue]) {
      self.slideCode = responseObject[@"data"][@"sliderCode"];
    }
    
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
  }];
  
}


- (IBAction)GetAuthCodeClick:(UIButton *)sender {
  
  if (self.slideCode.length != 0 && self.phone.text.length != 0 && [CommonTool validateMobile:self.phone.text]) {
    
    //发送验证码倒计时
    [self startTime];
    [self GetMessageCode];
    
  }else if (self.phone.text.length == 0){
    
    [[CommonTool currentCommon] AlertWithString:@"请输入手机号" AndViewController:self];
    
  }else if (![CommonTool validateMobile:self.phone.text]){
    
    [[CommonTool currentCommon] AlertWithString:@"请输入正确的手机号" AndViewController:self];
    
  }else{
    
    [[CommonTool currentCommon] AlertWithString:@"请先进行滑块验证" AndViewController:self];
    
  }
}


- (IBAction)NextBtnClick:(UIButton *)sender {
  
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud.label.text = @"校验中...";
  
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

  NSString *urlStrinng = [kBaseUrl stringByAppendingPathComponent:kCheckSms];
  NSMutableDictionary *param = [NSMutableDictionary dictionary];
  [param setObject:self.slideCode forKey:@"sliderCode"];
  [param setObject:self.phone.text forKey:@"phone"];
  [param setObject:@"20" forKey:@"smsType"];
  [param setObject:self.authCode.text forKey:@"vCode"];
  [param setObject:[CommonTool currentCommon].tempToken forKey:@"token"];
  
  [manager GET:urlStrinng parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
    
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
    [hud hideAnimated:YES];
    
    if ([responseObject[@"success"] boolValue]) {
      
      ChangePassWordVC *changeVC = [[ChangePassWordVC alloc] init];
      changeVC.type = @"forget";
      changeVC.phone = self.phone.text;
      changeVC.sliderCode = self.slideCode;
      changeVC.vCode = self.authCode.text;
      changeVC.token = [CommonTool currentCommon].tempToken;
      changeVC.urlDic = self.urlDic;
      [changeVC setHidesBottomBarWhenPushed: YES];
      [self.navigationController pushViewController:changeVC animated:YES];
      
    }
    
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
    [hud hideAnimated:YES];
    
  }];
  
}


-(void)GetMessageCode{
  
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
  NSString *urlStrinng = [kBaseUrl stringByAppendingPathComponent:kSendSms];
  NSMutableDictionary *param = [NSMutableDictionary dictionary];
  [param setObject:self.slideCode forKey:@"sliderCode"];
  [param setObject:self.phone.text forKey:@"phone"];
  [param setObject:@"20" forKey:@"smsType"];
  [param setObject:[CommonTool currentCommon].tempToken forKey:@"token"];
  
  [manager POST:urlStrinng parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
    
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
  }];
}

//验证码计时
-(void)startTime{
  
  __block int timeout=60; //倒计时时间
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
  dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
  dispatch_source_set_event_handler(_timer, ^{
    if(timeout<=0){ //倒计时结束，关闭
      dispatch_source_cancel(_timer);
      dispatch_async(dispatch_get_main_queue(), ^{
        //设置界面的按钮显示 根据自己需求设置
        [self.getAuthCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.getAuthCodeBtn setBackgroundColor:[UIColor blueColor]];
        
        self.getAuthCodeBtn.userInteractionEnabled = YES;
      });
    }else{
      
      int seconds = timeout % 60;
      if (seconds == 0) {
        seconds = 60;
      }
      NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
      dispatch_async(dispatch_get_main_queue(), ^{
        //设置界面的按钮显示 根据自己需求设置
        //NSLog(@"____%@",strTime);
        //                [UIView beginAnimations:nil context:nil];
        //                 [UIView setAnimationDuration:1];
        self.getAuthCodeBtn.titleLabel.text = [NSString stringWithFormat:@"重新发送(%@s)",strTime];
        [self.getAuthCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%@s)",strTime] forState:UIControlStateNormal];
        //[UIView commitAnimations];
        self.getAuthCodeBtn.userInteractionEnabled = NO;
        
      });
      
      timeout--;
    }
  });
  dispatch_resume(_timer);
}


#pragma mark -UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  
  if (textField.tag == 100) {
    
    if (string.length != 0 && self.authCode.text.length !=0) {
      [self.nextBtn setAlpha:1.f];
      self.nextBtn.userInteractionEnabled = YES;
    }else{
      [self.nextBtn setAlpha:0.5f];
      self.nextBtn.userInteractionEnabled = NO;
    }
    
  }else{
    if (string.length != 0 && self.phone.text.length !=0) {
      [self.nextBtn setAlpha:1.f];
      self.nextBtn.userInteractionEnabled = YES;
    }else{
      [self.nextBtn setAlpha:0.5f];
      self.nextBtn.userInteractionEnabled = NO;
    }
  }
  
  return YES;

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
