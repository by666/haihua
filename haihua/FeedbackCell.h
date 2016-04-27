//
//  FeedbackCell.h
//  haihua
//
//  Created by by.huang on 16/4/27.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedbackModel.h"

@interface FeedbackCell : UITableViewCell

-(void)setFeedBackData : (FeedbackModel *)model;

+(NSString *)identify;

@end
