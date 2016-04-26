//
//  CommentMsgCell.h
//  haihua
//
//  Created by by.huang on 16/3/21.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"
#import "FeedbackModel.h"

@interface CommentViewCell : UITableViewCell

-(void)setNewsData : (NewsModel *)model;

-(void)setFeedBackData : (FeedbackModel *)model;

+(NSString *)identify;

@end
