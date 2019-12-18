//
//  ForgetPwViewController.h
//  app
//
//  Created by zhao on 2019/12/10.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface ForgetPwViewController : UIViewController

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSDictionary *urlDic;//所有相关的接口

@end

NS_ASSUME_NONNULL_END
