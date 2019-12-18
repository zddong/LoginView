//
//  BindPhoneViewController.m
//  app
//
//  Created by zhao on 2019/12/12.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "BindPhoneViewController.h"

#import "BingPhoneNextVC.h"

@interface BindPhoneViewController ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *authMessage;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIView *arrowView;
@property (weak, nonatomic) IBOutlet UIImageView *authImage;

@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowLeftConnstraint;


@property (nonatomic, strong) NSMutableArray *sliderArr;
@property (nonatomic, strong) NSString *slideCode;

@end

@implementation BindPhoneViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
  self.navigationItem.title = @"绑定手机号";
  self.view.frame = [[UIScreen mainScreen] bounds];
  
  self.phone.delegate = self;
  
  [self creatCheckSliderView];
  
  self.sliderArr = [NSMutableArray array];
  
  // Do any additional setup after loading the view from its nib.
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
      if (self.phone.text.length != 0) {
        [self.nextBtn setAlpha:1.f];
        self.nextBtn.userInteractionEnabled = YES;
      }
      
      [self GetSliderCode];
      
    }
    
  }
  
}

-(void)GetSliderCode{
  
  NSString *urlString = self.urlDic[@"checkSlider"];
  NSMutableDictionary *param = [NSMutableDictionary dictionary];
  [param setObject:[[CommonTool currentCommon] convertToJsonData:self.sliderArr] forKey:@"action"];
  [param setObject:self.token forKey:@"token"];
  
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  
  [manager POST:urlString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
    if ([responseObject[@"success"] boolValue]) {
      self.slideCode = responseObject[@"data"][@"sliderCode"];
    }
    
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
  }];
  
}


- (IBAction)NextBtnClick:(UIButton *)sender {
  
  if (self.phone.text.length == 0) {
    [[CommonTool currentCommon] AlertWithString:@"请输入手机号" AndViewController:self];
    return;
  }
  if (![CommonTool validateMobile:self.phone.text]) {
    [[CommonTool currentCommon] AlertWithString:@"手机号格式有误" AndViewController:self];
    return;
  }
  
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
  BingPhoneNextVC *nextVC = [[BingPhoneNextVC alloc] init];
  nextVC.phone = self.phone.text;
  nextVC.token = self.token;
  nextVC.slideCode = self.slideCode;
  nextVC.urlDic = self.urlDic;
  [nextVC setHidesBottomBarWhenPushed:YES];
  [self.navigationController pushViewController:nextVC animated:YES];
  
}


#pragma mark UItextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  if (string.length != 0 && self.slideCode.length != 0) {
    [self.nextBtn setAlpha:1.f];
    self.nextBtn.userInteractionEnabled = YES;
  }else{
    [self.nextBtn setAlpha:0.5f];
    self.nextBtn.userInteractionEnabled = NO;
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
