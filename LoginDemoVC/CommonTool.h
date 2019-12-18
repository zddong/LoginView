//
//  CommonTool.h
//  app
//
//  Created by zhao on 2019/12/9.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"


//测试
#define kBaseUrl  @"http://114.248.78.102:9100/urmp"
//正式
//#define kBaseUrl  @"https://cloud.bjshfb.com/urmp"

//获取临时token
#define kTempToken  @"login/un/token"
//更新二维码登录状态
#define kUpdateQrcode  @"login/qrcode/login"
//用户注册
#define kRegister  @"login/un/register"
//用户口令登录
#define kPwLogin  @"login/un/password"
//手机验证码登录
#define kSmsLogin  @"login/un/sms"
//退出登录
#define kLoginOut  @"login/out"
//滑块验证
#define kSlideCheck  @"login/un/slide/check"
//发送短信验证码
#define kSendSms  @"sms/un/send"
//短信验证码校验
#define kCheckSms  @"sms/un/check"
//忘记密码
#define kForgetUpdate  @"login/un/forget/update"
//口令修改密码
#define kPwUpdate  @"user/password/update"
//校验用户名
#define kCheckName  @"login/un/name/check"

NS_ASSUME_NONNULL_BEGIN

@interface CommonTool : NSObject

@property (nonatomic, strong) NSString *tempToken;

//创建单例对象
+(instancetype) currentCommon;

//用来判断登录状态
+(BOOL) isLogin;

//校验手机号
+(BOOL)validateMobile:(NSString *)mobile;

//校验密码
+(BOOL)checkPassWord:(NSString *)password;

//获取手机缓存
+(NSUInteger)GetCacheSize;

//清除手机缓存
+(void)clearCache;

//获取当前事件戳
+(NSString *)getCurrentTimeStamp;

//弹出提示信息
- (void)AlertWithString:(NSString *)msg AndViewController:(id)controller;

//json字符串转化为对象
+ (id)dictionaryWithJsonString:(NSString *)jsonString;
//对象转化为json字符串
-(NSString *)convertToJsonData:(id)dict;

-(void)GetTempTokenString;

@end

NS_ASSUME_NONNULL_END
