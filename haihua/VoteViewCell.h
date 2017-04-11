//
//  VoteViewCell.h
//  haihua
//
//  Created by by.huang on 2017/3/15.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgModel.h"

@interface VoteViewCell : UITableViewCell

-(void)setNewsData : (MsgModel *)model;

+(NSString *)identify;


@end
