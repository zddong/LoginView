//
//  MyView.h
//  LoginDemo
//
//  Created by zhao on 2019/11/20.
//  Copyright © 2019 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MyView;

@interface MyView : UIView
-(instancetype)initWithTitle:title message:messge delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitle:otherTitle;
@end

NS_ASSUME_NONNULL_END
