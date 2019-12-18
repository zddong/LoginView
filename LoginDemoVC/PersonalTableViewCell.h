//
//  PersonalTableViewCell.h
//  app
//
//  Created by zhao on 2019/12/10.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonTool.h"


NS_ASSUME_NONNULL_BEGIN

@interface PersonalTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *personalTitle;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *personalValue;


@end

NS_ASSUME_NONNULL_END
