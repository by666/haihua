//
//  CommentMsgCell.h
//  haihua
//
//  Created by by.huang on 16/3/21.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface CommentViewCell : UITableViewCell

-(void)setData : (MessageModel *)model;

+(NSString *)identify;

@end
