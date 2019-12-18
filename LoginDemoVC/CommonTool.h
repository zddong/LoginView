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
