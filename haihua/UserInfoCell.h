//
//  UserInfoCell.h
//  haihua
//
//  Created by by.huang on 16/3/29.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserTableModel.h"
@interface UserInfoCell : UITableViewCell

-(void)setData : (UserTableModel *)model;

-(void)hideLine;

+(NSString *)identify;

@end
