//
//  CommonTool.m
//  app
//
//  Created by zhao on 2019/12/9.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "CommonTool.h"
#import <UIKit/UIKit.h>

@interface CommonTool ()

@end

@implementation CommonTool

+(instancetype)currentCommon
{
  static CommonTool *common;
  
  //单次运行代码块
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    
    if (!common) {
      
      common = [[CommonTool alloc] init];
    }
    
  });
  
  return common;
}

+(BOOL)isLogin
{
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  NSString *username = [userDefaults stringForKey:@"username"];
  NSString *password = [userDefaults stringForKey:@"password"];
  NSString *phoneLogin = [userDefaults stringForKey:@"phoneLogin"];
  
  if ((username.length != 0 && password.length != 0) || phoneLogin.length != 0 ) {
    
    return YES;
    
  }else
  {
    return NO;
  }
}

#pragma mark - 校验手机号
+ (BOOL)validateMobile:(NSString *)mobile
{
  // 130-139  150-153,155-159  180-189  145,147  170,171,173,176,177,178
  NSString *phoneRegex = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
  NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
  return [phoneTest evaluateWithObject:mobile];
}

#pragma mark - 校验密码
+(BOOL)checkPassWord:(NSString *)password{
  
  NSString *pwRegex = @"^(?=.*[a-zA-Z0-9].*)(?=.*[a-zA-Z\\W].*)(?=.*[0-9\\W].*).{6,18}$";
  NSPredicate *pwTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pwRegex];
  return [pwTest evaluateWithObject:password];
  
}



#pragma mark - 弹出提示信息
//弹出提示信息
- (void)AlertWithString:(NSString *)msg AndViewController:(id)controller
{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
  
  [alertController addAction:actionA];
  
  
  [controller presentViewController:alertController animated:YES completion:nil];
  
}


+(NSUInteger)GetCacheSize{
  
  float size = 0;
  NSString *path;
  NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
  NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:DocumentsPath];
  for (NSString *fileName in enumerator) {
    //        NSLog(@"文件名：%@",fileName);
    path = [DocumentsPath stringByAppendingPathComponent:fileName];
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    size=size+(float)[fileAttributes fileSize];
  }
  
  
  NSString *path2 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
  NSFileManager *manager = [NSFileManager defaultManager];
  // 获取该路径下的所有文件, 删除的时候，可以直接删除文件夹，计算的时候不能直接计算文件夹的大小, 所以用subpathsAtPath 方法。正好拿不到Snapshots。删除的时候也删除不了这里面的东西，所以刚好对上。
  NSArray *allSubPathArray = [manager subpathsAtPath:path2];
  long long cachesSize = 0;
  for (NSString *subPath in allSubPathArray) {
    NSString *subPathString = [path2 stringByAppendingPathComponent:subPath];
    NSDictionary *subCachesDic = [manager attributesOfItemAtPath:subPathString error:nil];
    // 得出的结果是B 最后要转成K 再转成 M
    cachesSize += subCachesDic.fileSize;
  }
  
  
  NSURLCache *httpCache = [NSURLCache sharedURLCache];
  //+[httpCache currentDiskUsage]
  NSUInteger caches =size+cachesSize;
  
  return caches;
  
}
+(void)clearCache{
  
  NSURLCache *httpCache = [NSURLCache sharedURLCache];
  [httpCache removeAllCachedResponses];
  
  NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
  NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:documentsPath];
  for (NSString *fileName in enumerator) {
          [[NSFileManager defaultManager] removeItemAtPath:[documentsPath stringByAppendingPathComponent:fileName] error:nil];
  }
  
  NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
  NSDirectoryEnumerator *enumerator2 = [[NSFileManager defaultManager] enumeratorAtPath:path];
  for (NSString *fileName in enumerator2) {
    [[NSFileManager defaultManager] removeItemAtPath:[path stringByAppendingPathComponent:fileName] error:nil];
  }
  
}

+(NSString *)getCurrentTimeStamp{
  
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  
  [formatter setDateFormat:@"yyyyMMddHHmmss"];
  
  NSString *str = [formatter stringFromDate:[NSDate date]];
  
  return str;
}


+(id)dictionaryWithJsonString:(NSString *)jsonString
{
  if (jsonString == nil) {
    return nil;
  }
  
  NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
  NSError *err;
  NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                      options:NSJSONReadingMutableContainers
                                                        error:&err];
  if(err)
  {
    NSLog(@"json解析失败：%@",err);
    return nil;
  }
  return dic;
}

-(NSString *)convertToJsonData:(id)dict{
  
  NSError *error;
  
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
  
  NSString *jsonString;
  
  if (!jsonData) {
    
    NSLog(@"%@",error);
    
  }else{
    
    jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
  }
  
  NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
  
  NSRange range = {0,jsonString.length};
  
  //去掉字符串中的空格
  
  [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
  
  NSRange range2 = {0,mutStr.length};
  
  //去掉字符串中的换行符
  
  [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
  
  return mutStr;
  
}


-(void)GetTempTokenString{

  self.tempToken = @"";
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  
  NSString *urlStrinng = [kBaseUrl stringByAppendingPathComponent:kTempToken];
  [manager GET:urlStrinng parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    if ([responseObject[@"success"] boolValue]) {
      self.tempToken = responseObject[@"data"];
      [[NSUserDefaults standardUserDefaults] setObject:self.tempToken forKey:@"token"];
      [[NSUserDefaults standardUserDefaults] synchronize];
    }
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
  }];
  
}


@end
