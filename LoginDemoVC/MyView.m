//
//  MyView.m
//  LoginDemo
//
//  Created by zhao on 2019/11/20.
//  Copyright © 2019 zhao. All rights reserved.
//

#import "MyView.h"

@implementation MyView

-(instancetype)initWithTitle:title message:messge delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitle:otherTitle
{
    if (self=[super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame]) {
       
        self.backgroundColor = [UIColor purpleColor];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
