//
//  BingPhoneNextVC.m
//  app
//
//  Created by zhao on 2019/12/12.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "BingPhoneNextVC.h"

@interface BingPhoneNextVC ()

@property (weak, nonatomic) IBOutlet UILabel *phoneSource;

@property (weak, nonatomic) IBOutlet UIButton *getAuthCodeBtn;

@end

@implementation BingPhoneNextVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
  self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
  self.navigationItem.title = @"绑定手机号";
  self.view.frame = [[UIScreen mainScreen] bounds];
  
  self.phoneSource.text = [NSString stringWithFormat:@"验证码来自手机号%@",self.phone];
  
  [self SendMessageCode];
  [self startTime];
  
    // Do any additional setup after loading the view from its nib.
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
        [self.getAuthCodeBtn setTitleColor:[UIColor colorWithRed:67/255.f green:153/255.f blue:237/255.f alpha:1.f] forState:UIControlStateNormal];
       
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
        self.getAuthCodeBtn.titleLabel.text = [NSString stringWithFormat:@"%@s后重新获取验证码",strTime];
        [self.getAuthCodeBtn setTitle:[NSString stringWithFormat:@"%@s后重新获取验证码",strTime] forState:UIControlStateNormal];
         [self.getAuthCodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        //[UIView commitAnimations];
        self.getAuthCodeBtn.userInteractionEnabled = NO;
        
      });
      
      timeout--;
    }
  });
  dispatch_resume(_timer);
}

-(void)SendMessageCode{
  
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
  NSString *urlStrinng = self.urlDic[@"sendSms"];
  NSMutableDictionary *param = [NSMutableDictionary dictionary];
  [param setObject:self.slideCode forKey:@"sliderCode"];
  [param setObject:self.phone forKey:@"phone"];
  [param setObject:@"30" forKey:@"smsType"];
  [param setObject:self.token forKey:@"token"];
  
  [manager POST:urlStrinng parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
    
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
  }];
}

- (IBAction)SendAuthCodeClick:(UIButton *)sender {
  
  [self SendMessageCode];
  [self startTime];
  
}

//绑定手机号接口
- (IBAction)BindPhoneClick:(UIButton *)sender {
    
    
    
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
